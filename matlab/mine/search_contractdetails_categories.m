base='Z:\My files\Project trading\traderdata\data_other\IB\';
cdmapfn=[base 'contractdetails.mat'];
load(cdmapfn);

categories=cell(0);
cc=1;
subcategories=cell(0);
scc=1;
industries=cell(0);
ic=1;
stc=1;
StockTypes=cell(0);
fns=fieldnames(contractDetailsMap);
ncd=numel(fns);
for i=1:ncd
    try
    symbol=cell2mat(fns(i));
    items=fieldnames(contractDetailsMap.(symbol));
    
    val=contractDetailsMap.(symbol).('Category');
    if (~isempty(val))
    categories{cc}=val;
    cc=cc+1;
    end
     val=contractDetailsMap.(symbol).('Subcategory');
    if (~isempty(val))
    subcategories{scc}=val;
    scc=scc+1;
    end
    
     val=contractDetailsMap.(symbol).('Industry');
    if (~isempty(val))
    industries{ic}=val;
    ic=ic+1;
    end
    
      val=contractDetailsMap.(symbol).('StockType');
    if (~isempty(val))
    StockTypes{stc}=val;
    stc=stc+1;
    end
    
    catch
         
    end
end
categories=uniqueRowsCA(categories');
subcategories=uniqueRowsCA(subcategories');
industries=uniqueRowsCA(subcategories');
StockTypes=uniqueRowsCA(StockTypes');
categories
subcategories
industries
StockTypes