
function  viewmouserot(hObject, new, old )

% VIEWMOUSEROT  rotate view of ShowMotion camera by mouse motion
% viewmouserot(new,old) implements the Featherstone crystal-ball view
% rotation algorithm, to rotate the view of a ShowMotion camera in response
% to mouse cursor motion.  The arguments are the current and previous cursor
% positions expressed in window pixel coordinates.  Rotation behaviour: if
% the cursor is off the crystal ball (which is assumed to be visible), then
% the scene rotates about the camera's viewing axis, otherwise the scene
% rotates as if you were manipulating a real crystal ball with your finger.

% A more accurate description: when the cursor is off the ball, the camera
% rotates about its viewing axis such that a ray passing from the rotation
% centre through the cursor's hot spot tracks the hot spot as it moves.  If
% the cursor is near the centre of the ball, then the camera orbits about
% an axis perpendicular to the plane defined by the rotation centre and the
% two points on the crystal ball under the new and old cursor positions.
% This creates the illusion that the cursor is touching the ball and
% rotating it.  If the cursor is near the edge of the ball then the
% rotation behaviour resembles the ball-centre behaviour, but is distorted
% in order to avoid an abrupt (and singular) transition to the off-ball
% behaviour.

  new = mousepos(hObject,new);
  old = mousepos(hObject,old);
  x = old(1);
  y = old(2);
  dx = new(1) - old(1);
  dy = new(2) - old(2);
  
  handles = guidata(hObject);
  
  view = handles.view;
  dc = view.campos - view.focus;
  R = norm(dc);
  
  phi = asin(dc(3)/R);
  sth = dc(1)/R / cos(phi);
  cth = -dc(2)/R / cos(phi);
  th = atan2(sth,cth);
  
  th = th - dx*.5;
  phi = phi - dy*.5;
  phiMax = (pi/2 - 0.01);
  if abs(phi) > phiMax;
      phi = sign(phi)*phiMax;
  end
  
  dc = R * [sin(th)*cos(phi) ; -cos(phi)*cos(th) ; sin(phi)]';
  
  
  view.campos = view.focus + dc;
  view.upvec = [0 0 1];
  viewupdate(hObject, view);
  
  
%   R = 0.8;				% radius of crystal ball
%   R2 = R^2;
%   r2 = x^2 + y^2;
%   if r2 >= R2				% pointer outside crystal ball
%     rz = (x*dy-y*dx)/r2;
%     viewrotate(hObject, [0 0 rz] );
%   else					% pointer inside crystal ball
%     R3 = R2*(R+sqrt(R2-r2));
%     rx = -x*y/R3*dx - (1/R-x*x/R3)*dy;
%     ry = x*y/R3*dy + (1/R-y*y/R3)*dx;
%     rz = (x*dy-y*dx)/R2;
%     viewrotate(hObject, [rx ry rz] );
%   end

  
  
  %end
