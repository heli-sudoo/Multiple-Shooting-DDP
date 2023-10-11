function [yfxx,yfuu,yfux] = pendulum_quadratic_dynamics(in1,u,in3)
%PENDULUM_QUADRATIC_DYNAMICS
%    [YFXX,YFUU,YFUX] = PENDULUM_QUADRATIC_DYNAMICS(IN1,U,IN3)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    05-Apr-2023 12:09:44

x1 = in1(1,:);
y2 = in3(2,:);
yfxx = reshape([y2.*sin(x1).*(-1.0./1.0e+1),0.0,0.0,0.0],[2,2]);
if nargout > 1
    yfuu = 0.0;
end
if nargout > 2
    yfux = [0.0,0.0];
end
