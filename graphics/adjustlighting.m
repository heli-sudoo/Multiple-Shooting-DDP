
function  adjustlighting(hObject, cam, sun )

% ADJUSTLIGHTING  adjust lights in a showmotion scene
% adjustlighting(cam,sun) allows one to adjust the intensity of the camera
% headlight and the overhead light (sunshine).  Arguments take values of
% +1, -1 or 0, meaning more, less or no change.  If this function is called
% with no arguments, then it updates the position of the camera headlight.
% (This must be done every time the camera is moved.)


N = 12;					% number of intensity levels
CAM_AZ = 10;				% camera headlight relative azimuth
CAM_EL = 20;				% and elevation in degrees

handle = guidata(hObject);


if nargin == 1
  camlight( handle.lights.camera, CAM_AZ, CAM_EL );
else
  if cam ~= 0
    p = handle.lights.cameraPower;
    if cam > 0
      if p == 0
	set( handle.lights.camera, 'Visible', 'on' );
      end
      p = min( 1, p+1/N );
    else
      p = max( 0, p-1/N );
      if p < 1e-6/N
	set( handle.lights.camera, 'Visible', 'off' );
	p = 0;
      end
    end
    handle.lights.cameraPower = p;
    set( handle.lights.camera, 'Color', p*[1 1 1] );
  end
  if sun ~= 0
    p = handle.lights.overheadPower;
    if sun > 0
      p = min( 1, p+1/N );
    else
      p = max( 1/N, p-1/N );
    end
    handle.lights.overheadPower = p;
    set( handle.lights.overhead, 'Color', p*[1 1 1] );
  end
end
guidata(hObject, handle);
