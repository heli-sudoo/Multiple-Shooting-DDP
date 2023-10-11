function T = eulRate2angRate(eul)
% Matrix that transforms Euler rate to Angular veloctiy in body frame

% Helpful functions
s = @(x) sin(x);
c = @(x) cos(x);

b = eul(2);
r = eul(3);

T = [-s(b), 0,  1;
     c(b)*s(r), c(r),   0;
     c(b)*c(r), -s(r),  0];
end