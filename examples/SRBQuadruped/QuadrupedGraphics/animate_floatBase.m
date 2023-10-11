function animate_floatBase(robotBody, time, pos, eul, dt, option)
% eul-> ZYX euler anlges 3xn matrix
% pos-> Position of CoM 3xn matrix
robotBody.DataFormat = 'column';

bigAnim = figure(198);
clf
set(bigAnim,'Renderer','OpenGL');

ax = show(robotBody, [pos(:,1); eul(:,1)], "Frames","off","collision","off","PreservePlot",0, "FastUpdate",1);
set(ax, 'CameraPosition', [12, -10, 3]);
hold on

if option.show_floor
    drawFloor();
end


axis(2*[-1 1 -1 1 -1 1])
% axis off
% box off
% axis equal


for k = 1:length(time)
    qk = [pos(:,k);eul(:,k)];
    set(ax, 'CameraTarget', pos(:,k)');
    show(robotBody, qk, "Frames","off",'collision','off','PreservePlot',0,"FastUpdate",1);   
    pause(dt);
    drawnow
end
end