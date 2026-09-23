function [mindis,mindislvl]=getmindis(tablecolumn)
try
[mindisabs,minindoflvl]=min(abs(tablecolumn-lvls),[],2);
mindislvl=lvls(minindoflvl)';
mindis=tablecolumn-mindislvl;
catch exception
getReport(exception,'extended','hyperlinks','off')
mindis=[];
mindislvl=[];
end
end