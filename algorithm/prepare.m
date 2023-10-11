function params = prepare(params)
%PREPARE split the horizon to M shooting intervals
%   Prepare the shooting nodes index

params.I = linspace(1,params.tau_sz,params.M+1);
params.I(1) = [];
end

