function weight = UpdateDefectWeight(cost_first_order, dfectnorm, ls_params, weight_prev)
if dfectnorm == 0
    weight = weight_prev;
    return;
end
exp_change_abs = abs(cost_first_order);
thresh = 10 + exp_change_abs/((1-ls_params.pho)*dfectnorm);
if weight_prev >= thresh
    weight = weight_prev;
else
    weight = thresh;
end
weight = max(ls_params.min_weight, weight);
end

