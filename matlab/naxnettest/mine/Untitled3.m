
tic
bar(tbl.Date,tbl.Volume,'g');
grid on;
hold on;
bar(tbl.Date,sellv,'r');
toc
figure
tic

plot([tbl.Date],[tbl.Volume],'g');
hold on
plot([tbl.Date],[sellv],'r');

toc