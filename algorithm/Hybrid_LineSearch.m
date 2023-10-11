function [x_alpha, u_alpha, x_shot_alpha, defects, alpha, success] = Hybrid_LineSearch(nloc_prob, lq_solver, xprev, uprev, ...
                                                                              merit_prev, dnorm_prev, defect_weight, setting)
alpha = 1;
success = false;

% Get control step, state step, and feedback
dx = lq_solver.get_state_solution();
du = lq_solver.get_control_solution();
K = lq_solver.get_feedback_gains();


while alpha > setting.ls.alpha_min
    x_alpha = add_cellarrays(xprev, scalar_times_cellarray(alpha,dx));    
    u_alpha = add_cellarrays(uprev, scalar_times_cellarray(alpha,du));

    [x_alpha, u_alpha, x_shot_alpha] = NonlinearRollout(nloc_prob.dynamics, xprev, x_alpha, u_alpha, K, setting);
    
    % Compute merit function for the trial step
    cost = ComputeTotalCost(nloc_prob, x_alpha, u_alpha);        
    defects = ComputeDefects(x_alpha, x_shot_alpha);    
    dnorm = ComputeDefectNorm(defects, setting.norm_id);    
    merit = cost + defect_weight * dnorm;
    act_merit_change = merit - merit_prev;
    
    exp_cost_change = lq_solver.expected_cost_change(alpha);
    exp_merit_change = exp_cost_change  - alpha*defect_weight * dnorm_prev;

    if isnan(full(merit)) && (alpha <= setting.ls.alpha_min + 1e-15)
        fprintf("Merit is nan. Linear Search terminates \n");
        return;
    end
    
    gamma = setting.ls.gamma;       
    if (full(act_merit_change) <= full(gamma*exp_merit_change)) || (setting.ls.full_step)% If merit is decreased, accept the step       
        success = true;
        fprintf("Line search is succeful with alpha = %f \n", alpha);
        fprintf("Actual change %f, expected change %f \n", full(act_merit_change), full(gamma*exp_merit_change));
        break;
    end
    alpha = alpha * setting.ls.alpha_update;
end
end

