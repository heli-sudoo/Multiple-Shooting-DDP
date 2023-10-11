function zdiff_norm = CallbackControlDiff(u_opt,x_opt,u_current,x_current)
u_opt = cellarray2mat(u_opt);
u_opt = reshape(u_opt, [numel(u_opt), 1]);
u_current = cellarray2mat(u_current);
u_current = reshape(u_current, [numel(u_current), 1]);

x_opt = cellarray2mat(x_opt);
x_opt = reshape(x_opt, [numel(x_opt), 1]);
x_current = cellarray2mat(x_current);
x_current = reshape(x_current, [numel(x_current), 1]);

z_opt = [u_opt;x_opt];
z_current = [u_current; x_current];
zdiff_norm = norm(z_current - z_opt);
end

