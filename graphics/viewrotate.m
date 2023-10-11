
function  viewrotate(hObject, vec )

% VIEWROTATE  rotate view of ShowMotion camera
% viewrotate( vec ) rotates the view of a ShowMotion camera.  The argument
% is a rotation vector expressed in camera coordinates: x=right, y=up and
% z=towards the viewer.  Thus, if vec=[0.1 0 0] then the camera is rotated
% in such a manner that the objects in view appear to have rotated by 0.1
% radians about an axis pointing to the right and passing through the view
% centre.

  handles = guidata(hObject);

  vw = handles.view;

  vec = [vec(1); vec(2); vec(3)];	% make sure it's a column vector

  [X,Y,Z] = cameraxes(hObject);
  E = [X Y Z];				% camera -> scene coord xform
  vec = E * vec;

  R = rv(vec)';				% scene (col vec) rotation operator
                                        % (therefore camera row vec rot op)
  vw.campos = vw.focus + (vw.campos-vw.focus) * R;
  %vw.upvec = vw.upvec * R;

  'CAMVEC'
  vw.campos-vw.focus
  vw.upvec = [0 0 1];
  viewupdate(hObject, vw );

  