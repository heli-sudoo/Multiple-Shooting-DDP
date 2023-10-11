function I = buildSpatialInertia(P)
I = zeros(6);
m = P(end, end);
h = P(1:3, end);
E = P(1:3, 1:3);
Ibar = trace(E) * eye(3) - E;
I(1:3, 1:3) = Ibar;
I(1:3, 4:end) = skew2(h);
I(4:end,1:3) = skew2(h)';
I(4:end,4:end) = m*eye(3);
end