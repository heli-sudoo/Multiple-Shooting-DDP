
  function  viewpan(hObject, vec )

% VIEWPAN  pan view of ShowMotion camera
% viewpan( vec ) pans the view of a ShowMotion camera.  The argument is a
% 3D rotation vector specifying a rotation of the camera about its current
% position, expressed in camera coordinates.  The units are radians.

  handles = guidata(hObject);

  vw = handles.view;

  vec = [vec(1); vec(2); vec(3)];	% make sure it's a column vector

  [X,Y,Z] = cameraxes(hObject);
  E = [X Y Z];				% camera -> scene coord xform
  vec = E * vec;

  R = rv(vec)';				% camera (column vec) rotation matrix
                                        % expressed in scene coords
  vw.focus = vw.campos + (vw.focus-vw.campos) * R';
  vw.upvec = vw.upvec * R';

  viewupdate(hObject, vw );

