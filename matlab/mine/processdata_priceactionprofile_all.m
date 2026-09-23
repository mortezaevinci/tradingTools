numberofdays=150;
%% loop through contracts

contracts_yahoo;
allcontracts=contracts;
%allcontracts={genContract([],'SPY')};

% allcontracts={...
% % genContract([],'AAL'),...
% % genContract([],'AAPL'),...
% % genContract([],'AMD'),...
% % genContract([],'AMZN'),...
% % genContract([],'BAC'),...
% % genContract([],'BA'),...
% % genContract([],'TSLA'),...
% % genContract([],'BYND'),...
% % genContract([],'WMT'),...
% % genContract([],'SHOP'),...
% % genContract([],'MSFT','MSFT','STK','SMART','NASDAQ'),...
% % genContract([],'NVDA'),...
% % genContract([],'NFLX'),...
% % genContract([],'DIS'),...
% % genContract([],'FB'),...
% genContract([],'SPY'),...
% % genContract([],'GLD'),...
% % genContract([],'SLV'),...
% % genContract([],'$TICK'),...
% % genContract([],'$VOLD')...
% };

ns=numel(allcontracts);
for si=1:ns

    try
    
    contract=allcontracts{si};
disp(   contract.Symbol );
%% init volumeproifle
minutesIndex=(1:390)';

DataCount=zeros(size(minutesIndex));
Open=DataCount;
High=DataCount;
Low=DataCount;
Close=DataCount;
Volume=DataCount;
temppap=table(minutesIndex,Open,High,Low,Close,Volume);
DataCountW={DataCount,DataCount,DataCount,DataCount,DataCount};
PriceActionProfileW={temppap,temppap,temppap,temppap,temppap};
PriceActionProfile=temppap;



    
%% loop through dates

for ds=(numberofdays-1):-1:0

    try
        
date_=datestr(datetime()-days(ds),'yyyy-mm-dd');%[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];

 if (isbusday(date_))
 
wd=weekday(date_)-1;
minutedatafilename=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(contract.FileSymbol) '\' filefriendlysymbol(contract.FileSymbol) ' minute ' date_ '.mat'];
if (exist(minutedatafilename))
load(minutedatafilename);

if (~isempty(tm))

dt=datetime(tm.Date);
minutesIndex=minutes(dt-dt(1))+1;
Volume=tm.Volume;
Open=tm.Open;
Close=tm.Close;
Low=tm.Close;
High=tm.High;

%  figure
%  plot(Close);

cum1=ones(size(minutesIndex));
cum1(isnan(Volume) | isnan(Open) | isnan(Close))=0;

if max(isnan(Volume))==1
  disp(['has bad data:' datestr(date_,'yyyy-mm-dd')] );
end

DataCount(minutesIndex)=DataCount(minutesIndex)+cum1;
DataCountW{wd}(minutesIndex)=DataCountW{wd}(minutesIndex)+cum1;

Volume(cum1==0)=0;
Open(cum1==0)=0;
Close(cum1==0)=0;
Low(cum1==0)=0;
High(cum1==0)=0;

PriceActionProfileW{wd}(minutesIndex,:).Volume=PriceActionProfileW{wd}(minutesIndex,:).Volume+Volume;
PriceActionProfileW{wd}(minutesIndex,:).Open=PriceActionProfileW{wd}(minutesIndex,:).Open+Open;
PriceActionProfileW{wd}(minutesIndex,:).Close=PriceActionProfileW{wd}(minutesIndex,:).Close+Close;
PriceActionProfileW{wd}(minutesIndex,:).Low=PriceActionProfileW{wd}(minutesIndex,:).Low+Low;
PriceActionProfileW{wd}(minutesIndex,:).High=PriceActionProfileW{wd}(minutesIndex,:).High+High;

PriceActionProfile(minutesIndex,:).Volume=PriceActionProfile(minutesIndex,:).Volume+Volume;
PriceActionProfile(minutesIndex,:).Open=PriceActionProfile(minutesIndex,:).Open+Open;
PriceActionProfile(minutesIndex,:).Close=PriceActionProfile(minutesIndex,:).Close+Close;
PriceActionProfile(minutesIndex,:).Low=PriceActionProfile(minutesIndex,:).Low+Low;
PriceActionProfile(minutesIndex,:).High=PriceActionProfile(minutesIndex,:).High+High;

end
end

 end
    catch
    end
    
end


for wd=1:5
PriceActionProfileW{wd}.Volume=PriceActionProfileW{wd}.Volume./DataCountW{wd};
PriceActionProfileW{wd}.Open=PriceActionProfileW{wd}.Open./DataCountW{wd};
PriceActionProfileW{wd}.Close=PriceActionProfileW{wd}.Close./DataCountW{wd};
PriceActionProfileW{wd}.Low=PriceActionProfileW{wd}.Low./DataCountW{wd};
PriceActionProfileW{wd}.High=PriceActionProfileW{wd}.High./DataCountW{wd};
end

PriceActionProfile.Volume=PriceActionProfile.Volume./DataCount;
PriceActionProfile.Open=PriceActionProfile.Open./DataCount;
PriceActionProfile.Close=PriceActionProfile.Close./DataCount;
PriceActionProfile.Low=PriceActionProfile.Low./DataCount;
PriceActionProfile.High=PriceActionProfile.High./DataCount;

vfilename=['Z:\My files\Project trading\traderdata\data_processed\priceactionprofile\PAPP1 ' filefriendlysymbol(contract.FileSymbol) '.mat'];
save(vfilename,'PriceActionProfile','PriceActionProfileW');

    catch exception
     dumpReport('error.log', exception) 
    
end

end

% figure
% plot(PriceActionProfile.Close)


figure
date0='2020-07-10';
wd=weekday(date0)-1

PriceActionProfileW{wd}.Date=datetime([date0 ' 09:30:00'])+minutes((0:389)');
cndl5(PriceActionProfileW{wd});

min_=min(PriceActionProfileW{wd}.Low);
max_=max(PriceActionProfileW{wd}.High);

ylim([min_ max_]);
