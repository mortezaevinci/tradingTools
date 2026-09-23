function [levels] = indicators_levels_adh(timetable,preps)
try
levels.color={};
levels.values=[];
levels.dir=[];
levels.style={};
levels.width=[];
levels.power=[];
levels.id=[];
levels.name={};

if (~isempty(timetable))
tmfulltime=timetable.Date.Hour+timetable.Date.Minute/60;
pminds=find(tmfulltime<9.5 & tmfulltime>=4);
%all day high including premarket
levels.values(2)=max(timetable.High(pminds));
levels.values(1)=min(timetable.Low(pminds));
levels.color={[0.9 0.6 0  preps.alphalong],[0.9 0.6 0 preps.alphalong]};
levels.style={'-','-'};
levels.dir=[0 0];
levels.width=[2 2];
levels.power=[2 2];
levels.id=[0x0C00 0x0C01];
levels.name={'ADL','ADH'};
end

catch exception
   dumpReport('error.log', exception) 
      
end
end

