
% Initial condition
dt = 0.02;
rpy_0 = [0 0 0]';
w_0 = [0 0 0]';
p_0 = [2 2 -1]';
v_0 = [1 1 -2]'*0;
x0 = [rpy_0; w_0; p_0; v_0];

% Desired state
rpy_des = [0 0 0]';
w_des = [0 0 0]';
p_des = [0 0 0]';
v_des = [0 0 0]';
x_des = [rpy_des; w_des ; p_des ; v_des];

%% Set up
SetupFunctions_quadrotor(dt, x_des);
callback_params = quadrotor_callback_params();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP TEST 1 (Varing The Number of Shooting Nodes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau_sz = 400 + 1; 
xguess = LinearInterpCells(x0,x_des,tau_sz);
uguess = repmat({zeros(4,1)}, tau_sz);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLVE PROBLEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oc_setting = OCSetting(tau_sz);
oc_setting.x_sz = 12;
oc_setting.u_sz = 4;
oc_setting = prepare(oc_setting);
[xopt, uopt, ~, solver_info] = Quadrotor_TO(xguess, uguess, oc_setting, callback_params); 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Visulize the solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
graphics.bodyRad = .3;
graphics.outerRad = .75;
graphics.bodyHeight = .1;
graphics.propOffset = 0.04*3;
graphics.propRad    = .15;
graphics.propHeight = 0.01;
graphics.propColor = [.3 .3 .3];

graphics.bodyColor = [.8 .8 .8];
graphics.armColor = [.6 .6 .6];


graphics.armWidth  = .03;


DrawSimQuad3(rpy_des,p_des,xopt,uopt,dt, graphics)


%%
function params = quadrotor_callback_params()
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
