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

symbol='AAL';
date='2020-07-17';
basedir='Z:\My files\Project trading\traderdata\data\';

filename=[basedir symbol '\' symbol ' minute ' date '.mat'];
load(filename);


cndl5(tm);
ylim([min(tm.Low) max(tm.High)]);

tm=tm(1:200,:);
hold on;
pointsl=[];
pointsh=[];
for pl=profilerlength

localOptimaProfile=localOptimaProfiler(pl,tm,1);

 pointsh=[pointsh; [localOptimaProfile.indices{1},localOptimaProfile.localoptima{1}(localOptimaProfile.indices{1})]];
 pointsl=[pointsl; [localOptimaProfile.indices{2},localOptimaProfile.localoptima{2}(localOptimaProfile.indices{2})]];
   
 plot(tm.Date,localOptimaProfile.localoptima{1},'v');
 plot(tm.Date,localOptimaProfile.localoptima{2},'^');
end
 
%all points gathered

sampleSize = 8; % number of points to sample per trial
maxDistance = .05; %this should be something like 10% of ATR?

points=pointsl;

fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1); % fit function using polyfit
evalLineFcn = ...   % distance evaluation function
  @(model, points) sum((points(:, 2) - polyval(model, points(:,1))).^2,2);

[modelRANSAC, inlierIdx] = ransac(points,fitLineFcn,evalLineFcn, ...
  sampleSize,maxDistance);

modelInliers = polyfit(points(inlierIdx,1),points(inlierIdx,2),1);

inlierPts = points(inlierIdx,:);
x = [min(inlierPts(:,1)) max(inlierPts(:,1))];
y = modelInliers(1)*x + modelInliers(2);
plot(tm.Date(x), y, 'g-')
legend('Noisy points','Least squares fit','Robust fit');

points=pointsh;

fitLineFcn = @(points) polyfit(points(:,1),points(:,2),1); % fit function using polyfit
evalLineFcn = ...   % distance evaluation function
  @(model, points) sum((points(:, 2) - polyval(model, points(:,1))).^2,2);

[modelRANSAC, inlierIdx] = ransac(points,fitLineFcn,evalLineFcn, ...
  sampleSize,maxDistance);

modelInliers = polyfit(points(inlierIdx,1),points(inlierIdx,2),1);

inlierPts = points(inlierIdx,:);
x = [min(inlierPts(:,1)) max(inlierPts(:,1))];
y = modelInliers(1)*x + modelInliers(2);
plot(tm.Date(x), y, 'g-')
legend('Noisy points','Least squares fit','Robust fit');
