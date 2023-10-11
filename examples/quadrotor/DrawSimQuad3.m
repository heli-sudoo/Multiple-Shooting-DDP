function DrawSimQuad3( rpy_des, p_des, xcell,ucell, dt,graphics )
x = cellarray2mat(xcell);
u = cellarray2mat(ucell);
quat = splitapply(@rpyToQuat, x, 1:length(xcell));
x(1:3, :) = [];
x = [quat; x];
quat_des = rpyToQuat(rpy_des);

DrawSimQuad(quat_des,p_des,x,u,dt,graphics);
end