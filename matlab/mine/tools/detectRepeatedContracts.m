function duplicate_value=detectRepeatedContracts(contracts)
nc=numel(contracts);
symbols=[];

for i=1:nc
   symbols{i}=contracts{i}.Symbol; 
end

[~, ind] = unique(symbols);
ind=sort(ind);
allind=(1:numel(symbols))';
duplicate_ind = setdiff(allind, ind);
% duplicate values
duplicate_value = symbols(duplicate_ind)
end