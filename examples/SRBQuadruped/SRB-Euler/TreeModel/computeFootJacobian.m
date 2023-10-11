function Jv = computeFootJacobian(robot, q, leg)
% robot -> robot tree built with spatial_v2
% q -> generalized joint angle nx1 vector
% kneeLinkLength -> knee link length
% leg -> leg ID [1,2,3,4]->[FL, FR , HL, HR]
% Jv -> Foot Jacobian for linear velicity in worldframe

kneeLinkLength = 0.195;
Xtree_knee_to_foot = plux(eye(3), [0, 0, -kneeLinkLength]');
% Get the jacobian expressed in foot frame
J_local = BodyJacobian(robot, q, LINKID.knee(leg), Xtree_knee_to_foot);

[~, ~, info] = HandC(robot, q, zeros(size(q)));
Xup = info.Xup;
X = eye(6);

j = LINKID.knee(leg);

while j > 0
    X = X * Xup{j};
    j = robot.parent(j);
end


[R, ~] = plux(X);

J_world = blkdiag(R', R') * J_local;
Jv = J_world(4:end, :);
end