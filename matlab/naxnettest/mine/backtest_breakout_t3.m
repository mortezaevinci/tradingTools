%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show
clear all
close all

realtimeParams.symbols={'AAL','AAPL','AMD','AMZN','BAC','BA','TSLA','SHOP','WMT','SHOP','MSFT','NVDA','NFLX','DIS','FB','SPY'};

%% SETUP main
params.date='20_05_22';
params.getdata=1;

params.graph=2; %1 show if signals, 2 alwways show
params.showlimit=30;
params.processlimit=60;
params.enabled=[1;1;1];
params.scalepercent=1.1;

%% SETUP sub

params.thresh.avs.min=.7;
params.thresh.rvs.min=0.4; 
params.thresh.dvs.open.min=0;0.2;
params.thresh.dvs.close.min=0;0.3;
params.thresh.dvs.total.min=0;0.5;0.5;
params.thresh.dsma5.min=0.05;
params.thresh.ddsma5.min=0;

%% prepare 

 WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
Audio = audioplayer(WarnWave, 22050);

sir=2;
sis=ceil(numel(realtimeParams.symbols)/sir);
w=1860;
h=1080;

for si=1:numel(realtimeParams.symbols)
    sc=floor((si-1)/sir);
    sr=si-1-sc*sir;
    gcf{si}=figure;
    set(gcf{si},'name',realtimeParams.symbols{si}, 'outerposition',[w*sc/sis h*sr/sir w*1/sis h/sir]);
end


%% keep loop

while(1)

%% loop

crumb=[];
rq=[];

for si=1:numel(realtimeParams.symbols)
%% main tester
params.symbol=realtimeParams.symbols{si};

if (params.getdata==1)
   [rq,crumb]=getdata_today_func(params,rq,crumb);
%code for this later
%TimeTables.Minute=updaterealtime(symbol,TimeTables.Minute)
end

calculations=strategy_breakout_t1(params);
result=signals_max10_t1(calculations);

%% results
searchlen=5;

upc_last=calculations.upc(end-searchlen:end);
date_last=calculations.TimeTables.Minute.Date(end-searchlen:end);
disp(['BTO ' params.symbol]);
disp(date_last(upc_last>0))

dnc_last=calculations.dnc(end-searchlen:end);
date_last=calculations.TimeTables.Minute.Date(end-searchlen:end);
disp(['STO ' params.symbol]);
disp(date_last(dnc_last>0))

somethingtodo=(sum(upc_last)+sum(dnc_last)>0);

if (somethingtodo)
  
play(Audio); 
end

if (params.graph==2 || (params.graph==1 && somethingtodo))
graphStrategy(gcf{si},params,calculations,result);
end
end

end