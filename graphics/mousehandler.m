
function  mousehandler( source, event, mycode, hObject )

% MOUSEHANDLER  handle mouse events in ShowMotion main window
% mousehandler(source,event,mycode) is the callback function for all mouse
% events in the main ShowMotion window except the menu.  In particular,
% this function manages rotate, pan, zoom and refocus.

handles = guidata(hObject);


switch mycode

  case 'down'				% button press
    cmd = get( handles.fig, 'SelectionType' );
    switch cmd

      case 'normal'			% start rotating

        handles.vw_last_pt = get( handles.fig, 'CurrentPoint' );
        handles.vw_mode = 'rotate';
        guidata(hObject, handles);
        
        %adjustball(hObject,1);

      case 'extend'			% start panning
        guidata(hObject, handles);
        %adjustball(hObject,0);
        handles = guidata(hObject);
        handles.vw_last_pt = get( handles.fig, 'CurrentPoint' );
        handles.vw_mode = 'pan';
        set( handles.fig, 'Pointer', 'fleur' );
        guidata(hObject, handles);
        
        
    end

  case 'up'				% button release

    %adjustball(hObject,0);
    handles = guidata(hObject);
    
    set( handles.fig, 'Pointer', 'arrow' );
    
    handles.vw_mode = 'normal';
    guidata(hObject,handles);

  case 'move'				% mouse movement

    pt = get( handles.fig, 'CurrentPoint' );
    switch handles.vw_mode
      case 'rotate'
        viewmouserot(hObject, pt, handles.vw_last_pt );
        handles = guidata(hObject);
        handles.vw_last_pt = pt;
      case 'pan'
        viewmousepan( hObject,pt, handles.vw_last_pt );
        handles = guidata(hObject);
        handles.vw_last_pt = pt;
    end
    guidata(hObject,handles);

  case 'scroll'				% scroll wheel

    switch handles.vw_mode
      case 'rotate'
        viewrefocus(hObject, 1 + event.VerticalScrollCount/25 );
        otherwise
        viewzoom(hObject, 1 + event.VerticalScrollCount/8 );
    end

end