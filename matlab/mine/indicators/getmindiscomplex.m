function [mindis,mindislvl]=getmindiscomplex(table,lvls)
try
[Lmindisabs,Lminindoflvl]=min(abs(table.Low-lvls),[],2);
[Hmindisabs,Hminindoflvl]=min(abs(table.High-lvls),[],2);

cmindisabs=[Lmindisabs,Hmindisabs];
[~,mddind]=min(cmindisabs,[],2);
iind=(mddind-1)*size(table,1)+(1:numel(table.Low))';

chl=[table.Low;table.High];
cminindoflvl=[Lminindoflvl;Hminindoflvl];


minindoflvl=cminindoflvl(iind);
hl=chl(iind);
mindislvl=lvls(minindoflvl)';
mindis=hl-mindislvl;
catch exception
dumpReport('error.log', exception)
mindis=[];
mindislvl=[];
end
end