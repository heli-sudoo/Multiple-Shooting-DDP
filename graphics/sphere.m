
function [h ps] = sphere( parent, centre, radius, colour, facets, trans )

% SPHERE  make a patch surface in the shape of a sphere
% h=sphere(parent,centre,radius,colour,facets)  creates a sphere having the
% specified parent, geometry and colour, and returns its handle.  If colour
% is a 2x3 matrix then a two-tone sphere is created, with the colours
% alternating between octants.  Facets specifies the number of triangles
% around the equator.  It should be a multiple of 4.  If omitted, facets
% defaults to 24.

if all( size(centre) == [3,1] )
  centre = centre';
elseif ~all( size(centre) == [1,3] )
  error('centre must be a 3D vector');
end

if ~isscalar(radius) || radius <= 0
  error('radius must ba a scalar > 0');
end

if all( size(colour) == [1,3] )
  colour = [colour; colour];
elseif ~all( size(colour) == [2,3] )
  error('colour must be a 1x3 or 2x3 matrix');
end

if nargin < 5
  facets = 24;
end

if ~isscalar(facets) || facets <= 0
  error('facets must ba a scalar > 0');
end

% The sphere is created from eight spherical octants.  This first step
% creates the vertices for a unit-radius octant at the origin, and then
% scales them to the correct radius.  Note that the vertex data also
% defines the vertex normals.  If N is the number of triangle edges along
% an octant edge, then the octant will contain 1+2+3+...+(N+1) =
% (N+1)(N+2)/2 vertices and 1+3+5+...+(2N-1) = N^2 triangles.

N = ceil(facets/4);			% number of triangles on octant edge

vertices = [0 0 1];			% apex (top row) of octant

for i = 1:N				% append vertices row by row
  z = cos(i/N*pi/2) * ones(i+1,1);
  s = sin(i/N*pi/2);
  x = cos((0:i)'/i*pi/2);
  y = sin((0:i)'/i*pi/2);
  vertices = [ vertices; s*x s*y z ];
end

vertices = vertices * radius;		% scale to correct size

% Make the offset matrix that will move the vertices to their correct
% locations in space.

offset = ones((N+1)*(N+2)/2,1) * centre;

% Now make the vertices for each octant.  At the end of this step, the
% vertices for octant number i are given by the expression V{i}+offset, and
% the vertex normals by V{i}.

R1 = [0 -1 0; 1 0 0; 0 0 1];		% 90 degree z rotation
R2 = [1 0 0; 0 -1 0; 0 0 -1];		% 180 degree x rotation

V{1} = vertices;
V{2} = V{1} * R1;
V{3} = V{2} * R1;
V{4} = V{3} * R1;
V{5} = V{1} * R2;
V{6} = V{5} * R1;
V{7} = V{6} * R1;
V{8} = V{7} * R1;

% Now make the face data.  This is the same for all octants.

faces = [1 2 3];			% triangle at apex (top row)

for i = 2:N				% append triangles row by row
  a = i*(i-1)/2;
  b = a+i;
  f1 = [ a+(1:i)', b+(1:i)', b+(2:i+1)' ];	% triangles pointing up
  f2 = [ a+(1:i-1)', b+(2:i)', a+(2:i)' ];	% triangles pointing down
  faces = [ faces; f1; f2 ];
end

% Now make the sphere.
colour;

h = hggroup( 'Parent', parent );
for i = 1:8
  ps(i) = patch( 'Parent', h, ...
	 'Vertices', V{i}+offset, ...
     'FaceAlpha',trans, ...
     'EdgeAlpha',trans,...
	 'VertexNormals', V{i}, ...
	 'Faces', faces, ...
	 'FaceColor', colour(1+mod(i,2),:), ...
	 'EdgeColor', 'none', ...
	 'FaceLighting', 'gouraud', ...
	 'BackFaceLighting', 'unlit' );
end