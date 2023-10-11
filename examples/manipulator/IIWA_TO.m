function [xopt, uopt, solver_info] = IIWA_TO(xguess, uguess, oc_setting, callback_params, varargin)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Create Nonlinear Optimal Control Problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc_prob = NLOCProblem();
nloc_prob.set_dynamics(@kuka_dynamics, @kuka_linearized_dynamics);
nloc_prob.set_cost_function(@kuka_running_cost, @kuka_running_cost_approx, ...
                            @kuka_final_cost, @kuka_final_cost_approx);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Create Solver and Warm Start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc_solver = MSiLQR();
nloc_solver.set_problem(nloc_prob, oc_setting);
nloc_solver.InitializeData();
nloc_solver.set_callback_params(callback_params);

nloc_solver.SetIntialGuess(xguess, uguess);
if length(varargin) == 1
    K = varargin{1};
end
nloc_solver.SetInitialPolicy(K);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Solve the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solver_info = nloc_solver.Solve();

xopt = nloc_solver.xlocal;
uopt = nloc_solver.ulocal;
end

