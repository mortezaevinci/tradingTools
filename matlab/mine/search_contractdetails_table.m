base='Z:\My files\Project trading\traderdata\data_other\IB\';
cdmapfn=[base 'contractdetails.mat'];
load(cdmapfn);

Category=cell(0);
Subcategory=cell(0);
Industry=cell(0);
StockType=cell(0);
Symbol=cell(0);
cnt=1;
fns=fieldnames(contractDetailsMap);
ncd=numel(fns);
for i=1:ncd
    try
    symbol=cell2mat(fns(i));
    items=fieldnames(contractDetailsMap.(symbol));
    Symbol{cnt}=symbol;
    val=contractDetailsMap.(symbol).('Category');
    if (isempty(val)); val=''; end
    Category{cnt}=val;
    val=contractDetailsMap.(symbol).('Subcategory');
    if (isempty(val)); val=''; end
    Subcategory{cnt}=val;
    val=contractDetailsMap.(symbol).('Industry');
    if (isempty(val)); val=''; end
    Industry{cnt}=val;
    val=contractDetailsMap.(symbol).('StockType');
    if (isempty(val)); val=''; end
    StockType{cnt}=val;
    cnt=cnt+1;
    
    catch exception
         
    end
end
    Industry=Industry';
    Category=Category';
    Subcategory=Subcategory';
    StockType=StockType';
Symbol=Symbol(1:numel(Industry))';
categorizedTable=table(Symbol,Industry,Category,Subcategory,StockType);

ctfn=[base 'categorizedTable.mat'];
save(ctfn,'categorizedTable');

%example use
categorizedTable(ismember(categorizedTable.Category,{'Pharmaceuticals'}),:)
categorizedTable(ismember(categorizedTable.Subcategory,{'Computers'}),:)
categorizedTable(ismember(categorizedTable.Subcategory,{'Airlines'}),:)
categorizedTable(ismember(categorizedTable.Subcategory,{'Airlines'}),:)
categorizedTable(ismember(categorizedTable.StockType,{'ETF'}),:)
