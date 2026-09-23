if (looperEngine.IB.run==1)

try
for i=1:(looperEngine.IB.Engine.currentTicker.realtimebars-1)
    reqid=looperEngine.IB.Engine.ibWrapper.RT_BARS_ID_BASE+i;
    looperEngine.IB.ibClient.ClientSocket.cancelRealTimeBars(reqid);
    pause(.05)
end
catch exception
    
end

try
for i=1:(looperEngine.IB.Engine.currentTicker.historicaldata-1)
    reqid = looperEngine.IB.Engine.ibWrapper.HISTORICAL_ID_BASE + i;
    looperEngine.IB.ibClient.ClientSocket.cancelHistoricalData(reqid);
    pause(.05)
end

catch exception
    
end



 if (looperEngine.IB.ibClient.ClientSocket.IsConnected()  ==1)
    looperEngine.IB.Engine.ibWrapper.Disconnect();
 end
 
end