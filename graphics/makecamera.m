function  camera = makecamera( )
camera.trackbody = 0;
camera.trackpoint = [0 0 0];
camera.direction = [0 -1 0.8]/sqrt(1.64);  % vector from scene to camera
camera.up = [0 0 1];
camera.zoom = 1;
camera.locus = [];