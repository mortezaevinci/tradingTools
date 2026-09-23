basedir='Z:\My files\Project trading\traderdata\data\';

apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
periodType='month';
period=1;
frequencyType='daily';
frequency=1;
disabled=0;

numberofdays=90;
beginning=1;

if (datetime().Hour>=20) %after 8 o'clock, get today's data as well.
    beginning=0;
end
for ds=beginning:(numberofdays-1)
    
    try
        date0=datestr(datetime()-days(ds),'yyyy-mm-dd');
        % date0=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
        if (isbusday(date0))
            date1=date0;%[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
            date2=datestr(datetime(date1)+days(1),'yyyy-mm-dd');
            
            
            contracts_yahoo;
            %       contracts={genContract([],'TWTR'),...
            %    };
            getdata_dailyset_yahoo_func(basedir,contracts,date0,500,'1y');
            
            
            contracts_TDA;
            getdata_daily1y_TDA_func(basedir,contracts,date0);
            
            
            contracts_nasdaq;
            getdata_dailyset_yahoo_func(basedir,contracts,date0,500,'1y');
            
            contracts_penniesm2;
            getdata_dailyset_yahoo_func(basedir,contracts,date0,500,'1y');
            
        end
        
    catch exception
        dumpReport('error.log', exception)
    end
end


% %collect 1min data every weekend before they become unavailable
% dtnow=datetime();
% if (hour(dtnow)>=16)
%  lastfullday=(day(dtnow));
% else
% lastfullday=(day(dtnow)-(1));
% end
% days_=lastfullday:-1:1;
% cmonth=month(dtnow);
%
% if (cmonth==1)
%    months_=1; %doesn't really matter.. the data must have been taken before
% else
%   months_=cmonth:-1:(cmonth-1);
% end
%
% year_=year(dtnow);
%
% contracts_TDA;
%
% apikey='9DA0ZYLF59IGMA6TDXEGKFXVEKAC3TWS';
% periodType='month';
% period=1;
% frequencyType='daily';
% frequency=1;
% disabled=0;
%
% for j=months_
% for i=days_
%     date0=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];
%
%     getdata_daily1y_TDA_func(contracts,date0);
%
% end
%
% end