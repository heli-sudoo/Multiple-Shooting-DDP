function DynamicsSupportEulrate(SRB_param, dt)
% Generate mex function for kinodynamics which represents orientation using
% ZYX Euler angle reprsentation. Don't mess up with XYZ fixed-anlge.
import casadi.*

I = SRB_param.RotInertia; % Mini Cheetah body inertia
m = SRB_param.mass;
g = 9.81;

%% Symbolic setup using Casadi
eul = SX.sym('eul', [3, 1]);        % ZYX euler anlge in body-fixed frame
euldot = SX.sym('euld', [3, 1]);    % rate of change of euler angle in body frame
p = SX.sym('p', [3, 1]);
v = SX.sym('v', [3, 1]);            % CoM velocity in world frame
pf = SX.sym('pf', [12, 1]);         % foothold location in world frame
F = SX.sym('F', [12, 1]);           % GRF in global frame
c = SX.sym('c', [4, 1]);            % contact status

%% Transformation matrix between euler rate and angular velocity
T = angRate2eulRate(eul);
Tinv = eulRate2angRate(eul);
Tdot = SX.zeros(3, 3);
for i = 1:3
    for j = 1:3
        Tdot(i, j) = jacobian(T(i, j), eul) * euldot;
    end
end
%% Dynamics
R_body = eul2Rot(eul);        % orientation of body w.r.t. global frame
g_world = [0 0 -g]';
w = Tinv * euldot;
pdot = v;
Mt = 0;
Ft = 0; % total force in global frame
for leg = 1:4    
    r = R_body'*(pf(3*(leg-1)+1:3*leg) - p);    % foot location relative to CoM in body frame
    Mt = Mt + c(leg) * skew(r) * (R_body'*F(3*(leg-1)+1:3*leg));
    Ft = Ft + c(leg) * F(3*(leg-1)+1:3*leg);
end
wdot = I\(-skew(w)*I*w + Mt);
vdot = g_world + Ft/m;
eulddot = Tdot*w + T * wdot;

%% Continuous-time dynamics
x = [p; eul; v; euldot];       % state variable
xdot = [pdot;
        euldot;        
        vdot;
        eulddot];
u = F;                  % control variable
xnext = x + xdot * dt;
A = jacobian(xnext, x);
B = jacobian(xnext, u);

% Generate function handle using Casadi
Dynamics = Function('SRB_dynamics',{x, u, pf, c}, {xnext});
DynamicsDerivatives = Function('SRB_linearized_dynamics',{x, u, pf, c},{A,B});

% Generate mex function
opts = struct('main', false,...
              'mex', true, ...
              'with_header', false);
Dynamics.generate('SRB_dynamics.cpp',opts);
DynamicsDerivatives.generate('SRB_linearized_dynamics.cpp',opts);

mex('-largeArrayDims', 'SRB_dynamics.cpp');
mex('-largeArrayDims', 'SRB_linearized_dynamics.cpp');

delete *.cpp
movefile *.mexa64 support/SRBQuadruped/

end