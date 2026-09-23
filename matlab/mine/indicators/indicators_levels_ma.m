function [levels] = indicators_levels_ma(timetable,preps)
try
levels.color={};
levels.values=[];
levels.dir=[];
levels.style={};
levels.width=[];
levels.power=[];
levels.id=[];
levels.name={};

ema200p=zeros(size(timetable.Close));
ema50p=zeros(size(timetable.Close));
sma200p=zeros(size(timetable.Close));
sma50p=zeros(size(timetable.Close));
try

sma50p=movavg(timetable.Close,'simple',50);
sma200p=movavg(timetable.Close,'simple',200);

ema50p=movavg(timetable.Close,'exponential',50);
ema200p=movavg(timetable.Close,'exponential',200);

catch
    
end

levels.values=[sma50p(end) sma200p(end) ema50p(end) ema200p(end)];
levels.color={[0 0 1 preps.alphalong],[0 0 1  preps.alphalong],[0 0 1  preps.alphalong],[0 0 1  preps.alphalong]};
levels.style={'-','-','-','-'};
levels.dir=[0 0 0 0];
levels.width=[2 3 2 3];
levels.power=[2 3 2 3];
levels.id=[0x0A00 0x0A01 0x0A02 0x0A03];
levels.name={'SMA50','SMA200','EMA50','EMA200'};
catch exception
   dumpReport('error.log', exception) 
     
end
end

