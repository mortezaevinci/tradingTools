
for si=1:nsymbols
    clear tm td
    symbol=symbols{si};
    fn=[quotelocation symbol '\' symbol ' ' datatype ' ' datestring '.mat']
load(fn);
if (~exist('td'))
    td=tm;
end
if (~exist('tm'))
    tm=td;
end

if (trainingindex==1)
   tm=tm(1:end-1,:); 
end

[trainingdata{trainingindex}.mainticks{si}.params.TimeTables.Minute,~]=table2timetable(tm);
trainingdata{trainingindex}.quotes{si}=table2array(trainingdata{trainingindex}.mainticks{si}.params.TimeTables.Minute);

% 
% bookfilename=[booklocation symbol '_book_history ' datestring '.bin'];
% try
% trainingdata{trainingindex}.marketdata{si}=getProcessedMarketdata(bookfilename,datestring);
% 
% trainingdata{trainingindex}.pb1{si}=squeeze(trainingdata{trainingindex}.marketdata{si}.PercentileBook(:,1,:))';
% trainingdata{trainingindex}.pb3{si}=squeeze(trainingdata{trainingindex}.marketdata{si}.PercentileBook(:,3,:))';
% catch
%     disp('WARNING: marketdata not compatible.');
% end
end

xsecondary=zeros(size(trainingdata{trainingindex}.quotes{2},1),nsymbols-1);
for ss=2:nsymbols
   xsecondary(:,(1:4)+(ss-2)*4)= trainingdata{trainingindex}.quotes{ss}(:,1:4)/trainingdata{trainingindex}.quotes{ss}(1,1); %only looking at close of others
end

%%trainingdata{trainingindex}.quotes{1}(end,4)

candleofmain=[trainingdata{trainingindex}.quotes{1}(:,:)/trainingdata{trainingindex}.quotes{1}(1,1)];

Xdata=[candleofmain,xsecondary];%,trainingdata{trainingindex}.pb1{2},trainingdata{trainingindex}.pb3{2}];
Tdata=[trainingdata{trainingindex}.quotes{1}(:,1)/trainingdata{trainingindex}.quotes{1}(1,1)];

%fix the causality of the data
shiftedTdata=Tdata((predictmanysamples+1):end,:);

%just for understaing that T is not needed in prediction
T0_=zeros(size(Tdata((predictmanysamples+1):end,:)));
T0=tonndata(T0_,false,false);

X_=Xdata(1:end-predictmanysamples,:);

X = tonndata(X_,false,false);
T = tonndata(shiftedTdata,false,false);

x=X{1};
x(2)=nan;
X{1}=x;