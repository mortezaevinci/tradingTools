capturedate=datetime();

contracts_yahoo;



for si=1:numel(contracts)
    try
contract=contracts{si};
contract.Symbol
 optionprofilefilename=[directory_  filefriendlysymbol(contract.FileSymbol)  ' options base ' datestr(capturedate,'yyyy-mm-dd') '.mat'];
 if(exist(optionprofilefilename)==0)
directory_=['Z:\My files\Project trading\traderdata\options\' filefriendlysymbol(contract.FileSymbol) '\'];
    if (~exist(directory_))
    mkdir(directory_);
    end

 [baseoptions,~]=getOptionsViaYahooLast(contract.Symbol);
 
 ndates=numel(baseoptions.expirationDates);
  for ni=1:ndates
     [options{ni},~]=getOptionsViaYahooByEpoch(contract.Symbol,baseoptions.expirationDates(ni));
     
  end
 
 % basedt=datetime(baseoptions.expirationDates(1), 'ConvertFrom', 'posixtime');
 % basemondaydate=basedt-days(weekday(basedt))+days(2);
  
   
  
  save(optionprofilefilename,'options');
 end
  
    catch exception
        
    end
end