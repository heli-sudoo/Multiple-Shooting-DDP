
function  viewupdate(hObject, view )

% VIEWUPDATE  update ShowMotion camera view
% viewupdate(view) stores the given viewing parameters in the data
% structure ShoMoData.view.  If there is no animation in progress, then it
% also updates the ShowMotion camera; otherwise it marks the new viewing
% parameters as 'on hold'.  If viewupdate is called with no argument, then
% it unconditionally updates the ShowMotion camera with any on-hold viewing
% parameters in ShoMoData.view.

  handles = guidata(hObject);

  if nargin == 0
    view = handles.view;
    if view.on_hold
      update = 1;			% unconditional update
    else
      return				% nothing to do
    end
  else
    update = ~handles.animating;	% update only if not animating
  end

  view.on_hold = ~update;
  view.upvec = [0 0 1];
  handles.view = view;
  guidata(hObject,handles);
  
  if update
    set( handles.ax, ...
	 'CameraPosition', view.campos, ...
	 'CameraTarget', view.focus, ...
	 'CameraUpVector', view.upvec, ...
	 'CameraViewAngle', view.angle * 180/pi );
    guidata(hObject,handles);
    adjustlighting(hObject);
    %adjustball(hObject);
  end

