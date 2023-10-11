classdef LQProblem < handle
    properties
        x_sz
        u_sz
        tau_sz
        x
        u            
        x_nloc
        u_nloc

        A
        B                               
        d
        a       % used when relaxation method is enabled
        
        q
        qv
        Q 
        rv
        R        
        S
        qvN        
        qN
        QN        
    end
    
    methods
        function LQ = LQProblem(state_dim,control_dim,traj_sz)
            LQ.x_sz = state_dim;
            LQ.u_sz = control_dim;
            LQ.tau_sz = traj_sz;
                      
            LQ.set_control_to_zero();
            LQ.set_state_to_zero();
            LQ.set_linear_system_to_zero();
            LQ.set_quadratic_cost_to_zero();
            LQ.x_nloc = repmat({zeros(LQ.x_sz, 1)}, [1, LQ.tau_sz]);
            LQ.u_nloc = repmat({zeros(LQ.u_sz, 1)}, [1, LQ.tau_sz]);
        end
        
        function set_control_to_zero(LQ)
            LQ.u = repmat({zeros(LQ.u_sz, 1)}, [1, LQ.tau_sz]);
            LQ.a = repmat({zeros(LQ.x_sz, 1)}, [1, LQ.tau_sz]);
        end

        function set_state_to_zero(LQ)
            LQ.x = repmat({zeros(LQ.x_sz, 1)}, [1, LQ.tau_sz]);
        end

        function set_linear_system_to_zero(LQ)
            LQ.A = repmat({zeros(LQ.x_sz, LQ.x_sz)}, [1, LQ.tau_sz]);
            LQ.B = repmat({zeros(LQ.x_sz, LQ.u_sz)}, [1, LQ.tau_sz]);
            LQ.d = repmat({zeros(LQ.x_sz, 1)}, [1, LQ.tau_sz]);
        end

        function set_quadratic_cost_to_zero(LQ)
            LQ.Q = repmat({zeros(LQ.x_sz, LQ.x_sz)}, [1, LQ.tau_sz]);
            LQ.qv = repmat({zeros(LQ.x_sz, 1)}, [1, LQ.tau_sz]);
            LQ.q = repmat({0}, [1, LQ.tau_sz]);
            LQ.R = repmat({zeros(LQ.u_sz, LQ.u_sz)}, [1, LQ.tau_sz]);
            LQ.rv = repmat({zeros(LQ.u_sz, 1)}, [1, LQ.tau_sz]);
            LQ.S = repmat({zeros(LQ.u_sz, LQ.x_sz)}, [1, LQ.tau_sz]);

            LQ.QN = zeros(LQ.x_sz, LQ.x_sz);
            LQ.qvN = zeros(LQ.x_sz, 1);
            LQ.qN = 0;
        end
    end
end

