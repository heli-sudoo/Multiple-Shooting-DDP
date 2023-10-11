
function  viewzoom(hObject, mag )

% VIEWZOOM  zoom view of ShowMotion camera
% viewzoom( mag ) zooms the view of a ShowMotion camera by moving the
% camera towards or away from the target point.  The argument is a
% magnification factor: objects at the target point appear mag times bigger.

  handles = guidata(hObject);
  vw = handles.view;
  vw.campos = vw.focus + (vw.campos - vw.focus) / mag;
  viewupdate(hObject, vw );

