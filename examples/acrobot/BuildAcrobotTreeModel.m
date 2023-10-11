function robot = BuildAcrobotTreeModel()
m_1 = 1; m_2 = 1; l_1 = 1;
lc_1 = 0.5; lc_2 = 1; 
I_1 = 0.083; I_2 = 0.33;

robot.NB = 2;                                 % number of bodies (including feet)
robot.parent  = zeros(1,robot.NB);             % parent body indices
robot.Xtree   = repmat({eye(6)},robot.NB,1)';   % coordinate transforms
robot.jtype   = repmat({'  '},robot.NB,1)';     % joint types
robot.I       = repmat({zeros(6)},robot.NB,1)'; % spatial inertias
robot.gravity = [0 0 -9.81]';                  % gravity acceleration vec

link1 = 1; 
robot.parent(link1) = 0;
robot.Xtree{link1} = eye(6);
robot.jtype{link1} = 'Ry'; 
robot.I{link1} =  mcI(m_1, [0, 0, lc_1], diag([0,I_1,0]));

link2 = 2; 
robot.parent(link2) = link1;
robot.Xtree{link2} = plux(eye(3), [0, 0, l_1]);
robot.jtype{link2} = 'Ry'; 
robot.I{link2} =  mcI(m_2, [0, 0, lc_2], diag([0,I_2,0]));

robot.appearance.base = ...
  { 'box', [-0.2 -0.3 -0.2; 0.2 0.3 -0.07] };

for i = 1:2
  robot.appearance.body{i} = ...
    { 'box', [-0.07 -0.04 0;0.07 0.04 1], ...
      'cyl', [0 -0.07 0; 0 0.07 0], 0.1 };
end
end