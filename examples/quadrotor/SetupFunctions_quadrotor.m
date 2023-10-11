function SetupFunctions_quadrotor(dt, xdes)

I = diag([2 2 3]); % Rotational inertia
m = 3; % mass
r = 0.25; % Rotor length
km = 0.7; % Torque from difference in rotor speed
g = 9.8; % Acceleration due to gravity

PseudoInertia = 1/2*trace(I)*eye(3)-I;
assert( all(eig(PseudoInertia) > 0) ) % necessary for inertia to be valid. 
PseudoInertia = PseudoInertia/max(eig(PseudoInertia))*.15; % Rescale it so the ellipse we draw isn't massive

%% Symbolic Setup
rpy_sym = sym('a_sym', [3, 1], 'real');     % roll, pitch, yaw euler angles in earth fixed coordinates
w_sym = sym('w_sym',[3 1],'real'); % given in body coordinates
p_sym = sym('p_sym',[3 1],'real'); % in world coordinates
v_sym = sym('v_sym',[3 1],'real'); % in body coordinates
x_sym = [rpy_sym ; w_sym ; p_sym ; v_sym];
y_sym = sym('y_sim', [12, 1], 'real');
u_sym = sym('u',[4 1]); % Rotor effort given in body coordinates 
% u1=x u2=y u3=-x u4=-y


%% Dynamics
g_global = [0;0;-g];
R = rpyToRot(rpy_sym);
tdot = [r*(u_sym(2)-u_sym(4)) ; r*(u_sym(3)-u_sym(1)) ; km*(u_sym(1)+u_sym(3)-u_sym(2)-u_sym(4))];
wdot = I\(tdot-skew(w_sym)*I*w_sym); % Euler equations
g_body = R'*g_global;
vdot = [0;0;u_sym(1)+u_sym(2)+u_sym(3)+u_sym(4)]./m + g_body;

rpy_dot = angrate2rpyrateMatrix(rpy_sym) * wdot;
nextrpy = rpy_sym + rpy_dot*dt;                  
nextw = w_sym + wdot*dt;
nextv = v_sym + vdot*dt;
v_global = R * v_sym;
nextp = p_sym + dt.*v_global;

f = [nextrpy ; nextw ; nextp ; nextv]; % Next state;

fx = jacobian(f, x_sym);
fu = jacobian(f, u_sym);
yfxx = hessian(y_sym'*f, x_sym);
yfuu = hessian(y_sym'*f, u_sym);
yfux = jacobian(jacobian(y_sym'*f, u_sym), x_sym);

%% Cost function
weight_rpy         = 1e3;
weight_w            = 100*10;
weight_p            = 1e3;
weight_v            = 100;
weight_u            = 1/2;

weight_rpy_final   = 1e6;
weight_w_final      = 1e4;
weight_p_final      = 1e6;
weight_v_final      = 1e4;

% quadratic parts of cost function. Weighted by terms above
Q = diag([ones(1,3)*weight_rpy, ones(1,3)*weight_w, ones(1,3)*weight_p, ones(1,3)*weight_v]);
Qf = diag([ones(1,3)*weight_rpy_final, ones(1,3)*weight_w_final, ...
            ones(1,3)*weight_p_final,ones(1,3)*weight_v_final]);
R = eye(4) * weight_u;

l_continuous = 1/2*((x_sym-xdes)'*Q*(x_sym-xdes)) + 1/2* u_sym'*R*u_sym; 
lf = 1/2*((x_sym-xdes)'*Qf*(x_sym-xdes));
l = l_continuous *dt;

qv = jacobian(l, x_sym)';
Q = jacobian(qv, x_sym);
rv = jacobian(l, u_sym)';
R = jacobian(rv,u_sym);
S = jacobian(rv, x_sym);
qvf = jacobian(lf, x_sym)';
Qf = jacobian(qvf, x_sym);


matlabFunction(f,  'vars',{x_sym u_sym} ,'file','support/Quadrotor/quadrotor_dynamics','optimize',1==1);
matlabFunction(fx, fu, 'vars', {x_sym u_sym}, 'file', 'support/Quadrotor/quadrotor_linearized_dynamics','optimize',1==1);
matlabFunction(yfxx, yfuu, yfux, 'vars', {x_sym u_sym y_sym}, 'file', 'support/Quadrotor/quadrotor_quadratic_dynamics','optimize',1==1);   

matlabFunction(l,  'vars',{x_sym u_sym},'file','support/Quadrotor/quadrotor_rcost');
matlabFunction(l, qv, Q, rv, R, S,  'vars',{x_sym, u_sym},'file','support/Quadrotor/quadrotor_rcost_quad_approx','optimize',1==1);
matlabFunction(lf, 'vars',{x_sym}   ,'file','support/Quadrotor/quadrotor_fcost');
matlabFunction(lf, qvf, Qf, 'vars', {x_sym}, 'file', 'support/Quadrotor/quadrotor_fcost_quad_approx','optimize',1==1);

end
