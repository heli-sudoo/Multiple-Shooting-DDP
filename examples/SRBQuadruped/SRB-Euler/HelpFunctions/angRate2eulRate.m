function T = angRate2eulRate(eul)
% Matrix that transforms angular velocity in body frame to Euler rate

% Helpful functions
s = @(x) sin(x);
c = @(x) cos(x);
a = eul(1);
b = eul(2);
r = eul(3);

% Transformation matrix
T = [0, s(r),   c(r);
     0, c(r)*c(b), -s(r)*c(b);
     c(b),  s(r)*s(b),  c(r)*s(b)]/c(b); 

end