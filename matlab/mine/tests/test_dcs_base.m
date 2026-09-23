range=[1:10]';

Date=datetime()+minutes(range);
Low=100*ones(size(range));
High=101*ones(size(range));

Open=100+range/5;
Open(6:10)=101;

Close=102-range/5;
Close(1:5)=101;

Volume=zeros(size(range));

tt{1}=timetable(Date,Open,High,Low,Close,Volume);


%tt{1}=mainticks{3}.params.TimeTables.Minute;

tt{2}=gen2mfrom1m(tt{1});

[indicators{1}.lower,indicators{1}.upper]=indicators_t8(tt{1});
[indicators{2}.lower,indicators{2}.upper]=indicators_t8(tt{2});

figure

tlt=tiledlayout(5,1);

ax{1}=nexttile(tlt,[1,1]);
cndl5(tt{1});

ax{2}=nexttile(tlt,[1,1]);
plot(tt{1}.Date,indicators{1}.lower.dcs_close);

ax{3}=nexttile(tlt,[1,1]);
plot(tt{1}.Date,indicators{1}.lower.dcs_open);

ax{4}=nexttile(tlt,[1,1]);
plot(tt{1}.Date,indicators{1}.lower.dcs_total);

ax{5}=nexttile(tlt,[1,1]);
plot(tt{1}.Date,indicators{1}.lower.dcs_fight);

linkaxes([ax{1} ax{2} ax{3} ax{4} ax{5}],'x');