% 
% priceAbove	5
% volumeAbove 100000
% AFTERHRSCHANGEPERC 2
% marketCapAbove1e6	200
% 
% 
% afterHoursChangePercAbove
% changePercAbove
% changePercBelow
% 
% scancode doesn't matter, just add something that shows all
% Maybe
% ALL_SYMBOLS_ASC
% MOST_ACTIVE
% 
% STK
% ALL
% STK.US.MAJOR

%parameters

%     t1 = IBApi.TagValue("usdMarketCapAbove", "10000");
%     t2 = IBApi.TagValue("optVolumeAbove", "0");
%     t3 = IBApi.TagValue("avgVolumeAbove", "1000000");
    tv{1} = IBApi.TagValue("marketCapAbove1e6", "200");
    tv{2} = IBApi.TagValue("volumeAbove", "100000");
    tv{3} = IBApi.TagValue("priceAbove", "5");
    tv{4} = IBApi.TagValue("changePercBelow", "-0.5");
    
    tvs = NET.createGeneric('System.Collections.Generic.List',{'IBApi.TagValue'},numel(tv));
    for i=1:numel(tv)
    tvs.Add(tv{i});
    end
    
 tvsscanner=NET.createGeneric('System.Collections.Generic.List',{'IBApi.TagValue'},0);
            
 subscription = IBApi.ScannerSubscription;
 subscription.ScanCode = 'HOT_BY_PRICE';
 subscription.Instrument = 'STK';
 subscription.LocationCode = 'STK.US.MAJOR';
 subscription.StockTypeFilter = 'ALL';
 subscription.NumberOfRows = ibscansize;    
