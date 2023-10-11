function [xopt, uopt, Kopt, solver_info] = Quadrotor_MSDDP(x_guess, u_guess, oc_setting, callback_params, varargin)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Create Nonlinear Optimal Control Problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc_prob = NLOCProblem();
nloc_prob.set_dynamics(@quadrotor_dynamics, @quadrotor_linearized_dynamics);
nloc_prob.set_cost_function(@quadrotor_rcost, @quadrotor_rcost_quad_approx, ...
                            @quadrotor_fcost, @quadrotor_fcost_quad_approx);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Create Solver and Warm Start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nloc_solver = MSiLQR();
nloc_solver.set_problem(nloc_prob, oc_setting);
nloc_solver.InitializeData();
nloc_solver.set_callback_params(callback_params);

nloc_solver.SetIntialGuess(x_guess, u_guess);
if length(varargin)==1
    nloc_solver.SetInitialPolicy(varargin{1});
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Solve the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solver_info = nloc_solver.Solve();

xopt = nloc_solver.xlocal;
uopt = nloc_solver.ulocal;
Kopt = nloc_solver.K;
end

