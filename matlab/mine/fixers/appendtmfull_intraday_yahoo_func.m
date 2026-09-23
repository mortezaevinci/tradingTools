function  appendtmfull_intraday_yahoo_func(basedir,contracts,date1,date2)


rq=[];
c=[];

  
for i=1:numel(contracts)
	try
version='';
name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' minute ' date1 '.mat'];
if (exist(name) && isbusday(date1))

    clear tmfull_tda;
    load(name);

  if (strcmp(version,'yahoo')==1 || strcmp(version,'yahoo+tda')==1)

        
    if (~exist('tmfull_tda'))
       
      
      
      if (exist('tmfull')==1 && ~exist('tmfull_tda'))
         tmfull_tda=tmfull; 
  
      end
      
       if (~exist('tmfull_tda'))
        tmfull_tda=[];
      end
      
    contracts{i}.Symbol
   [tmfull,jmfull,rq,c]=getMarketDataViaYahooByPeriod(contracts{i}.Symbol, date1,date2, '1m',rq,c); 
   
   save(name,'tmfull','jmfull','tmfull_tda','-append');
   
   if (~isempty(tmfull))


   else
       disp('could not grab data.');
    
   end
   
   end

   end
end
   catch exception
       dumpReport('error.log', exception) 
        
   end
end
end

