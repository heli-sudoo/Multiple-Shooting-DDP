function robot = buildTreeModel(params)
% This function creates a full planar paramsruped model structure
% The 0-configuration is with legs straight down, cheetah
% pointed along the +x axis of the ICS.
% The ICS has +z up, +x right, and +y inner page
% Planar model has 7 DoFs, x, z translation, rotation around y
% and front (back) hip and knee rotations

%% Fixed-base model
% We first creat a fixed-base model
robot.NB = 13;                                 % number of bodies (including feet)
robot.parent  = zeros(1,robot.NB);             % parent body indices
robot.Xtree   = repmat({eye(6)},robot.NB,1)';   % coordinate transforms
robot.jtype   = repmat({'  '},robot.NB,1)';     % joint types
robot.I       = repmat({zeros(6)},robot.NB,1)'; % spatial inertias
robot.gravity = [0 0 -9.81]';                  % gravity acceleration vec
robot.e       = 0;                             % restitution coefficient at impact

nbase = 1; % floating base index for attaching four children links (hip links)
robot.parent(nbase) = 0;
robot.Xtree{nbase} = eye(6);
robot.jtype{nbase} = ' '; % is not needed since floating-base model would not use
robot.I{nbase} =  mcI(params.bodyMass, params.bodyCoM, params.bodyRotInertia);

NLEGS = 4;
nb = nbase;
%[1,2,3,4] -> [FL,FR,HL,HR]
for i = 1:NLEGS
    % Abad link
    nb = nb + 1;
    robot.parent(nb) = nbase;
    robot.Xtree{nb} = plux(eye(3), params.abadLoc{i});
    robot.jtype{nb} = 'Rx';
    Iabad = mcI(params.abadLinkMass, params.abadLinkCoM, params.abadRotInertia);
    if (-1)^(i+1) < 0 % if on the right side
        robot.I{nb} = flipAlongAxis(Iabad, 'y'); % flip the spatial inertia along the Y axis
    else
        robot.I{nb} = Iabad;
    end
        
    % Hip link
    nb = nb + 1;
    robot.parent(nb) = nb - 1; % parent of the hip link is abad link
    robot.Xtree{nb} = plux(eye(3), params.hipLoc{i});  
    robot.jtype{nb} = 'Ry';
    Ihip = mcI(params.hipLinkMass, params.hipLinkCoM, params.hipRotInertia);
    if (-1)^(i+1) < 0 % if on right side
        robot.I{nb} = flipAlongAxis(Ihip, 'y'); % flip the spatial inertia along the Y axis
    else
        robot.I{nb} = Ihip;
    end

    % Knee link
    nb = nb + 1;
    robot.parent(nb) = nb - 1; % parent of the knee link is hip link
    robot.Xtree{nb} = plux(eye(3), params.kneeLoc);    % translation (length of hip link)
    robot.jtype{nb} = 'Ry';
    robot.I{nb} = mcI(params.kneeLinkMass, params.kneeLinkCoM, params.kneeRotInertia);    
end

%% Make it a floating-base model
robot = floatbase(robot); % floatbase (of spatial_v2) has the orientation in the order Px->Py->Pz->Rx->Ry->Rz
% Modify the order of Euler angles to be in ZYX format
robot.jtype{4} = 'Rz';
robot.jtype{6} = 'Rx';
end



