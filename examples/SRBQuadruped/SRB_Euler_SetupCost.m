function SRB_Euler_SetupCost(x_des, u_des, dt)
import casadi.*

x = SX.sym('x', [12, 1]);
u = SX.sym('u', [12, 1]);

Q = diag([.1, .1, 100, 1, 1, 1, 5, 1, 1, .1, .5, .5]);
R = diag(.001 * ones(1,12));
Qf = .01 * Q;

l = (x - x_des)'*Q*(x - x_des) + (u - u_des)'*R*(u - u_des);
l = 0.5 *l * dt;
l_final = (x - x_des)'*Qf*(x - x_des);
l_final = 0.5 * l_final;

qv = jacobian(l, x)';
rv = jacobian(l, u)';
S = jacobian(rv, x);
qvf = jacobian(l_final, x)';

running_cost = Function('running_cost',{x, u},{l} );
running_cost_approx = Function('running_cost_approx', {x, u}, {l, qv, Q*dt, rv, R*dt, S});
final_cost = Function('final_cost', {x}, {l_final});
final_cost_approx = Function('final_cost_approx', {x}, {l_final, qvf, Qf});

opts = struct('main', false,...
              'mex', true, ...
              'with_header', false);
running_cost.generate('SRB_rcost.cpp',opts);
running_cost_approx.generate('SRB_rcost_approx.cpp',opts);
final_cost.generate('SRB_fcost.cpp', opts);
final_cost_approx.generate('SRB_fcost_approx.cpp',opts);


mex('-largeArrayDims', 'SRB_rcost.cpp');
mex('-largeArrayDims', 'SRB_fcost.cpp');
mex('-largeArrayDims', 'SRB_rcost_approx.cpp');
mex('-largeArrayDims', 'SRB_fcost_approx.cpp');

delete *.cpp
movefile *.mexa64 support/SRBQuadruped/
end

