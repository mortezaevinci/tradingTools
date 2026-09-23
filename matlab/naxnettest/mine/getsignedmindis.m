function minDisProfile=getsignedmindis(tablecolumn,lvls)
try
%1=close from lower level (positive value)
%2=close from upper level (negative value)

d=tablecolumn-lvls;
signedd{2}=d;
signedd{2}(d>0)=-10000;
signedd{1}=d;
signedd{1}(d<0)=10000;

for i=1:2
[~,minindoflvl]=min(abs(signedd{i}),[],2);
minDisProfile.mindislvl{i}=lvls(minindoflvl)';
minDisProfile.mindis{i}=tablecolumn-minDisProfile.mindislvl{i};
end
catch exception
getReport(exception,'extended','hyperlinks','off')
minDisProfile.mindis={};
minDisProfile.mindislvl={};
end
end