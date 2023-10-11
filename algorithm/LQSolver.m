classdef LQSolver < handle
    properties
        xsol        % state increment
        usol        % control increment
        Ksol        % feedback matrix
        lvsol       % feedforward term
        lqp         % LQ problem        
        Ssol        % Hessian of Value function
        svsol       % gradient of value function       
        hsol
        Hsol
        s_o1        % expected cost change first order
        s_o2        % expected cost change second order
        s_o1_d
        s_o2_d       
    end
    
    methods
        function sol = LQSolver()
            % Do nothing. Empty constructor                        
        end

        function set_LQ_problem(sol, lqpb_in)
            sol.lqp = lqpb_in;
            % Initiliaze the solution
            sol.xsol = repmat({zeros(sol.lqp.x_sz, 1)}, [1,sol.lqp.tau_sz]);
            sol.usol = repmat({zeros(sol.lqp.u_sz, 1)}, [1,sol.lqp.tau_sz]);
            sol.Ksol = repmat({zeros(sol.lqp.u_sz, sol.lqp.x_sz)}, [1, sol.lqp.tau_sz]);
            sol.lvsol = repmat({zeros(sol.lqp.u_sz, 1)}, [1,sol.lqp.tau_sz]);
            sol.Ssol = repmat({zeros(sol.lqp.x_sz, sol.lqp.x_sz)}, [1, sol.lqp.tau_sz]);
            sol.svsol = repmat({zeros(sol.lqp.x_sz, 1)}, [1,sol.lqp.tau_sz]);           
            sol.hsol = repmat({zeros(sol.lqp.x_sz, 1)}, [1,sol.lqp.tau_sz]);
            sol.Hsol = repmat({zeros(sol.lqp.x_sz, sol.lqp.x_sz)}, [1, sol.lqp.tau_sz]);
        end
        
        function update_LQ_problem(sol, lqpb_in)            
            % Check if the problem size changed
            if sol.lqp.x_sz ~= lqpb_in.x_sz
                fprintf("New LQ problem has different state size \n")
                return;
            end

            if sol.lqp.u_sz ~= lqpb_in.u_sz
                fprintf("New LQ problem has different control size \n")
                return;
            end
            
            if sol.lqp.tau_sz ~= lqpb_in.tau_sz
                fprintf("New LQ problem has different trajectory size \n")
                return;
            end

            sol.lqp = lqpb_in;            
        end

        function success = solve(sol, lq_solver_setting, use_second_order)
            success = false;
            regularization = 0;          

            while ~success
                success = sol.backward_ricatti(regularization, lq_solver_setting, use_second_order);
                if success == 0
                regularization = max(regularization*4, 1e-3);
                end        

                if regularization > 1e20
                    fprintf("regularization fails \n");
                    break;
                end
            end
            
            sol.forward_sweep();
        end

        function success = backward_ricatti(sol, regularization, lq_solver_setting, use_second_order)
            %Solve the backward ricatti recursion
            
            % Initialize the quad approx of value funcion, S, sv, and s
            lqp_ = sol.lqp;
            S_prime = lqp_.QN;
            sv_prime = lqp_.qvN;            
            sol.Ssol{end} = S_prime;
            sol.svsol{end} = sv_prime;           
            tau_sz = lqp_.tau_sz;
            sol.s_o1 = 0;
            sol.s_o2 = 0;             
            success = true;           
            for k = tau_sz-1:-1:1                                          
                sv_prime = sv_prime + S_prime*lqp_.d{k+1};                

                % Standard Q function
                Qu = lqp_.rv{k} + lqp_.B{k}'*sv_prime;
                Qx = lqp_.qv{k} + lqp_.A{k}'*sv_prime;
                Qux = lqp_.S{k}  + lqp_.B{k}'*S_prime*lqp_.A{k};
                Quu = lqp_.R{k}  + lqp_.B{k}'*S_prime*lqp_.B{k};   
                Qxx = lqp_.Q{k} + lqp_.A{k}'*S_prime*lqp_.A{k};
                                
                if use_second_order
                    [quad_xx, quad_uu, quad_ux] = lq_solver_setting.second_order_dynamics(lqp_.x_nloc{k}, lqp_.u_nloc{k}, sv_prime);
                    Qux = Qux + quad_ux;
                    Quu = Quu + quad_uu;   
                    Qxx = Qxx + quad_xx;
                end
                Quu = Quu + eye(lqp_.u_sz) * regularization;
                Qxx = Qxx + eye(lqp_.x_sz) * regularization;                
                % Truncate numerical errors for symmetric matrices
                Quu = symm(Quu);
                               
                lv = -Quu\Qu;
                L = -Quu\Qux;                               
                
                % Make sure Quu is PD, if not, exit and increase regularization
                [~, p] = chol(full(Quu-eye(lqp_.u_sz)*1e-9));
                if p ~= 0
                    fprintf("Q is not PD \n");
                    success = false;
                    break
                end                                              
                
                % Standard value function update
                S = Qxx - L'*Quu*L ;                                              
                S = symm(S); % Truncate numerical error
                sv =  Qx + Qux'*lv + L'*(Qu+Quu*lv);                  
                  
%                 sv = sv + S*lqp_.d{k};
                sol.lvsol{k} = lv;
                sol.Ksol{k} = L;
                sol.Ssol{k} = S;
                sol.svsol{k} = sv;
                sol.hsol{k} = Qu;
                sol.Hsol{k} = Quu;
                
                sol.s_o1 = sol.s_o1 + lv'*Qu;
                sol.s_o2 = sol.s_o2 + lv'*Quu*lv;                               
                

                S_prime = S;
                sv_prime = sv;
            end
        end

        function forward_sweep(sol)
            % Forward rollout of the linear system
            % Initial condition should be fixed
            lqp_ = sol.lqp;

            sol.xsol{1} = zeros(lqp_.x_sz, 1); % set to zero because of variational dynamics

            for k = 1:lqp_.tau_sz-1
                sol.usol{k} = sol.lvsol{k} + sol.Ksol{k} * sol.xsol{k};

                sol.xsol{k+1} = lqp_.A{k}*sol.xsol{k} + lqp_.B{k}*sol.usol{k} + lqp_.d{k+1};
            end

        end

        function cost = expected_cost_change(sol, alpha)
            lqp_ = sol.lqp;
            cost_first_order = 0;
            cost_second_order = 0;
            for k = 1:lqp_.tau_sz-1
                uk = sol.usol{k} ;
                xk = sol.xsol{k};
                cost_first_order = cost_first_order + lqp_.rv{k}'*uk + lqp_.qv{k}'*xk ;
                cost_second_order = cost_second_order+ 0.5*uk'*lqp_.R{k}*uk + 0.5*xk'*lqp_.Q{k}*xk;                                
            end
            xN = sol.xsol{end};           
            cost_first_order = cost_first_order + lqp_.qvN'*xN;
            cost_second_order = cost_second_order + 0.5*xN'*lqp_.QN*xN;
            cost = alpha*cost_first_order + alpha^2*cost_second_order;
        end       

        function x = get_state_solution(sol)
            x = sol.xsol;
        end

        function u = get_control_solution(sol)
            u = sol.lvsol;
        end

        function set_control_zero(sol)
            for k=1:length(sol.usol)
                sol.usol{k} = zeros(length(sol.usol{k},1));
            end
        end      
        
        function Qu = get_control_gradient(sol)
            Qu = sol.hsol;
        end
        
        function K = get_feedback_gains(sol)
            K = sol.Ksol;
        end
    end
end

