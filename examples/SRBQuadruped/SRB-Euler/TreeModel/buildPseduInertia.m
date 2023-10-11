function P = buildPseduInertia(Ihat)
h = skew2(Ihat(1:3, 4:6));
Ibar = Ihat(1:3, 1:3);
m = Ihat(6,6);
P = zeros(4,4);
P(1:3,1:3) = 0.5 * trace(Ibar) * eye(3) - Ibar;
P(1:3,end) = h;
P(end,1:3) = h';
P(end,end) = m;
end