function Acrobot_Animation(xcell, dt, fps)

dt_frame = 1/fps;
step = dt_frame/dt;
f = 1:step:length(xcell);
t = dt * (f - 1);
xcell_frames = xcell(f);
q = zeros(2, length(xcell_frames));
for i = 1:length(xcell_frames)
    q(:,i) = xcell_frames{i}(1:2);
end

acrobot = BuildAcrobotTreeModel();
showmotion(acrobot, t, q);
end

