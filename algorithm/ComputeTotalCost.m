function cost = ComputeTotalCost(oc_prob, xlocal, ulocal)
cost = 0;
tau_sz = length(xlocal);
for k = 1:tau_sz-1
    cost = cost + oc_prob.running_cost(xlocal{k}, ulocal{k});
end
cost = cost + oc_prob.final_cost(xlocal{end});
end

