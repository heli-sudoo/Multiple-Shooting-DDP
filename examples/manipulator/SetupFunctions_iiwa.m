function robot = SetupFunctions_Kuka(dt, int_method, xf)
import casadi.*

% Import Kuka iiwa14 robot using robotics toolbox
rbt_tree = importrobot('iiwa14.urdf');
rbt_tree = subtree(rbt_tree, 'iiwa_link_1');
removeBody(rbt_tree, 'iiwa_link_ee_kuka');
removeBody(rbt_tree, 'iiwa_link_ee');

% Convert the rigid body tree to spatial_v2 format
robot = ConvertToSpatial_v2(rbt_tree);


q = SX.sym('q',7, 1);
qd = SX.sym('qd',7, 1);
u = SX.sym('u',7, 1);
x = [q; qd];
y = SX.sym('y',14,1);

% Dynamics
qdd = FDcrb(robot, q, qd, u);

% Integrate dynamics
qd_next = qd + qdd*dt;
switch int_method
    case 'euler'
        q_next = q + qd*dt;
    case 'semi-euler'
        q_next = q + qd_next*dt;
end
f = [q_next; qd_next]; 

% Dynamics derivatives
fx = jacobian(f, x);
fu = jacobian(f, u);
yfxx = hessian(y'*f, x);
yfuu = hessian(y'*f, u);
yfux = jacobian(jacobian(y'*f,u), x);


% Craft cost function
R = 5*diag([.1, .1, .1, .1, .1, .1, 1.]); % Control Penalty
Q = .5*diag([5, 10, 5, 10, .2, .1, .1, ...
             1,  2,  1,  2,  1,  0.5,  0.5]);
l_continuous = 1/2*((x-xf)'*Q*(x-xf)) + 1/2* u'*R*u; 

Qf = 1e3*diag([2, 2, 2, 1, 1, 1, 1 ...
              1, 1, 1, 1, 1, 1, 1]);

lf   = 1/2*((x-xf)'*Qf*(x-xf));
l = l_continuous*dt;

qv = jacobian(l, x)';
rv = jacobian(l, u)';
S = jacobian(rv, x);
qvf = jacobian(lf, x)';

% Create function objects
dynamics = Function('dyn', {x, u}, {f});
linearized_dynamics = Function('ldyn', {x,u}, {fx, fu});
quad_dynamics = Function('qdyn', {x, u, y}, {yfxx, yfuu, yfux});

running_cost = Function('rcost', {x, u}, {l});
running_cost_approx = Function('rcost_approx', {x, u}, {l, qv, Q, rv, R, S});
final_cost = Function('fcost', {x}, {lf});
final_cost_approx = Function('tcost_approx', {x}, {lf, qvf, Qf});

% Generate mex function
opts = struct('main', false,...
              'mex', true, ...
              'with_header', false);

dynamics.generate('kuka_dynamics.cpp',opts);
linearized_dynamics.generate('kuka_linearized_dynamics.cpp',opts);
quad_dynamics.generate('kuka_quad_dynamics.cpp',opts);
running_cost.generate('kuka_running_cost.cpp',opts);
running_cost_approx.generate('kuka_running_cost_approx.cpp',opts);
final_cost.generate('kuka_final_cost.cpp',opts);
final_cost_approx.generate('kuka_final_cost_approx.cpp',opts);

% mex('-largeArrayDims', 'kuka_dynamics.cpp');
% mex('-largeArrayDims', 'kuka_linearized_dynamics.cpp');
% mex('-largeArrayDims', 'kuka_quad_dynamics.cpp');
mex('-largeArrayDims', 'kuka_running_cost.cpp');
mex('-largeArrayDims', 'kuka_running_cost_approx.cpp');
mex('-largeArrayDims', 'kuka_final_cost.cpp');
mex('-largeArrayDims', 'kuka_final_cost_approx.cpp');

delete *.cpp
movefile kuka* support/Manipulator/
% problem.dynamics = dynamics;
% problem.linearized_dynamics = linearized_dynamics;
% problem.quad_dynamics = quad_dynamics;
% problem.running_cost = running_cost;
% problem.running_cost_approx = running_cost_approx;
% problem.final_cost = final_cost;
% problem.final_cost_approx = final_cost_approx;

end