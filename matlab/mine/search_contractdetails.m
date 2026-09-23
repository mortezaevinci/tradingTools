base='Z:\My files\Project trading\traderdata\data_other\IB\';
cdmapfn=[base 'contractdetails.mat'];
load(cdmapfn);

searchitem='Defense';'Oil' 'Airlines' 'Computers' 'Auto Manufacturers'

fns=fieldnames(contractDetailsMap);
ncd=numel(fns);
for i=1:ncd
    symbol=cell2mat(fns(i));
    items=fieldnames(contractDetailsMap.(symbol));
    for j=1:numel(items)
        fld=cell2mat(items(j));
        val=contractDetailsMap.(symbol).(fld);
        try
            if (ischar(val))
                
                if (contains(val,searchitem))
                    disp(symbol);
                    break;
                end
            end
            
        catch
            
        end
    end
end
