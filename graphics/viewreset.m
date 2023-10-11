
function  viewreset(hObject)

% VIEWRESET  (re)initialize ShowMotion camera view
% viewreset (re)initializes the ShowMotion camera and the data structure
% ShoMoData.view to an initial state which is partly predefined and partly
% a function of the camera properties specified in the model data structure
% argument supplied to showmotion.

  handles = guidata(hObject);

  cam = handles.camera;

  view.on_hold = 0;
  view.angle = 25 * pi/180;
  view.upvec = cam.up;

  %[X,Y,Z] = bounds;
  X = [-2 2];
  Y = [-2 2];
  Z = [-1 10];

  D = [ X(2)-X(1), Y(2)-Y(1), Z(2)-Z(1) ];
  r = norm(D) / 2;			% radius that must be captured
  d = r / sin( view.angle/2 );		% necessary distance to camera
  d = d / cam.zoom;			% adjustment for camera zoom

  % the following code works out where the track point is in scene
  % coordinates, and initializes camera.oldtrackpos accordingly.

  %if cam.trackbody == 0
    trackpos = cam.trackpoint;
  

  handles.camera.oldtrackpos = trackpos;

  % This code works out the location of the view focus.  If no camera locus
  % has been specified then the focus is the centre of the bounding box
  % calculated earlier.  Otherwise, the focus is located such that the
  % track point appears at the specified locus in normalized window
  % coordinates.

  view.focus = [0 0 0];
  

  view.campos = view.focus + cam.direction * d;
    
  handles.view = view;
  

  set( handles.ax, ...
       'CameraPosition', view.campos, ...
       'CameraTarget', view.focus, ...
       'CameraUpVector', view.upvec, ...
       'CameraViewAngle', view.angle * 180/pi, ...
       'Projection', 'perspective' );

  guidata(hObject, handles);
  adjustlighting(hObject);
  %adjustball(hObject);
