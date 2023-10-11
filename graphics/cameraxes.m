 
function  [X,Y,Z] = cameraxes(hObject)

% CAMERAXES  returns the axes of the camera coordinate system
% [X,Y,Z]=cameraxes  returns the scene coordinates of the three unit
% vectors that define the camera coordinate system.  Z points directly
% towards the camera, X points right, and Y points up.  All three are
% column vectors.  The matrix E = [X Y Z] is the coordinate transform from
% camera to scene coordinates.

handles = guidata(hObject);

vw = handles.view;

camdir = vw.campos - vw.focus;
Z = camdir / norm(camdir);
Y = vw.upvec - Z * dot(Z,vw.upvec);
Y = Y / norm(Y);
X = cross( Y, Z );

X=X'; Y=Y'; Z=Z';			% return column vectors
