function DrawSimQuad2( q_des, p_des, x,u, dt,graphics )
    q = x(1:4,:);
    p = x(8:10,:);
    % Pretty pictures
    figure(10);
    clf;
    g = axes();

    plot3(p(1,1:280),p(2,1:280),p(3,1:280),'b-','LineWidth',3);
    % Earth coordinate frame (grayish and skinny)
%     CoordAxes(g,.05/5, .1/2/5,.3/5, { [1 1 1]*.6, [1 1 1]*.6, [1 1 1]*.6},1,1 );

    h_des = hgtransform(g);
    h_des.Matrix = [quatToRot(q_des) zeros(3,1) ; 0 0 0 1];

    % Desired coordinate frame (darker than regular one)
%     CoordAxes(h_des,.05/2, .1/2,.3/2, { [1 0 0]*.5, [0 1 0]*.5, [0 0 1]*.5},1,1 );

    

    % Body fixed coordinate frame
    %CoordAxes(h_body,.03, .055,.3/2, { [1 0 0], [0 1 0], [0 0 1]},1,.75 );
    
    % Torque Arrow
    %torqueArrow = ArrowGraphic(h_body,0.03,0.055, .3/2, [255 105 180]/255 ,1);
    %forceArrow = ArrowGraphic(h_body,0.03,0.055, .3/2, [105 255 180]/255 ,1);
    
    %draw_ellipse( h_body , [0 0 0]', PseudoInertia, [.3 .3 .3 ; 1 1 1], 1 );
    
    
    
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
 h_des.Matrix = [quatToRot(q_des) p_des ; 0 0 0 1];
 j = [1 15 30 50 75  280];
    for jx = 1:length(j)
        ix = j(jx);
    h_body(ix) = hgtransform(g);
    h_body(ix).Matrix = [quatToRot(q(:,ix)) p(:,ix); 0 0 0 1];
    draw_ellipse(h_body(ix), [0 0 0]', diag([graphics.bodyRad, graphics.bodyRad, graphics.bodyHeight])^2,graphics.bodyColor,1);
    for i = 1:4
        h_arm{i} = hgtransform(h_body(ix));
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

    end
    axis equal
    view([35 21])
    a = gca;
    a.Visible='Off';
    f = gcf;
    f.Color = [1 1 1];
end