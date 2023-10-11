function mat = cellarray2mat(c_array)
%Converts a cell array of column vectors to a matrix
mat = [];
if iscolumn(c_array{1})
    for c=c_array
        mat = [mat, c{1}];
    end
else
    for c=c_array
        mat = [mat; c{1}];
    end
end
end

