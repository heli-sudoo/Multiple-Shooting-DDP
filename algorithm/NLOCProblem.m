classdef NLOCProblem < handle
    properties
        dynamics
        running_cost
        final_cost
        linearized_dynamics
        running_cost_quad_approx
        final_cost_quad_approx
    end
    
    methods
        function p = NLOCProblem()           
        end
        
        function set_dynamics(p, dynamics_in, linear_dynamics)
            p.dynamics = dynamics_in;
            p.linearized_dynamics = linear_dynamics;
        end

        function set_cost_function(p, rcost, rcost_approx, tcost, fcost_approx)
            p.running_cost = rcost;
            p.running_cost_quad_approx = rcost_approx;
            p.final_cost = tcost;
            p.final_cost_quad_approx = fcost_approx;
        end
             
    end
end

