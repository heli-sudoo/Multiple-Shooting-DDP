function SetupFunctions_DP(dt, int_method, xf)
% Import double pendulum robot using robotics toolbox
rbt_tree = importrobot('double_pendulum.urdf');

% Convert the rigid body tree to spatial_v2 format
robot = ConvertToSpatial_v2(rbt_tree);

% Symbolic variables
syms u real;
x = sym('x', [4,1], 'real');
y = sym('y', [4,1], 'real');
q = x(1:2);
qd = x(3:4);

% Dynamics
[H,C] = HandC(robot,q,qd);
S = [1, 0]';
qdd = H\(S*u - C);

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

% Cost function
R = 10; 
Q = 0.1*diag([1, 1, .5, .5]);
l_continuous = 1/2*((x-xf)'*Q*(x-xf)) + 1/2* R*u^2; 
l = l_continuous*dt;
vars = [x; u];
vals = [xf; 0];

% Craft Final cost from LQR solution at the upward position (cost from infinite-horizon LQR)
A = double( subs(jacobian(f,x) , vars, vals) );
B = double( subs(jacobian(f,u) , vars, vals) );
Q = double( subs(hessian(l,x) , vars, vals) );
R = double( subs(hessian(l,u) , vars, vals) );
% [P] = dare(A,B,Q,R); % Solution to Difference Riccati (Infinite horizon)
P = 10*diag(ones(1,4));
lf   = 1/2*((x-xf)'*P*(x-xf));

% Cost function derivatives
qv = jacobian(l, x)';
rv = jacobian(l, u)';
S = jacobian(rv, x);
qvf = jacobian(lf, x)';
Qf = hessian(lf, x);

% Generate function objects
matlabFunction(l,  'vars',{x u},'file','support/DoublePendulum/DP_rcost');
matlabFunction(l, qv, Q, rv, R, S,  'vars',{x, u},'file','support/DoublePendulum/DP_rcost_quad_approx','optimize',1==1);
matlabFunction(lf, 'vars',{x}   ,'file','support/DoublePendulum/DP_fcost');
matlabFunction(lf, qvf, Qf, 'vars', {x}, 'file', 'support/DoublePendulum/DP_fcost_quad_approx','optimize',1==1);

matlabFunction(f,  'vars',{x u} ,'file','support/DoublePendulum/DP_dynamics','optimize',1==1);
matlabFunction(fx, fu, 'vars', {x u}, 'file', 'support/DoublePendulum/DP_linearized_dynamics','optimize',1==1);
matlabFunction(yfxx, yfuu, yfux, 'vars', {x u y}, 'file', 'support/DoublePendulum/DP_quadratic_dynamics','optimize',1==1);    

end