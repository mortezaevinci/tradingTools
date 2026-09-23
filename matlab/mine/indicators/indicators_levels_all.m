function combinedLevels = indicators_levels_all(levels,viewingScale)
try
 
 %%;tic
combinedLevels.values=[levels.values];
combinedLevels.color=[levels.color];
combinedLevels.style=[levels.style];
combinedLevels.direction=[levels.dir];
combinedLevels.width=[levels.width];
combinedLevels.power=[levels.power];
combinedLevels.id=[levels.id];
combinedLevels.name=[levels.name];

% remove far away levels that we do not care for

inind=find(combinedLevels.values>viewingScale(1) & combinedLevels.values<viewingScale(2));
combinedLevels.values=combinedLevels.values(inind);
combinedLevels.color=combinedLevels.color(inind);
combinedLevels.direction=combinedLevels.direction(inind);
combinedLevels.width=combinedLevels.width(inind);
combinedLevels.power=combinedLevels.power(inind);
combinedLevels.id=combinedLevels.id(inind);
combinedLevels.style=combinedLevels.style(inind);
combinedLevels.name=combinedLevels.name(inind);

%numel(combinedlevels.values)

% sort levels for later additional analysis
[~,sindex]=sort(combinedLevels.values);
combinedLevels.values=combinedLevels.values(sindex);
combinedLevels.color=combinedLevels.color(sindex);
combinedLevels.direction=combinedLevels.direction(sindex);
combinedLevels.width=combinedLevels.width(sindex);
combinedLevels.power=combinedLevels.power(sindex);
combinedLevels.id=combinedLevels.id(sindex);
combinedLevels.style=combinedLevels.style(sindex);
combinedLevels.name=combinedLevels.name(sindex);
 %%;ticslevels=toc

catch exception
   dumpReport('error.log', exception) 
      
end
end

