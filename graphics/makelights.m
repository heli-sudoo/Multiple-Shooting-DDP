
function  lights = makelights( camera, ax )

% makelights  make overhead and camera lights
% makelights(camera,ax) creates and returns a data structure for managing
% an overhead light and a camera headlight.  The former is a light at
% infinity that shines from a fixed direction.  The latter is a local light
% that moves around with the camera.  (See adjustlighting.)  The direction
% of the overhead light depends on the camera's .up and .direction vectors.

  view_up = camera.up - camera.direction * dot(camera.up,camera.direction);
  view_up = view_up / norm(view_up);
  view_right = cross(view_up,camera.direction);
  light_dir = view_up + camera.up - 0.7 * view_right;

  lights.overhead = ...
      light( 'Parent', ax, 'Position', light_dir, ...
	     'Style', 'infinite', 'Color', [1 1 1] );

  lights.camera = ...
      light( 'Parent', ax, 'Position', [0 0 0], ...
	     'Style', 'local', 'Color', [1 1 1] );

  lights.overheadPower = 1;
  lights.cameraPower = 1;