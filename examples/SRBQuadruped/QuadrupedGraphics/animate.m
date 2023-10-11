function animate(robot, time, pos, eul, qJ, dt, option)
% eul-> ZYX euler anlges 3xn matrix
% pos-> Position of CoM 3xn matrix
% qJ-> Actuated joint angles 12xn matrix
robot.DataFormat = 'column';

bigAnim = figure(198);
clf
set(bigAnim,'Renderer','OpenGL');
% set(bigAnim, 'Position', get(0, 'Screensize'));

ax = show(robot, [pos(:,1); eul(:,1); qJ(:,1)], "Frames","off","collision","off","PreservePlot",0, "FastUpdate",1);
set(ax, 'CameraPosition', [12, -10, 3]);
hold on

if option.show_floor
    drawFloor();
end


axis(2*[-1 1 -1 1 -1 1])
% axis off
box off
% axis equal


for k = 1:length(time)
    qk = [pos(:,k);eul(:,k);qJ(:,k)];
    set(ax, 'CameraTarget', pos(:,k)');
    show(robot, qk, "Frames","off",'collision','off','PreservePlot',0,"FastUpdate",1);   
    pause(dt);
    drawnow
end
end