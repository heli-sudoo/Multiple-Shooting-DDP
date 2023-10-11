function [l,qv,Q,rv,R,S] = pendulum_rcost_quad_approx(in1,u)
%PENDULUM_RCOST_QUAD_APPROX
%    [L,QV,Q,RV,R,S] = PENDULUM_RCOST_QUAD_APPROX(IN1,U)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    05-Apr-2023 12:09:44

x1 = in1(1,:);
l = u.^2.*(1.5e+1./2.0)+x1.^2./2.0e+1;
if nargout > 1
    qv = [x1./1.0e+1;0.0];
end
if nargout > 2
    Q = reshape([1.0./1.0e+1,0.0,0.0,0.0],[2,2]);
end
if nargout > 3
    rv = u.*1.5e+1;
end
if nargout > 4
    R = 1.5e+1;
end
if nargout > 5
    S = [0.0,0.0];
end