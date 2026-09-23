function PlotFlirData(FD)
%% Plot FD data
%   FD.time       aquisition type duration 

%   FD.mean       mean temperature vector
%   FD.temp       vector of temperature bin (from T-0.5 to T+0.5)
%   FD.tempfrac   isotermal area fraction maxtrix (time,temp)
%
% 2019 erik.esveld@wur.nl
%% Heatmap in time plot
% we use imagesc ( heatmap itself does not work well)
% note that cdata(1,1) is nomally uppper left
% but not when ax.YDir = 'Normal' such as in plot
fi = figure;
fi.Color = 'w';
% because imagesc does not support creation of duration rulers, 
% we first use plot with duration as x data and mean value as y data
plot(FD.time,FD.mean,'.k');
hold on;
% give the ranges for the image data
timerange = [FD.time(1) FD.time(end)];
temprange = [FD.temp(1) FD.temp(end)];
fracrange = [0 0.3];
% convert x duration to num and plot transposed 
%hold on;
hold on;
%im = imagesc(gca, datenum(timerange),temprange,FD.tempfrac,fracrange);
im=imagesc(datenum(timerange),FD.temp,FD.tempfrac);
% plot a line with the time average value
plot(timerange,repmat(mean(FD.mean),1,2),'--b');
% make image transparant to show the datapoint from the first plot
im.AlphaData = .7;
% or change sort order from chlildren to depth (image depth = [-1 1])
ax  = gca;
% ax.SortMethod= 'depth';
colormap(flipud(bone));
% set scales
 xlim(timerange);
%xlim(duration({'9:37:00','9:38:00'}));
%ylim([-20 0]);
% set labels

% set window and axes
fi.Position = [219 584 952 301];
ax.Position = [0.0683 0.1827 0.8897 0.7423];
end
