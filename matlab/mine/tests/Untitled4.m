%% init dates

%collect 1min data every weekend before they become unavailable
dtnow=datetime();
if (hour(dtnow)>=16)
 lastfullday=(day(dtnow));
else 
lastfullday=(day(dtnow)-(1));
end
days_=lastfullday:-1:1;
cmonth=month(dtnow);

if (cmonth==1)
   months_=1; %doesn't really matter.. the data must have been taken before
else
  months_=cmonth:-1:(cmonth-1);
end

year_=year(dtnow);


%% loop through symbols

symbols_yahoo;
s1=symbols;
symbols_tda;
s2=symbols;

allsymbols=unique([s1,s2]);
ns=numel(allsymbols);
for si=1:ns

    symbol=allsymbols(si);
    symbol=symbol{1}
    
%% init volumeproifle
minutesIndex=(1:390)';

DataCount=zeros(size(minutesIndex));
Volume=DataCount;
VolumeBuzzProfile=table(minutesIndex,Volume);
    
%% loop through dates

for j=months_
for i=days_
   date_=[num2str(year_) '-' num2str(j,'%02.f') '-' num2str(i,'%02.f')];

minutedatafilename=['Z:\My files\Project trading\traderdata\data\' filefriendlysymbol(symbol) '\' filefriendlysymbol(symbol)  ' minute ' date_ '.mat'];
if (exist(minutedatafilename))
load(minutedatafilename);

if (~isempty(tm))

dt=datetime(tm.Date);
minutesIndex=minutes(dt-dt(1))+1;
Volume=tm.Volume;

cum1=ones(size(minutesIndex));
cum1(isnan(Volume))=0;

DataCount(minutesIndex)=DataCount(minutesIndex)+cum1;

Volume(isnan(Volume))=0;

VolumeBuzzProfile(minutesIndex,:).Volume=VolumeBuzzProfile(minutesIndex,:).Volume+Volume;

end
end

end
end

VolumeBuzzProfile.Volume=VolumeBuzzProfile.Volume./DataCount;

vfilename=['Z:\My files\Project trading\traderdata\data_processed\volumeprofile\' filefriendlysymbol(symbol) ' volumebuzzprofile.mat'];
save(vfilename,'VolumeBuzzProfile');
end