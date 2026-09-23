%% prepare main directories

fns=fieldnames(looperEngine.directories);
nfns=numel(fns);
for i=1:nfns
   fn=cell2mat(fns(i));
   dir0=getfield(looperEngine.directories,fn);
   if (~exist(dir0))
      mkdir (dir0);
   end
end

%% prepare tickers
basedir=looperEngine.directories.data;

ncommon=numel(commonticks);
ncontracts=numel(looperEngine.contracts);

if (looperEngine.sortContracts==1)
%sort contracts for easier use
symbols={};
for i=1:ncontracts
    symbols{end+1}=looperEngine.contracts{i}.Symbol;
    
end
[~,sind]=sort(symbols);
looperEngine.contracts=looperEngine.contracts(sind);
end

for si=1:ncommon
    commonticks{si}.calculations=struct();
    commonticks{si}.result=cell(1,1);
    commonticks{si}.params.si=si;
    commonticks{si}.params.HistoricalDataUpdate.TimeTable=timetable();
    commonticks{si}.params.RealTimeBar.TimeTable=timetable();
    commonticks{si}.params.TimeTables=struct();
end

for si=1:ncontracts
    mainticks{si}.calculations=struct();
    mainticks{si}.result=cell(1,1);
    mainticks{si}.params=tempsymbol.params;
    mainticks{si}.params.contract=looperEngine.contracts{si};
    mainticks{si}.params.si=si;
    mainticks{si}.params.commonticks=0;
    mainticks{si}.params.HistoricalDataUpdate.TimeTable=timetable();
    mainticks{si}.params.RealTimeBar.TimeTable=timetable();
    mainticks{si}.params.TimeTables=struct();
    for ci=1:ncommon
        if (strcmp(mainticks{si}.params.contract.Symbol,commonticks{ci}.params.contract.Symbol))
            mainticks{si}.params.commonticks=ci;
        end
    end   
    
    directory_=[basedir mainticks{si}.params.contract.FileSymbol '\'];
    if (~exist(directory_))
    mkdir(directory_);
    end
end


%% run bookview
if (looperEngine.book.runOnDemand>0)
csv_symbols='';

for i=1:numel(looperEngine.contracts)
    csv_symbols=[csv_symbols looperEngine.contracts{i}.Symbol ','];
end
csv_symbols=csv_symbols(1:end-1);

bookviewcommand=['start /MIN "ONDEMAND" "' looperEngine.files.bookviewrunner '" ' csv_symbols ' 50 5000 "' looperEngine.directories.book '"']
status = system(bookviewcommand);

looperEngine.book.Engine.startTime=datetime();
end