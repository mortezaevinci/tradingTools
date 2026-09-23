function []=optmizeAxes(axes)

setappdata(axes,'LegendColorbarManualSpace',1);
setappdata(axes,'LegendColorbarReclaimSpace',1);

axes.Interactions = [zoomInteraction regionZoomInteraction rulerPanInteraction];
axes.Toolbar=[];

end