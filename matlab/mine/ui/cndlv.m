function ax=cndlv(ttm)

tlt=tiledlayout(gcf,2,1);
tlt.Padding = "none";
tlt.TileSpacing = "none";
ax{1}=nexttile(tlt,[1 1]);
cndl5(ttm);

scale_min=min(ttm.Low);
scale_max=max(ttm.High);
ylim([scale_min ,scale_max]);

ax{2}=nexttile(tlt,[1 1]);
bar(ttm.Date,ttm.Volume);
linkaxes([ax{1} ax{2}],'x');
end

