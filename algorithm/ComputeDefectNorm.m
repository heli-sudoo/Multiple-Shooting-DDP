function cost = ComputeDefectNorm(defects, norm_id)
norms = cellfun(@(x) norm(full(x),norm_id), defects);
cost = norm(norms, norm_id);
end

