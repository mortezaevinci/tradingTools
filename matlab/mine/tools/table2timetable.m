function [StockData_TimeTable, success]=table2timetable(StockData)
success=0;
try
    
if isnumeric(StockData.Open) == false
    Open =cellfun(@str2double,StockData.Open);
    High = cellfun(@str2double,StockData.High);
    Low = cellfun(@str2double,StockData.Low);
    Close = cellfun(@str2double,StockData.Close);
    %AdjustedClose = cellfun(@str2double,StockData.AdjClose);
    Volume = cellfun(@str2double,StockData.Volume);
else
    Open = StockData.Open;
    High = StockData.High;
    Low = StockData.Low;
    Close = StockData.Close;
   % AdjustedClose = StockData.AdjClose;
    Volume =  StockData.Volume;
end
Date = datetime(StockData.Date);

%Tranform the data to timetable
StockData_TimeTable = timetable(Date,Open,High,Low,Close,Volume);

%Check for missing Data
%Fill the missing data with linear
if any(any(ismissing(StockData_TimeTable)))==true
    StockData_TimeTable = fillmissing(StockData_TimeTable,'linear');
end
success=1;
%Delete the row if volume is 0
%StockData_TimeTable(StockData_TimeTable.Volume==0,:) =[];
catch exception
dumpReport('error.log', exception)
StockData_TimeTable=timetable();
end
end