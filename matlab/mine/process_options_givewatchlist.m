contracts_yahoo;

for si=1:numel(contracts)
    try
contract=contracts{si};

 [baseoptions,~]=getOptionsViaYahooLast(contract.Symbol);
 
 
 % base data can be used to get best weekly option
 currentprice=(baseoptions.quote.bid+baseoptions.quote.ask)/2;
 nextcalloption=getNextCall(currentprice,baseoptions);
 nextcalloption.contractSymbol

 nextputoption=getNextPut(currentprice,baseoptions);
    nextputoption.contractSymbol 
    catch
        
    end
end