function c = add_cellarrays(c1,c2)
% Check the size of two cell arrays

if length(c1) ~= length(c2)
    Error("Error: cell array dims mismatch");
    return
end

c = c1;
for i = 1:length(c)
    c{i} = c{i} + c2{i};
end

