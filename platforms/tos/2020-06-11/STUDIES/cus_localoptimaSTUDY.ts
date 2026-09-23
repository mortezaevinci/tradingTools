def newdaygap = GetDay() <> getday()[5];
rec rdh = if newdaygap then 0 else max(rdh[1],high[5]);

plot dh = rdh;
rec rdl = if newdaygap then 100000 else min(rdl[1],low[5]);
plot dl=rdl;

dh.setpaintingstrategy(paintingStrategy.DASHES);
dl.setpaintingstrategy(paintingStrategy.DASHES);