function ComputeLQApprox(lqp, nloc_prob, x, u, defect, params)
%Compute the LQ approximation
% Linearized system around (x_local, u_local)
% Quadratic cost approximation around (x_local, u_local)
% lqp is an LQProblem object

if lqp.tau_sz ~= length(x)
    fprintf("Incorrect size x_local or LQProblem! \n");    
    return
end

if params.Debug
    fprintf("Computing LQ Approximation \n");
end

for k = 1:lqp.tau_sz - 1
    % compute linearized dynamics
    [lqp.A{k}, lqp.B{k}] = nloc_prob.linearized_dynamics(x{k}, u{k});
    lqp.d{k} = defect{k};

    % compute quadratic approximation of the running cost
    [lqp.q{k}, lqp.qv{k}, lqp.Q{k}, lqp.rv{k}, lqp.R{k}, lqp.S{k}] = ...
        nloc_prob.running_cost_quad_approx(x{k}, u{k});    
end

% finialize
[lqp.qN, lqp.qvN, lqp.QN] = nloc_prob.final_cost_quad_approx(x{end});
lqp.x_nloc = x;
lqp.u_nloc = u;
lqp.d{end} = defect{end};

end

