
function  viewmousepan(hObject, new, old )

% VIEWMOUSEPAN  pan view of ShowMotion camera by mouse motion
% viewmousepan(new,old) pans the view of a ShowMotion camera in response to
% mouse cursor motion.  The arguments are the current and previous cursor
% positions expressed in window pixel coordinates.  The pan is calculated
% so that the scene point under the cursor tracks the cursor as it moves.

%   old = mouseray(hObject, mousepos(hObject,old));
%   new = mouseray(hObject, mousepos(hObject,new));
% 
%   panvec = cross(old,new);
%   sinang = norm(panvec);
%   if sinang ~= 0
%     panvec = panvec * asin(sinang) / sinang;
%   end
% 
%   viewpan(hObject, -panvec );


  handles = guidata(hObject);
  view = handles.view;
  
  new = mousepos(hObject,new);
  old = mousepos(hObject,old);
  x = old(1);
  y = old(2);
  dx = new(1) - old(1);
  dy = new(2) - old(2);
  
  dc = view.focus - view.campos;
  right = cross(dc, view.upvec);
  right = right/norm(right);
  
  d = dx*right + dy*view.upvec;
  view.campos = view.campos - 2*d;
  view.focus = view.focus - 2*d;
  
  viewupdate(hObject, view);
 
  
