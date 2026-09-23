function [mindis,mindislvl]=getmindis(tablecolumn)
try
[mindisabs,minindoflvl]=min(abs(tablecolumn-lvls),[],2);
mindislvl=lvls(minindoflvl)';
mindis=tablecolumn-mindislvl;
catch exception
dumpReport('error.log', exception)
mindis=[];
mindislvl=[];
end
end