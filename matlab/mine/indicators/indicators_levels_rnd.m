function [levels] = indicators_levels_rnd(timetable,preps)
try
levels.color={};
levels.values=[];
levels.dir=[];
levels.style={};
levels.width=[];
levels.power=[];
levels.id=[];
levels.name={};

[hlvls,llvls]=roundLevelsAll(timetable);
for i=1:2
   dh_{i}=repmat(0,1,numel(hlvls{i}));
   wh_{i}=repmat(i,1,numel(hlvls{i}));
   dl_{i}=repmat(0,1,numel(llvls{i}));
   wl_{i}=repmat(i,1,numel(llvls{i}));
   pl_{i}=repmat(i,1,numel(llvls{i}));
   ph_{i}=repmat(i,1,numel(hlvls{i}));
end
levels.values=[llvls{1} llvls{2} hlvls{1} hlvls{2}];
levels.color =cell(size(levels.values));
levels.style =cell(size(levels.values));
levels.name =cell(size(levels.values));
for uu=1:numel(levels.values)
    levels.color{uu}=[.5 .5 .5 preps.alpha];
    levels.style{uu}='--';
    levels.name{uu}='RND';
end
levels.dir =[dl_{1} dl_{2} dh_{1} dh_{2}];
levels.width =[wl_{1} wl_{2} wh_{1} wh_{2}];
levels.power =[pl_{1} pl_{2} ph_{1} ph_{2}];
xx=1:numel(levels.values);
levels.id =0x0700+uint16(xx);

catch exception
   dumpReport('error.log', exception) 
      
end
end

