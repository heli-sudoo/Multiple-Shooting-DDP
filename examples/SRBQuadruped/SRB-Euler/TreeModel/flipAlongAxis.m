
function I = flipAlongAxis(Ihat, Axis)
P = buildPseduInertia(Ihat);
X = eye(4);
if strcmp(Axis, 'x')
    X(1,1) = -1;
elseif strcmp(Axis, 'y')
    X(2,2) = -1;
elseif strcmp(Axis, 'z')
    X(3,3) = -1;
end
P = X * P * X;
I = buildSpatialInertia(P);
end