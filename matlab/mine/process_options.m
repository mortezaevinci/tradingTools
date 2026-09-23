symbol='MSFT';

 [baseoptions,~]=getOptionsViaYahooLast(symbol);
 
 ndates=numel(baseoptions.expirationDates);
  for ni=1:ndates
     [options{ni},~]=getOptionsViaYahooByEpoch(symbol,baseoptions.expirationDates(ni));
     
  end
 
  basedt=datetime(baseoptions.expirationDates(1), 'ConvertFrom', 'posixtime');
  basemondaydate=basedt-days(weekday(basedt))+days(2);
  
  optionprofilefilename=['Z:\My files\Project trading\traderdata\options\' filefriendlysymbol(FileSymbol) '\' filefriendlysymbol(FileSymbol)  ' options ' datestr(basemondaydate,'yyyy-mm-dd') '.mat'];
  save(optionprofilefilename,'options');
 
 symbols=extractOptioncontracts(options);
 
 IBsymbols=YahooOptioncontracts2IBOptionsSymbols(symbol,symbols);
 
 % base data can be used to get best weekly option
 currentprice=(baseoptions.quote.bid+baseoptions.quote.ask)/2;
 nextcalloption=getNextCall(currentprice,baseoptions);
 nextcalloption.strike
 nextcalloption.contractSymbol
 dt=datetime(nextcalloption.expiration, 'ConvertFrom', 'posixtime');

 datestr(dt,'yymmdd')
 ibsymbol=YahooOptionSymbol2IBOptionsSymbol(symbol, nextcalloption.contractSymbol)
 
  nextputoption=getNextPut(currentprice,baseoptions);
 nextputoption.strike