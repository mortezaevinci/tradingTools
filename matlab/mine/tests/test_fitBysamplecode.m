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

profilerlength=[5 9 20];

symbol='AAPL';
date='2020-07-17';
basedir='Z:\My files\Project trading\traderdata\data\';

filename=[basedir symbol '\' symbol ' minute ' date '.mat'];

load(filename);
tm=tm(100:200,:);
plottradeguide(tm.Close,tm.Open,tm.High,tm.Low,symbol);