function [ hs, pp1 ] = draw_ellipse( parent , center, PSD, color, alpha  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[V, D] = eig(PSD);
v1 = V(:,1); d1 = D(1,1);
v2 = V(:,2); d2 = D(2,2);
if norm( V(:,3) - cross(v1,v2) ) > 1e-6
    V(:,1) = v2; D(1,1) = d2;
    V(:,2) = v1; D(2,2) = d1;
end

    
%v3 = cross(v1,v2);
%V(:,3) = v3;

eV = eig(V);

lV = logm(V);
axis = skew( lV );
V;
axis;
nm = norm(axis);
if nm > 1e-10
    axis = axis/nm;
else
    axis = [1 0 0]';
end

D = max(D,1e-3);
h = hgtransform('Parent',parent);

M1 = makehgtform('translate',center(1), center(2), center(3)); 


M2 = makehgtform('axisrotate',[axis(1) axis(2) axis(3)],nm);
M3 = makehgtform('scale',[sqrt(D(1,1)), sqrt(D(2,2)), sqrt(D(3,3)) ]);

h.Matrix = M1 * M2 * M3;

[hs, pp1] = sphere_v2( h, [0 0 0], 1, color, 360,alpha);



end

