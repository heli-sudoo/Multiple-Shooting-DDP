function T = angrate2rpyrateMatrix(rpy)
    
% Matrix that transforms angular velocity in body frame to rpy rate

% Helpful functions
s = @(x) sin(x);
c = @(x) cos(x);
a = rpy(3);
b = rpy(2);
r = rpy(1);

% Transformation matrix
T = [c(b),  s(r)*s(b),  c(r)*s(b);
     0, c(r)*c(b), -s(r)*c(b);
     0, s(r),   c(r)]/c(b);


end

