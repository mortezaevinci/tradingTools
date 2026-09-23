function [levels] = indicators_levels_orb(timetable,preps)
try
levels.color={};
levels.values=[];
levels.dir=[];
levels.style={};
levels.width=[];
levels.power=[];
levels.id=[];
levels.name={};

if (size(timetable,1)>60) %60 minutes from star
     levels.values(2)=max(timetable.High(1:60));
     levels.values(1)=min(timetable.Low(1:60));
     levels.colors ={[0 1 0  preps.alphalong],[1 0 0 preps.alphalong]};
levels.style ={'-','-'};
levels.dir =[0 0];
levels.width =[1 1];
levels.power =[1 1];
levels.id =[0x0200 0x0201];
levels.name ={'ORL','ORH'};

end

catch exception
   dumpReport('error.log', exception) 
      
end
end

