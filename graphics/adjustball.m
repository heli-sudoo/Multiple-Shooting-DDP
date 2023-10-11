
function  adjustball(hObject, on )

% ADJUSTBALL  adjust position, radius and visibility of crystal ball
% adjustball(on)  alters the position and radius of the ShowMotion crystal
% ball so that it is centred on the camera's current target and its radius
% is such that it occupies 80% (linearly) of the current view.  If an
% argument is supplied then this function makes the ball visible (on==1) or
% invisible (on==0), otherwise it leaves the visibility unaltered.


handles = guidata(hObject);
if nargin == 2
  if on
    set( handles.ball, 'Visible', 'on' );
  else
    set( handles.ball, 'Visible', 'off' );
  end
else
  on = strcmp( 'on', get(handles.ball,'Visible') );
end

if on
  vw = handles.view;
  d = norm( vw.campos - vw.focus );
  phi = atan(0.8*tan(vw.angle/2));
  r = d * sin(phi);			% radius that will fill 80% of view
  M = [ r*eye(3), vw.focus'; 0 0 0 1 ];
  set( handles.ball, 'Matrix', M );
end

guidata(hObject,handles)
