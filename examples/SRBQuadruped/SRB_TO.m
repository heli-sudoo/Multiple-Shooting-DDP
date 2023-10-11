clear

%% Cost function
pos_des = [1, 0, 0.28]';
eul_des = [0, 0, 0]';
vel_des = [1, 0, 0]';
eulrate_des = [0, 0, 0]';
x_des = [pos_des; eul_des; vel_des; eulrate_des];
u_des = repmat([0, 0, 22]', [4, 1]);
px_FL = 0.20;
py_FL = 0.12;
pFoot = [px_FL, py_FL, 0, px_FL, -py_FL, 0, ... 
             -px_FL, py_FL, 0, -px_FL, -py_FL, 0]';

dt = 0.01;
SRB_Euler_SetupCost(x_des, u_des, dt);
contact = [1,1,1,1]';
%% Dynamics setup
mc_param = getMiniCheetahParams();
SRB_param = compute_SRBD_inertia(mc_param);
% % DynamicsSupportEulrate(SRB_param, dt);
DynamicsSupportAngularVel(SRB_param, dt);

dynamics = @(x,u) (SRB_dynamics(x,u,pFoot,contact));
dynamics_approx = @(x,u)(SRB_linearized_dynamics(x,u,pFoot,contact));

%% Problem Setting
tau_sz = 101;
oc_setting = OCSetting(tau_sz);
oc_setting.x_sz = 12;
oc_setting.u_sz = 12;
oc_setting = prepare(oc_setting);
callback_setting = SRBTO_callback_params();

%% Create Problem
nloc_prob = NLOCProblem();
nloc_prob.set_dynamics(dynamics, dynamics_approx);
nloc_prob.set_cost_function(@SRB_rcost, @SRB_rcost_approx, ...
                            @SRB_fcost, @SRB_fcost_approx);


%% Create Solver and Warm Start
nloc_solver = MSiLQR();
nloc_solver.set_problem(nloc_prob, oc_setting);
nloc_solver.InitializeData();
nloc_solver.set_callback_params(callback_setting);

%% Set initial guess
pos_init = [0,0,0.24]';
eul_init = [0, 0, 0]';
vel_init = zeros(3,1);
eulrate_init = zeros(3,1);
xinit = [pos_init; eul_init; vel_init; eulrate_init];
x_guess = repmat({xinit}, [1, oc_setting.tau_sz]);
u_guess = repmat({zeros(12,1)}, [1, oc_setting.tau_sz]);
nloc_solver.SetIntialGuess(x_guess, u_guess);

%% Solve the problem
solver_info = nloc_solver.Solve();
xsol = nloc_solver.xlocal;
xsol_mat = cellarray2mat(xsol);
pos = xsol_mat(1:3, :);
eul = xsol_mat(4:6, :);
vel = xsol_mat(7:9, :);
eulrate = xsol_mat(10:12, :);

%% Ainimate the SRB motion
option.show_floor = true;
time = 0:0.01:0.01*(oc_setting.tau_sz-1);
graphics_robot = importrobot("examples/SRBQuadruped/QuadrupedGraphics/urdf/mini_cheetah_simple_correctedInertia.urdf");
SRBbody = floatBase(graphics_robot);
animate_floatBase(SRBbody, time, pos, eul, 0.1, option);

%% Plot data
figure
subplot(3,1,1)
plot(time, pos(1,:));
ylabel('x (m)');
subplot(3,1,2)
plot(time, pos(2,:));
ylabel('y (m)');
subplot(3,1,3)
plot(time, pos(3,:));
ylabel('z (m)');
xlabel('time');

figure
subplot(3,1,1)
plot(time, vel(1,:));
ylabel('vx (m)');
subplot(3,1,2)
plot(time, vel(2,:));
ylabel('vy (m)');
subplot(3,1,3)
plot(time, vel(3,:));
ylabel('vz (m)');
xlabel('time');

figure
subplot(3,1,1)
plot(time, eulrate(1,:));
ylabel('yaw (rad)');
subplot(3,1,2)
plot(time, eulrate(2,:));
ylabel('pitch (rad');
subplot(3,1,3)
plot(time, eulrate(3,:));
ylabel('roll (rad)');
xlabel('time');

%%
function params = SRBTO_callback_params()
params.show_line_search = 0;
 
if params.show_line_search
    figure(211);
    hold on;
    params.h_Vactual = plot(0, 0,'m','LineWidth',3);
    params.h_Vpred = plot(0,0,'k:','LineWidth',2);
    
    l = legend('Actual Change','Predicted Change');
    l.Interpreter = 'Latex';
    xlabel('Step Size $\epsilon$','Interpreter','Latex');
    ylabel('Change in Cost','Interpreter','Latex');
    set(gca, 'FontSize',18);
end
end
