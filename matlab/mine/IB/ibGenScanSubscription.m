function [subscription,tvs] =ibGenScanSubscription(scanParams)

ibscansize=50;
clear tv;
for tvcnt=1:numel(scanParams)
    tv{tvcnt} = IBApi.TagValue(scanParams{tvcnt}.key, scanParams{tvcnt}.value);
    end

    tvs = NET.createGeneric('System.Collections.Generic.List',{'IBApi.TagValue'},numel(tv));
    for i=1:numel(tv)
    tvs.Add(tv{i});
    end
    
% tvsscanner=NET.createGeneric('System.Collections.Generic.List',{'IBApi.TagValue'},0);
            
 subscription = IBApi.ScannerSubscription;
 subscription.ScanCode = 'ALL_SYMBOLS_ASC';
 subscription.Instrument = 'STK';
 subscription.LocationCode = 'STK.US.MAJOR';
 subscription.StockTypeFilter = 'ALL';
 subscription.NumberOfRows = ibscansize;    

end