function duplicate_value=detectRepeatedSymbols(symbols)

[~, ind] = unique(symbols);
ind=sort(ind);
allind=(1:numel(symbols))';
duplicate_ind = setdiff(allind, ind);
% duplicate values
duplicate_value = symbols(duplicate_ind);
end