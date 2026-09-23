
for si=1:nsymbols
    symbol=symbols{si};
    fn=[quotelocation symbol ' minute ' datestring '.mat']
load(fn);
[trainingdata{trainingindex}.mainticks{si}.params.TimeTables.Minute,~]=table2timetable(tm);
trainingdata{trainingindex}.quotes{si}=table2array(trainingdata{trainingindex}.mainticks{si}.params.TimeTables.Minute);

end

xsecondary=zeros(size(trainingdata{trainingindex}.quotes{2},1),nsymbols-1);
for ss=2:nsymbols
   xsecondary(:,ss-1)= trainingdata{trainingindex}.quotes{ss}(:,4)/trainingdata{trainingindex}.quotes{ss}(1,1); %only looking at close of others
end


candleofmain_=[trainingdata{trainingindex}.quotes{1}(:,:)/trainingdata{trainingindex}.quotes{1}(1,1)];

candleofmain=candleofmain_;
for i=1:timedelays
    candleofmain=[candleofmain_,shift(candleofmain,-1)];
end

X_=[candleofmain,xsecondary];%,trainingdata{trainingindex}.pb1{2},trainingdata{trainingindex}.pb3{2}];

X_=X_(1:end-timedelays,:);

viewx=candleofmain_((1+timedelays):end,1);

tdata=[trainingdata{trainingindex}.quotes{1}(:,4)/trainingdata{trainingindex}.quotes{1}(1,1)];
tdata=tdata((1+timedelays):end,:);

stdata=shift(tdata,-10);
stdata(end-10:end)=NaN;

delta=stdata-tdata;

thresh=0.01;

T_=[delta>thresh,(delta>-thresh & delta<thresh),delta<-thresh];

X = X_';%tonndata(X_,false,false);
T = T_';%tonndata(shiftedTdata,false,false);


