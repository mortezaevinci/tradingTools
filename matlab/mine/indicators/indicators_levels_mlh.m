function [levels,mc,mo] = indicators_levels_mlh(timetable,intradaydateend,preps)
levels.color={};
levels.values=[];
levels.dir=[];
levels.style={};
levels.width=[];
levels.power=[];
levels.id=[];
levels.name={};
try
    themorningdate=datetime([datestr(intradaydateend,'yyyy-mm-dd') ' 09:30:00']);
    
 %%;tic
% for monthly pivots
tr=timerange(themorningdate- day(themorningdate)-day(28)-day(10), themorningdate);
molast=timetable(tr,:);
lastmonthquote=molast(1,:);
mo=molast(end,:).Open;
mc=lastmonthquote.Close;
levels.values(1)=lastmonthquote.Low;
levels.values(2)=lastmonthquote.High;

levels.color={[0 0.8 0 preps.alphalong],[1 0 0 preps.alphalong]};
levels.style={'-','-'};
levels.dir=[-1 1];
levels.width=[3 3];
levels.power=[3 3];
levels.name={'MLL','MLH'};
levels.id=[0x0B00 0x0B01];
 %%;ticprep=toc
catch exception
   dumpReport('error.log', exception) 
    
end
end

