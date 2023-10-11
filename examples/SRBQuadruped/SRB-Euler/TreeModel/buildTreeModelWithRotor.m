function robot = buildTreeModelWithRotor(params)
% This function creates a full planar paramsruped model structure
% The 0-configuration is with legs straight down, cheetah
% pointed along the +x axis of the ICS.
% The ICS has +z up, +x right, and +y inner page
% Planar model has 7 DoFs, x, z translation, rotation around y
% and front (back) hip and knee rotations

%% Fixed-base model
% We first creat a fixed-base model
robot.NB = 13;                                 % number of bodies 
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

% rotor information
robot.Xrotor = repmat({eye(6)}, robot.NB, 1)';
robot.jtype_rotor = repmat({' '}, robot.NB, 1)';
robot.has_rotor = zeros(1, robot.NB);
robot.gr = repmat({1}, robot.NB, 1)';  % gear ratio
robot.I_rotor = repmat({zeros(6)}, robot.NB,1)';

% append legs
NLEGS = 4;
nb = nbase;
for i = 1:NLEGS
    % Abad link
    nb = nb + 1;
    robot.parent(nb) = nbase;
    robot.Xtree{nb} = plux(eye(3), params.abadLoc{i});
    robot.jtype{nb} = 'Rx';
    Iabad = mcI(params.abadLinkMass, flipSignAbad(params.abadLinkCoM, i), params.abadRotInertia);
    if (-1)^i < 0 % if on the right side
        robot.I{nb} = flipAlongAxis(Iabad, 'y'); % flip the spatial inertia along the Y axis
    else
        robot.I{nb} = Iabad;
    end
    robot.Xrotor{nb} = plux(eye(3), params.abadRotorLoc{i});
    robot.jtype_rotor{nb} = 'Rx';
    robot.has_rotor(nb) = 1;    
    robot.gr{nb} = params.abadGearRatio;
    Iabad_rotor = mcI(params.rotorMass, flipSignAbad(params.rotorCoM, i), params.rotorRotInertiaX);
    if (-1)^i < 0
        robot.I_rotor{nb} = flipAlongAxis(Iabad_rotor,'y');
    else
        robot.I_rotor{nb} = Iabad_rotor;
    end
        
    % Hip link
    nb = nb + 1;
    robot.parent(nb) = nb - 1; % parent of the hip link is abad link
    robot.Xtree{nb} = plux(rz(pi), params.hipLoc{i});  
    robot.jtype{nb} = 'Ry';
    robot.I{nb} = mcI(params.hipLinkMass, params.hipLinkCoM, params.hipRotInertia);
    robot.Xrotor{nb} = plux(rz(pi), params.hipRotorLoc{i});
    robot.jtype_rotor{nb} = 'Ry';
    robot.has_rotor(nb) = 1;
    robot.gr{nb} = params.hipGearRatio;
    robot.I_rotor{nb} = mcI(params.rotorMass, params.rotorCoM, params.rotorRotInertiaY);
    
    % Knee link
    nb = nb + 1;
    robot.parent(nb) = nb - 1; % parent of the knee link is hip link
    robot.Xtree{nb} = plux(eye(3), params.kneeLoc);    % translation (length of hip link)
    kneeRotInertia = ry(pi/2) * params.kneeRotInertia * ry(pi/2)'; % transform the Inertia matrix into body frame. ry is from Featherstone's definition of rotation matrix
    robot.jtype{nb} = 'Ry';
    robot.I{nb} = mcI(params.kneeLinkMass, params.kneeLinkCoM, kneeRotInertia);
    robot.Xrotor{nb} = plux(eye(3), params.kneeRotorLoc);
    robot.jtype_rotor{nb} = 'Ry';
    robot.has_rotor(nb) = 1;    
    robot.gr{nb} = params.kneeGearRatio;
    robot.I_rotor{nb} = mcI(params.rotorMass, params.rotorCoM, params.rotorRotInertiaY);
end
% create floating base
robot = floatbase(robot);
% Modify the order of Euler angles to be in ZYX format
robot.jtype{4} = 'Rz';
robot.jtype{6} = 'Rx';
% Modify the floting base link for motor information
robot.has_rotor = [zeros(1,5), robot.has_rotor];
robot.gr = [repmat({1}, 1, 5), robot.gr];
robot.jtype_rotor = [repmat({' '}, 1, 5), robot.jtype_rotor];
robot.Xrotor = [repmat({eye(6)},1,5), robot.Xrotor];
robot.I_rotor = [repmat({zeros(6)},1,5), robot.I_rotor];
end

