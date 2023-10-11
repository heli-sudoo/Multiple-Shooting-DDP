function  h = box( parent, coords, colour,alpha )

% BOX  make a patch surface in the shape of a box
% h=box(parent,coords,colour) creates a box having the specified parent,
% coordinates and colour, and returns its handle.  Coords is a 2x3 matrix
% containing  any two diametrically opposite vertices of the box.  The box
% itself is aligned with the coordinate axes.  Colour is an RGB colour
% vector.

if any(coords(1,:)==coords(2,:))
  error('a box must have positive extent in all 3 dimensions');
end

%coords
x0 = min(coords(:,1));  x1 = max(coords(:,1));
y0 = min(coords(:,2));  y1 = max(coords(:,2));
z0 = min(coords(:,3));  z1 = max(coords(:,3));

vertices = [ x0 y0 z0;  x1 y0 z0;  x1 y1 z0;  x0 y1 z0; ...
	     x0 y0 z1;  x1 y0 z1;  x1 y1 z1;  x0 y1 z1 ];

faces = [ 5 6 7 8;  6 5 1 2;  7 6 2 3;  8 7 3 4;  5 8 4 1;  4 3 2 1 ];

facenormals = [ 0 0 1;	0 -1 0;  1 0 0;  0 1 0;  -1 0 0;  0 0 -1 ];

h = hggroup( 'Parent', parent );

for i = 1:6
  patch( 'Parent', h, ...
	 'Vertices', vertices(faces(i,:),:), ...
	 'VertexNormals', ones(4,1)*facenormals(i,:), ...
	 'Faces', [1 2 3 4], ...
	 'FaceColor', colour, ...
      'FaceAlpha',alpha,...
	 'EdgeColor', 'none', ...
	 'FaceLighting', 'gouraud', ...
	 'BackFaceLighting', 'unlit' );
end
end