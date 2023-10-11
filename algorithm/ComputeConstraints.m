function cmax_abs = ComputeConstraints(constraints, x_tau, u_tau)
%COMPUTECONSTRAINTVIOLATION Summary of this function goes here
%   constraints: Vector of Constraint variable (handle class)
%   X, U are state and control trajectories

cmax_abs = 0;
for constraint=constraints
    cmax_abs = max(cmax_abs, constraint.EvaluateConstraints(x_tau, u_tau));
end
end

