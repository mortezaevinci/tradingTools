function ax=plotticks(ticks)

tlt=tiledlayout(gcf,2,1);
tlt.Padding = "none";
tlt.TileSpacing = "none";
ax{1}=nexttile(tlt,[1 1]);
plot(ticks.Date,ticks.Price);

scale_min=min(ticks.Price);
scale_max=max(ticks.Price);
ylim([scale_min ,scale_max]);

ax{2}=nexttile(tlt,[1 1]);
plot(ticks.Date,ticks.Size);
linkaxes([ax{1} ax{2}],'x');
end

