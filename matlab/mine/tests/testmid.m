symbol='BYND';

b=['z:\My files\Project Trading\traderdata\data_other\IB\' symbol '\'];

f1=[b symbol ' minute 2020-08-05.mat'];
f2=[b symbol ' minute-BID 2020-08-05.mat'];
f3=[b symbol ' minute-ASK 2020-08-05.mat'];
f4=[b symbol ' minute-MIDPOINT 2020-08-05.mat'];


% 
% load(f2);
% plot(tm.Date,tm.Open,'r');
% hold on;
% load(f3);
% plot(tm.Date,tm.Open,'r');
% hold on;
% load(f1);
% tmt=tm;
% plot(tm.Date,tm.Open,'g');

figure
load(f4);
plot(tm.Date,tm.Close,'r');
hold on;
load(f1);
tmt=tm;
%plot(tm.Date,tm.Close,'g');
cndl5(tm);
hold on;
load(f4);
plot(tm.Date,tm.Close,'b.');
plot(tm.Date,tm.Open,'b.');

load(f4);
ss=cumsum(tmt.Close-tm.Close);
ss2=cumsum(tmt.Open-tm.Open);
figure
plot(tm.Date,ss+ss2);