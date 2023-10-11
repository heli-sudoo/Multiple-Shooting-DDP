
function  ray = mouseray(hObject, pos )

% MOUSERAY  calculate ray from camera position through mouse cursor
% ray=mouseray(pos) calculates a unit vector, expressed in camera
% coordinates, pointing from the camera's position towards the given cursor
% position, pos, expressed in normalized mouse coordinates (see mousepos).

handles = guidata(hObject);

viewangle = handles.view.angle;

d = tan(viewangle/2);

ray = [ pos(1)*d; pos(2)*d; -1 ];

ray = ray / norm(ray);

