function output=HandledHistoricalDataEnd_getarray_Fcn_ignore(src,event)
%just clear them ,to receive last upsdates. historical is done by yahoo
    src.CleanUpHistoricalData(); 
    src.CleanUpHistoricalDataEnd(); % CleanUpHistoricalDataEnd instead, dll was not developed yet at the time
        
    disp('IB historical data ignored.');
end