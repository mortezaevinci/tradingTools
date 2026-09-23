function minDisProfile=getsignedmindis(tablecolumn)
try
d=tablecolumn-lvls;
signedd{1}=d;
signedd{1}(d>0)=-10000;
signedd{2}=d;
signedd{2}(d<0)=10000;

for i=1:2
[~,minindoflvl]=min(abs(signedd{i}),[],2);
minDisProfile.mindislvl{i}=lvls(minindoflvl)';
minDisProfile.mindis{i}=tablecolumn-mindislvl;
end
catch exception
dumpReport('error.log', exception)
minDisProfile.mindislvl={};
minDisProfile.mindis={};
end
end