function params = callback_setting()
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