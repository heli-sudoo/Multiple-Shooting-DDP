classdef MSiLQR < handle
    properties
        nloc_prob
        setting

        xlocal
        ulocal
        xshot
        K
        defects
        lq_solver
        lq_prob
      
        callback_params

        cost_buffer
        dnorm_buffer
        merit_buffer
        defect_weight_buffer
        cost_change_buffer
        converge_buffer
    end
    
    methods
        function s = MSiLQR() 
        end

        function set_problem(s,NLOC_Problem_in, setting_in)
            s.nloc_prob = NLOC_Problem_in;
            s.setting = setting_in;
            u_sz = s.setting.u_sz;
            x_sz = s.setting.x_sz;
            tau_sz = s.setting.tau_sz;

            s.lq_solver = LQSolver();
            s.lq_prob = LQProblem(x_sz, u_sz, tau_sz);
            s.lq_solver.set_LQ_problem(s.lq_prob);
        end

        function updatge_setting(s, setting_in)
            s.setting = setting_in;
        end

        function set_callback_params(s,params)
            s.callback_params = params;
        end

        function InitializeData(s)
            u_sz = s.setting.u_sz;
            x_sz = s.setting.x_sz;
            tau_sz = s.setting.tau_sz;
            s.ulocal = repmat({zeros(u_sz,1)}, [1,tau_sz]);
            s.xlocal = repmat({zeros(x_sz,1)}, [1,tau_sz]);
            s.xshot = repmat({zeros(x_sz,1)}, [1,tau_sz]);
            s.K = repmat({zeros(u_sz, x_sz)}, [1, tau_sz]);            
        end
        function SetIntialGuess(s,xguess,uguess)
            s.xlocal = xguess;
            s.ulocal = uguess;
        end        
        function SetInitialPolicy(s, Kinit)
            s.K = Kinit;
        end
        
        function solver_info = Solve(s)
            [s.xlocal, s.ulocal, s.xshot] = NominalRollout(s.nloc_prob.dynamics, s.xlocal, s.ulocal, s.K, s.setting);

            s.defects = ComputeDefects(s.xlocal, s.xshot);
            cost = ComputeTotalCost(s.nloc_prob, s.xlocal, s.ulocal);                        

            dnorm = ComputeDefectNorm(s.defects, s.setting.norm_id);   
            normalized_cost_change = nan;
            alpha = 0;

            defect_weight = s.setting.ls.defect_weight;             
            
            if s.setting.Debug
                    fprintf('=======================================\n');
                    fprintf('Initial cost %f\n',full(cost));
                    fprintf('Initial defect norm %f\n', full(dnorm));
            end

            if isfield(s.callback_params, 'ctrl_callback')
                    converge_metric = s.callback_params.ctrl_callback(s.ulocal, s.xlocal);
                    s.converge_buffer(end+1) = converge_metric;
            end
            
            
            % Buffer the initial cost, defect norm
            s.cost_buffer(end+1) = full(cost);
            s.dnorm_buffer(end+1) = full(dnorm);    
            
            iter = 1;             

            while 1==1

                if s.setting.Debug
                    fprintf('=======================================\n');
                    fprintf('Iteration %3d\n',iter);
                end                                    
                                                                                                    
                % Compute LQ approximation
                ComputeLQApprox(s.lq_prob, s.nloc_prob, s.xlocal, s.ulocal, s.defects, s.setting);    

                % Update the solver with the new LQ problem
                s.lq_solver.update_LQ_problem(s.lq_prob);
              
                % Check whether to use the second-order dynamics
                use_second_order = s.setting.lq_solver_setting.use_second_order;
              
                % Run the solver to solve the LQ subproblem
                s.lq_solver.solve(s.setting.lq_solver_setting, use_second_order);
                                              
                % Update the penalty parameter if necessary
                if strcmp(s.setting.ls.merit, "adapt_penalty")
                    exp_cost_change = s.lq_solver.expected_cost_change(1);
                    defect_weight = UpdateDefectWeight(exp_cost_change, dnorm, s.setting.ls, defect_weight);
                end

                % Update the merit function
                merit = cost + defect_weight * dnorm;                             
                
                if s.callback_params.show_line_search
                    s.callback_params = CallbackLSFDDP(s.nloc_prob, s.lq_solver, s.xlocal, s.xshot, s.ulocal, merit, ...
                        dnorm, defect_weight, s.setting, s.callback_params);
                end
                                              
                cost_prev = cost;

                % Do line search
                [s.xlocal, s.ulocal, s.xshot, s.defects, alpha, ~] = ...
                Hybrid_LineSearch(s.nloc_prob, s.lq_solver, s.xlocal, s.ulocal, merit, dnorm, defect_weight, s.setting);                            

                % Evaluate the defect after aceepting a step                
                dnorm = ComputeDefectNorm(s.defects, s.setting.norm_id);     

                % Compute the change of cost
                cost = ComputeTotalCost(s.nloc_prob, s.xlocal, s.ulocal);                                    
                normalized_cost_change = abs((cost_prev - cost)/cost_prev);

                % Buffer the cost, defect norm, and merit function
                s.defect_weight_buffer(end+1) = defect_weight;
                s.cost_buffer(end+1) = full(cost);
                s.dnorm_buffer(end+1) = full(dnorm);                      
                
                if isfield(s.callback_params, 'ctrl_callback')
                    converge_metric = s.callback_params.ctrl_callback(s.ulocal, s.xlocal);
                    s.converge_buffer(end+1) = converge_metric;
                end

                if (full(normalized_cost_change) <= s.setting.terminate_cost_thresh) && (full(dnorm) <= s.setting.terminate_defect_thresh)
                    fprintf("Solver converged! \n");
                    fprintf("Cost change stops at: %f   Defect norm stops at %f \n", normalized_cost_change, dnorm);
                    fprintf("Total cost : = %f \n", cost);
                    fprintf("Total defect violation = %f \n\n\n", full(dnorm));

                    solver_info.cost_buff = s.cost_buffer;
                    solver_info.dnorm_buff = s.dnorm_buffer;
                    solver_info.defect_weight_buff = s.defect_weight_buffer;
                    solver_info.converge_buff = s.converge_buffer;
                    solver_info.iter = iter;
                    break;
                end

                if s.setting.Debug
                    fprintf("Total cost : = %f \n", full(cost));
                    fprintf("Total defect violation = %f \n\n\n", full(dnorm));
                end
               
                if iter >= s.setting.max_iter
                    solver_info.cost_buff = s.cost_buffer;
                    solver_info.dnorm_buff = s.dnorm_buffer;
                    solver_info.defect_weight_buff = s.defect_weight_buffer;
                    solver_info.converge_buff = s.converge_buffer;
                    solver_info.iter = iter;
                    break;
                end

                iter = iter + 1;
            end

        end
        
       
                        
    end
end

