function inertia = SpatialInertiaFromMassProperty(a)
% a: vector of dime 10
inertia = zeros(6,6);
inertia(1, 1) = a(5);
inertia(1, 2) = a(10);
inertia(1, 3) = a(9);
inertia(2, 1) = a(10);
inertia(2, 2) = a(6);
inertia(2, 3) = a(8);
inertia(3, 1) = a(9);
inertia(3, 2) = a(8);
inertia(3, 3) = a(7);

c_skew = skew2([a(2),a(3),a(4)]);
inertia(1:3,4:6) = c_skew;
inertia(4:6,1:3) = c_skew';
inertia(4:6,4:6) = eye(3) * a(1);
end

