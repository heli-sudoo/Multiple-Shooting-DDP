
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

dt = 0.01;
x0 = [pi,0,0,0]';
xf = [0, 0, 0, 0]';
tau_sz = 201;
SetupFunctions_DP(dt, 'semi-euler', xf);
callback_params = DP_callback_params();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLVE PROBLEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_guess = LinearInterpCells(x0, xf, tau_sz);
u_guess = repmat({0}, [1,tau_sz]);

oc_setting = OCSetting(tau_sz);
oc_setting.x_sz = 4;
oc_setting.u_sz = 1;

% Prepare shooting nodes
params = prepare(oc_setting);

[xopt, uopt, solver_info] = DP_TO(x_guess, u_guess, oc_setting, callback_params); 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Visualize trajectory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot = importrobot('double_pendulum.urdf',"DataFormat","column");
show(robot, [pi, 0]', 'Frames','off');

for k = 1:1:oc_setting.tau_sz
    configNow = xopt{k}(1:2);
    show(robot,configNow,'PreservePlot',false, 'FastUpdate', true,'Frames','off');
    drawnow
    pause(0.01);
end


function params = DP_callback_params()
params.show_line_search = 0;
myred = [0.8500 0.3250 0.0980];
myblu = [0 0.4470 0.7410];

if params.show_line_search
    figure(21);
    hold on;
    params.h_Vactual = plot(0, 0,'LineWidth',3,'Color',myred,'LineStyle','-');
    params.h_Vpred = plot(0,0,'LineWidth',2,'Color',myblu,'LineStyle',':');
    
    l = legend('Actual Change','Predicted Change');
    l.Interpreter = 'Latex';
    xlabel('Step Size $\epsilon$','Interpreter','Latex');
    ylabel('Change in Cost','Interpreter','Latex');
%     ylim([-5e-6, 5e-6]);
    xlim([0, 0.6]);
    set(gca, 'FontSize',18);
end
end
