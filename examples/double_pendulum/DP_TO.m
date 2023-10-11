function [xopt, uopt, solver_info] = DP_TO(x_guess, u_guess, oc_setting, callback_params)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Create Nonlinear Optimal Control Problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc_prob = NLOCProblem();
nloc_prob.set_dynamics(@DP_dynamics, @DP_linearized_dynamics);
nloc_prob.set_cost_function(@DP_rcost, @DP_rcost_quad_approx, ...
                            @DP_fcost, @DP_fcost_quad_approx);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Create Solver and Warm Start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc_solver = MSiLQR();
nloc_solver.set_problem(nloc_prob, oc_setting);
nloc_solver.InitializeData();
nloc_solver.set_callback_params(callback_params);


nloc_solver.SetIntialGuess(x_guess, u_guess);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Solve the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solver_info = nloc_solver.Solve();

xopt = nloc_solver.xlocal;
uopt = nloc_solver.ulocal;
end

