function  h = cylinder( parent, spine, radius, colour, alpha, facets )

% CYLINDER  make a patch surface in the shape of a cylinder
% h=cylinder(parent,spine,radius,colour,facets)  creates a cylinder having
% the specified parent, geometry and colour, and returns its handle.  Spine
% is a 2x3 matrix whose rows specify the centre points of the two ends of
% the cylinder; colour is an RGB colour vector; and facets specifies the
% number of faces to be used in approximating the cylinder.  If omitted,
% facets defaults to 24.

% Implementation Notes:
% 1. I found that using quadrilaterals for the cylinder surface resulted in
%    incorrect rendering of one of the end faces in lit OpenGL, so I used
%    triangles for everything.
% 2. I put a vertex at the centre of each end face to avoid asymmetrical
%    lighting artifacts.

if nargin < 6
  facets = 24;
end
N = facets;

% Step 1: vertices and surface normals for a canonical cylinder
% (radius = height = 1, base at origin)

x = cos(2*pi*(0:N-1)'/N);
y = sin(2*pi*(0:N-1)'/N);
z1 = ones(N,1);
z0 = zeros(N,1);

topvertices = [ 0 0 1;   x y z1 ];
botvertices = [ 0 0 0;   x y z0 ];
cylvertices = [ x y z1;  x y z0 ];

topnormals = [ 0 0 1;   z0 z0 z1 ];
botnormals = [ 0 0 -1;  z0 z0 -z1 ];
cylnormals = [ x y z0;  x y z0 ];

% Step 2: scale, rotate and shift the vertices, and rotate the normals, to
% their correct values

% First, identify which end of the spine has the smaller z coordinate.  By
% choosing this end as the base, we ensure that the rotation angle will be
% <= pi/2.

if spine(2,3) >= spine(1,3)
  base = spine(1,:);
  dir = spine(2,:) - base;		% vector along cylinder axis
else
  base = spine(2,:);
  dir = spine(1,:) - base;
end

height = norm(dir);

if height == 0
  error('the two end points of a cylinder must be different');
end

scale = diag([radius,radius,height]);

dir = dir / height;			% find a rotation matrix that will
d = norm(dir(1:2));			% rotate the z axis into the
if d == 0				% correct direction
  rotate = eye(3);
else
  rotate = [ -dir(1)*dir(3)/d  dir(2)/d  dir(1); ...
	     -dir(2)*dir(3)/d -dir(1)/d  dir(2); ...
	      d                0         dir(3) ];
end

rotate = rotate';			% to operate on row vectors

shift1 = ones(N+1,1) * base;
shift2 = ones(2*N,1) * base;

topvertices = topvertices * scale * rotate + shift1;
botvertices = botvertices * scale * rotate + shift1;
cylvertices = cylvertices * scale * rotate + shift2;

topnormals = topnormals * rotate;
botnormals = botnormals * rotate;
cylnormals = cylnormals * rotate;

% Step 3: define the faces

for i = 1:N-1
  topfaces(i,:) = [ 1 i+1 i+2 ];
  botfaces(i,:) = [ 1 i+2 i+1 ];
  cylfaces(i,:) = [ i+1 i N+i+1 ];
  cylfaces(N+i,:) = [ i N+i N+i+1 ];
end
topfaces(N,:) = [ 1 N+1 2 ];
botfaces(N,:) = [ 1 2 N+1 ];
cylfaces(N,:) = [ 1 N N+1 ];
cylfaces(2*N,:) = [ N 2*N N+1 ];

% Step 4: create the cylinder as three surface patches in a group

h = hggroup( 'Parent', parent );

patch( 'Parent', h, ...
       'Vertices', topvertices, ...
       'VertexNormals', topnormals, ...
       'Faces', topfaces, ...
       'FaceColor', colour, ...
       'FaceAlpha',alpha,...
       'EdgeColor', 'none', ...
       'FaceLighting', 'gouraud', ...
       'BackFaceLighting', 'unlit' );

patch( 'Parent', h, ...
       'Vertices', botvertices, ...
       'VertexNormals', botnormals, ...
       'Faces', botfaces, ...
       'FaceColor', colour, ...
       'FaceAlpha',alpha,...
       'EdgeColor', 'none', ...
       'FaceLighting', 'gouraud', ...
       'BackFaceLighting', 'unlit' );

patch( 'Parent', h, ...
       'Vertices', cylvertices, ...
       'VertexNormals', cylnormals, ...
       'Faces', cylfaces, ...
       'FaceColor', colour, ...
       'FaceAlpha',alpha,...
       'EdgeColor', 'none', ...
       'FaceLighting', 'gouraud', ...
       'BackFaceLighting', 'unlit' );
end
