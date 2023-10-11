
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
addpath([pwd '/algorithm']);
addpath([pwd '/support/Pendulum']);
addpath([pwd '/utils']);


dt = 0.01;
x0 = [pi,0,0,0]';
xf = [0, 0, 0, 0]';
tau_sz = 301;       % trajectory size
SetupFunctions_Acrobot(dt, xf);
callback_params = acrobot_callback_params();

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve Problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_guess = LinearInterpCells(x0, xf, tau_sz);
u_guess = repmat({0}, [1,tau_sz]);

oc_setting = OCSetting(tau_sz);
oc_setting.x_sz = 4;
oc_setting.u_sz = 1;
oc_setting.M = 0;
%oc_setting.M = tau_sz-1;    % 0: SS. tau_sz-1: MS

% Prepare shooting nodes
params = prepare(oc_setting);

[xopt, uopt, solver_info] = Acrobot_TO(x_guess, u_guess, oc_setting, callback_params); 

%% Animate Solution
Acrobot_Animation(xopt, dt, 10);

%%
function params = acrobot_callback_params()
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

