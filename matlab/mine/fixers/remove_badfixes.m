apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;
disabled=0;

basedir='Z:\My files\Project trading\traderdata\data\';
numberofdays=200;

    contracts_yahoo;
%     contracts={
% genContract([],'BNTX'),...
% };
    nc=numel(contracts);
    
for ds=45:(numberofdays-1)

try
    date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
   % date0=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
    if (isbusday(date0))
    date1=date0;
    date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');

   
  for i=1:nc
      try
     name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' minute ' date1 '.mat'];
     load(name);
     
if (sum(diff(tm.Date)~=minutes(1))>0)
    disp(name);
end
      catch
          
      end
  end
       
    end
catch exception
    
end
end