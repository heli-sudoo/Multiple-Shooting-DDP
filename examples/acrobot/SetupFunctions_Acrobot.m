function SetupFunctions_Acrobot(dt, xf)

syms u real;
x = sym('x', [4,1], 'real');
y = sym('y', [4,1], 'real');

q = x(1:2);
qd = x(3:4);

model = BuildAcrobotTreeModel();
[H, C] = HandC(model, q, qd);
S = [0, 1]';
qdd = H\(S*u - C);

% semi-implicit Euler
qd_next = qd + qdd*dt;
q_next = q + qd_next*dt;

f = [q_next; qd_next]; 


R = 1; % Control Penalty
Q = 1*diag([1, .5, .5, .5]);
l_continuous = 1/2*((x-xf)'*Q*(x-xf)) + 1/2* R*u^2; 

l = l_continuous*dt;
vars = [x; u];
vals = [xf; 0];
% Craft Final cost from LQR solution at the upward position (cost from infinite-horizon LQR)
A = double( subs(jacobian(f,x) , vars, vals) );
B = double( subs(jacobian(f,u) , vars, vals) );
Q = double( subs(hessian(l,x) , vars, vals) );
R = double( subs(hessian(l,u) , vars, vals) );
[P] = dare(A,B,Q,R); % Solution to Difference Riccati (Infinite horizon)
% P = 500*diag(ones(1,4));
lf   = 1/2*((x-xf)'*P*(x-xf));

fx = jacobian(f,x);
fu = jacobian(f,u);

qv = jacobian(l, x)';
Q = jacobian(qv, x);
rv = jacobian(l, u)';
R = jacobian(rv,u);
S = jacobian(rv, x);
qvf = jacobian(lf, x)';
Qf = jacobian(qvf, x);

yfxx = hessian(y'*f, x);
yfuu = hessian(y'*f, u);
yfux = jacobian(jacobian(y'*f, u), x);

matlabFunction(l,  'vars',{x u},'file','support/Acrobot/acrobot_rcost');
matlabFunction(l, qv, Q, rv, R, S,  'vars',{x, u},'file','support/Acrobot/acrobot_rcost_quad_approx','optimize',1==1);
matlabFunction(lf, 'vars',{x}   ,'file','support/Acrobot/acrobot_fcost');
matlabFunction(lf, qvf, Qf, 'vars', {x}, 'file', 'support/Acrobot/acrobot_fcost_quad_approx','optimize',1==1);

matlabFunction(f,  'vars',{x u} ,'file','support/Acrobot/acrobot_dynamics','optimize',1==1);
matlabFunction(fx, fu, 'vars', {x u}, 'file', 'support/Acrobot/acrobot_linearized_dynamics','optimize',1==1);
matlabFunction(yfxx, yfuu, yfux, 'vars', {x u y}, 'file', 'support/Acrobot/acrobot_quadratic_dynamics','optimize',1==1);    

end

