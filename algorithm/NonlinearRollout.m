function [xlocal, ulocal, xshot] = NonlinearRollout(dynamics, xprev, xlocal, ulocal, K, params)
% xshot integration shooting node
    xshot = scalar_times_cellarray(0, xlocal);
    xshot{1} = xlocal{1};
    I = params.I;

    xi = xlocal{1};
    for i = 1: (params.tau_sz-1)
        dxi = xi - xprev{i};
        
        % Update with stepsize and feedback
        ui = ulocal{i};
        if ~isempty(K)
            ui = ui + K{i}*dxi;                    
        end
        
        ulocal{i} = ui;
               
        % Propagate dynamics
        xi = dynamics(xi, ui);

        % Always update the integration shooting node
        xshot{i+1} = xi;
        
        % If the next step is a shooting node, reset xi
        if ismember(i+1, I)
            xi = xlocal{i+1};           
        end

        % Update state vectors
        xlocal{i+1} = xi;            
    end
 
end

