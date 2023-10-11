function c= scalar_times_cellarray(s,c)

for i = 1:length(c)
    c{i} = c{i} * s;
end
end

