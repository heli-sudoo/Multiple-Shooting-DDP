classdef OCSetting < handle
    %OCSETTING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tau_sz          % Number of integration segments + 1
        M               % Number of shooting invervals, each having 15 segments 
        I               % Set of shooting node
        norm_id        % Norm index for defects norm
        x_sz 
        u_sz 
        
        lq_solver_setting

        ls

        Debug 
        terminate_cost_thresh 
        terminate_defect_thresh       
        max_iter 
    end
        
    methods
        function s = OCSetting(tau_sz)
            s.tau_sz = tau_sz;
            s.M = tau_sz - 1;
            s.I = [];
            s.norm_id = 2;
            s.x_sz = 0;
            s.u_sz = 0;

            s.lq_solver_setting.use_second_order = 0;
            s.lq_solver_setting.second_order_dynamics = [];
            
            s.ls.merit = "adapt_penalty"; % options: 
                                       % const_penalty                                       
                                       % adapt_penalty Chp18.3 merit function, Nocedal, Nonlinear Optimizatioin                                       
            s.ls.alpha_update = .5;            
            s.ls.alpha_min = 1e-20;
            s.ls.gamma = .1;
            s.ls.full_step = 0;
            s.ls.pho = 0.2;                 % ls.pho is in (0,1) if armijo_adaptive, else 0
            s.ls.defect_weight = 1;      % used when ls.method is armijo_constant
            s.ls.min_weight = 10;      % used when ls.method is armijo_constant
            
            s.Debug = 1;
            s.terminate_cost_thresh = 1e-4;    % convergence criterion for cost reduction
            s.terminate_defect_thresh = 1e-4;  % convergence criterion for continuity violation 
            s.max_iter = 200; 
        end
    end
end

