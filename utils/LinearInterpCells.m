function x_interp = LinearInterpCells(x0,xf,len)

if ~(length(x0)==length(xf))
    error("Dimensino of initial condition does not match final state");
end

x_sz = length(x0);

x_interp_mat = zeros(x_sz, len);
for i = 1:x_sz
    x_interp_mat(i,:) = linspace(x0(i), xf(i), len);
end
x_interp_mat(:,1) = x0;
x_interp = num2cell(x_interp_mat, 1);

end

