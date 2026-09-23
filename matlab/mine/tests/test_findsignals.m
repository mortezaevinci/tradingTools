close all

% load cursiveex
% plot(data)
% xlabel('real')
% ylabel('imag')
% signal=signal-1500;
% 
% findsignal(data,signal,'TimeAlignment','dtw', ...
%                'Normalization','center', ...
%                'NormalizationLength',500, ...
%                'MaxNumSegments',2)
     

symbol='AAPL';
date='2020-07-06';
basedir='Z:\My files\Project trading\traderdata\data\';

filename=[basedir symbol '\' symbol ' minute ' date '.mat'];

load(filename);

cndl5(tm);
ylim([min(tm.Low) max(tm.High)]);

mc=[tm.Open, tm.High,tm.Low,tm.Close];
mimicall=reshape(mc',[numel(mc) 1]);
mimicall=movmean(mimicall,[50 0]);

wsignal=[10 9 8 7 6 5 4 3 2 1 2 3 4 5 6 7 8 9 10  9 8 7 6 5 5 4 3 2 1 2 3 4 5 6 7 8 9 10];
figure
 findsignal(mimicall,wsignal,...
     'TimeAlignment','dtw', ...'TimeAlignment','edr','EDRTolerance',90, ...
                'Normalization','center', ...
                'NormalizationLength',300, ...
                'MaxNumSegments',1)
            
            
wsignal=[1 2 3 4 5 6 7 8 9 8 7 6 5 4 3 2 1 2 3 4 5 6 7 8 9 8 7 6 5 4 3 2 1];
figure
 findsignal(mimicall,wsignal,...
     'TimeAlignment','dtw', ...'TimeAlignment','edr','EDRTolerance',90, ...
                'Normalization','center', ...
                'NormalizationLength',300, ...
                'MaxNumSegments',1)