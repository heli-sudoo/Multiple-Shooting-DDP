function DrawSimQuad( q_des, p_des, x,u, dt,graphics )
    q = x(1:4,:);
    p = x(8:10,:);
    % Pretty pictures
    figure(1);
    clf;
    g = axes();

    
    % Earth coordinate frame (grayish and skinny)
%     CoordAxes(g,.05/5, .1/2/5,.3/5, { [1 1 1]*.6, [1 1 1]*.6, [1 1 1]*.6},1,1 );

    h_des = hgtransform(g);
    h_des.Matrix = [quatToRot(q_des) zeros(3,1) ; 0 0 0 1];

    % Desired coordinate frame (darker than regular one)
%     CoordAxes(h_des,.05/2, .1/2,.3/2, { [1 0 0]*.5, [0 1 0]*.5, [0 0 1]*.5},1,1 );

    h_body = hgtransform(g);

    % Body fixed coordinate frame
    %CoordAxes(h_body,.03, .055,.3/2, { [1 0 0], [0 1 0], [0 0 1]},1,.75 );
    
    % Torque Arrow
    %torqueArrow = ArrowGraphic(h_body,0.03,0.055, .3/2, [255 105 180]/255 ,1);
    %forceArrow = ArrowGraphic(h_body,0.03,0.055, .3/2, [105 255 180]/255 ,1);
    
    %draw_ellipse( h_body , [0 0 0]', PseudoInertia, [.3 .3 .3 ; 1 1 1], 1 );
    draw_ellipse(h_body, [0 0 0]', diag([graphics.bodyRad, graphics.bodyRad, graphics.bodyHeight])^2,graphics.bodyColor,1);
    for i = 1:4
        h_arm{i} = hgtransform(h_body);
        h_arm{i}.Matrix = makehgtform('zrotate',pi/2*(i-1) );
   
        box( h_arm{i}, [0 -graphics.armWidth -graphics.armWidth; graphics.outerRad graphics.armWidth graphics.armWidth], graphics.armColor,1);
        box( h_arm{i}, [graphics.outerRad-2*graphics.armWidth graphics.outerRad; ...
                        -graphics.armWidth graphics.armWidth;
                        0 graphics.propOffset]',graphics.armColor,1);
        
        h_prop_prev{i} = hgtransform(h_arm{i});
        h_prop_prev{i}.Matrix = makehgtform('translate',[graphics.outerRad-graphics.armWidth,0,graphics.propOffset]);
        
        h_prop{i} = hgtransform(h_prop_prev{i});
  
        
        d_prop{i} = draw_ellipse(h_prop{i},[0 0 0]',diag([graphics.propRad, graphics.propRad, graphics.propHeight])^2, graphics.propColor,1);
    
    end 
    
    
    
    
    % lighting 
    d = 2; % distance camera is away from origin
    strengthOut = .3;
    strengthUp  = .5;
    light('Position',[-d 0 d],'Style','infinite','Color',[1 1 1]*strengthOut);
    light('Position',[d 0 d],'Style','infinite','Color',[1 1 1]*strengthOut);
    light('Position',[0 0 d],'Style','infinite','Color',[1 1 1]*strengthUp);
    light('Position',[0 0 -d],'Style','infinite','Color',[1 1 1]*strengthUp);

    xlim([-1.1 6.1]);
    ylim([-1.1 6.1]);
    zlim([-1.6 1.6]);
    view([47 30])

    % Carry out the simulation

    for ix = 1:size(x,2)-1

        % Update the graphics by setting the homogeneous tranform for the body
        % frame
        h_body.Matrix = [quatToRot(q(:,ix)) p(:,ix); 0 0 0 1];
        h_des.Matrix = [quatToRot(q_des) p_des ; 0 0 0 1];
        
%         nu = norm(t(:,ix));
%         if nu < 1e-6
%             nu = 1e-6;
%         end
%         
%         nu2 = norm(f(:,ix));
%         if nu2 < 1e-6
%             nu2 = 1e-6;
%         end
%               
%         % update torque arrow. Use a logrithmic scale for arrow length
%         torqueArrow.setVec( quatToRot(q(:,ix))*t(:,ix)/nu*log(nu+1)/4 );
%         forceArrow.setVec( quatToRot(q(:,ix))*f(:,ix)/nu2*log(nu2+1)/4 );
        
        % deviation from nominal state
        pause(dt);
    end
end




