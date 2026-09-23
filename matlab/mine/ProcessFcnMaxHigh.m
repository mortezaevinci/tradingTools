function maxh=ProcessFcnMaxHigh(processedData,marketData)
%receives one row of ib marketdata
maxh=max(processedData,marketData(5));
end