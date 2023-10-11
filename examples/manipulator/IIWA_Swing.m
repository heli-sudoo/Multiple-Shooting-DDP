
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP Problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear 
dt = 0.01;
q0 = zeros(7,1);
qd0 = zeros(7,1);
x0 = [q0; qd0];

qf = [0, pi/2, 0, pi/2, 0, 0, 0]';
qdf = zeros(7,1);
xf = [qf; qdf];

integration_method = 'semi-euler';
SetupFunctions_iiwa(dt, integration_method, xf);
callback_params = Kuka_callback_params();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Initial Guess
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tau_sz = 201;
xguess = LinearInterpCells(x0,xf,tau_sz);
uguess = repmat({zeros(7,1)}, [1,tau_sz]);
Kd_damp = -1.0*diag([20 20 5 3 2 1 1]/10);
Kinit = repmat({[zeros(7),Kd_damp]}, [1, tau_sz]);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLVE PROBLEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
oc_setting = OCSetting(tau_sz);
oc_setting.x_sz = 14;
oc_setting.u_sz = 7;
oc_setting.max_iter = 200;
% oc_setting.M = 0;
oc_setting = prepare(oc_setting);
[xopt, uopt, solver_info] = IIWA_TO(xguess, uguess, oc_setting, callback_params, Kinit); 


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Visualize trajectory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot = importrobot('iiwa14.urdf',"DataFormat","column");
show(robot, qf,'Frames','off');

for k = 1:1:tau_sz
    configNow = xopt{k}(1:7);
    show(robot,configNow,'PreservePlot',false, 'FastUpdate', true,'Frames','off');
    drawnow
    pause(0.01);
end

%%
function params = Kuka_callback_params()
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

