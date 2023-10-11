
function  pos = mousepos(hObject, pix )

% MOUSEPOS  calculate normalized mouse cursor coordinates
% pos=mousepos(pix)  converts a mouse cursor location from figure pixel
% coordinates to a normalized coordinate system in which (0,0) corresponds
% to the centre of the figure window, and the narrower of its two
% dimensions maps to the range [-1,1].  (The other dimension will therefore
% map to a wider range.)  The angle at the camera between (0,-1) and (0,1),
% or between (-1,0) and (1,0), equals the camera's viewing angle.

% NOTE:  From my experiments, Matlab appears to regard pixel coordinates as
% referring to the centre of a pixel, whereas the pyramid defined by the
% camera's viewing angle maps to the edges of the pixels on the rectangle's
% boundary.  Thus, the largest angle between any two pixels in the shorter
% dimension will be slightly less than the camera's viewing angle.  This
% Matlab behaviour is accommodated here in mousepos by mapping pixel edges
% to the range [-1,1] and returning the coordinates of pixel centres.

handles = guidata(hObject);
figrectangle = get( handles.fig, 'Position' );
width = figrectangle(3);
height = figrectangle(4);
middle = [ (width+1)/2, (height+1)/2 ];
scaling = min(width,height) / 2;

pos = (pix - middle) / scaling;

