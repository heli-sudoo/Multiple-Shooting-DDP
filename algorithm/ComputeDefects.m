function defects = ComputeDefects(xlocal, xshot)
defects = add_cellarrays(xshot, scalar_times_cellarray(-1, xlocal));
end