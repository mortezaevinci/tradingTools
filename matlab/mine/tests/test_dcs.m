length=3;
tt{1}=mainticks{15}.params.TimeTables.Minute;
[indicators{1}.lower,indicators{1}.upper]=indicators_t8(tt{1},mainticks{15}.params.TimeTables.Day);
for i=1:length-1

tt{i+1}=gen2mfrom1m(tt{i},i);
[indicators{i+1}.lower,indicators{i+1}.upper]=indicators_t8(tt{i+1},mainticks{15}.params.TimeTables.Day);
end

figure


tlt=tiledlayout(length*2+1,1);

for i=1:length
ax{1,i}=nexttile(tlt,[1,1]);
cndl5(tt{i});

ax{2,i}=nexttile(tlt,[1,1]);
plot(tt{i}.Date,indicators{i}.lower.dcs_fight);

end

ax2=nexttile(tlt,[1 1]);
plot(tt{1}.Date,(indicators{1}.lower.dcs_fight+indicators{2}.lower.dcs_fight+indicators{3}.lower.dcs_fight)/3);

linkaxes([ax{1,:}],'y');

linkaxes([ax{1,:} ax{2,:} ax2],'x');