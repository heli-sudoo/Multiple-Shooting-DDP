function [fx,fu] = pendulum_linearized_dynamics(in1,u)
%PENDULUM_LINEARIZED_DYNAMICS
%    [FX,FU] = PENDULUM_LINEARIZED_DYNAMICS(IN1,U)

%    This function was generated by the Symbolic Math Toolbox version 9.0.
%    05-Apr-2023 12:09:44

x1 = in1(1,:);
fx = reshape([1.0,cos(x1)./1.0e+1,1.0./1.0e+1,1.0],[2,2]);
if nargout > 1
    fu = [0.0;1.0./1.0e+1];
end