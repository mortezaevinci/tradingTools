cnt=1000;
for i=1:cnt
    msg.Ticks{i}.Size=2;
    msg.Ticks{i}.Price=1;
    msg.Ticks{i}.TickAttribLast.PastLimit=false;
    msg.Ticks{i}.TickAttribLast.Unreported=true;
    msg.Ticks{i}.Exchange="sdfsdfsdf";
    msg.Ticks{i}.SpecialConditions="sdf";
    msg.Ticks{i}.Time=123123123;
end

tic;

tick=msg.Ticks{1};

t = table(datetime(tick.Time,'ConvertFrom','posixtime','TimeZone','America/New_York'),...
    tick.Price,tick.Size,...
    'VariableNames', {'Date','Price','Size'});
historicalTicksLast = repmat(t,cnt,1);

for i=2:cnt
    tick=msg.Ticks{i};
    
    t = table(datetime(tick.Time,'ConvertFrom','posixtime','TimeZone','America/New_York'),...
        tick.Price,tick.Size,...
        'VariableNames', {'Date','Price','Size'});
    
    historicalTicksLast(i,:) = t;
    
end

toc
