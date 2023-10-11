function [xlocal, ulocal, xshot] = NominalRollout(dynamics,x,u,K,params)
xlocal = x;
ulocal = u;
xbar = x;
[xlocal, ulocal, xshot] = NonlinearRollout(dynamics,xbar,xlocal,ulocal,K,params);
end