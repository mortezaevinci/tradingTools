input high = 0;
input low = 0;

plot hp = if (high>0) then high else double.nan;
plot lp = if (low>0) then low else double.nan;




hp.SetDefaultColor(Color.Gray);
hp.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);

lp.SetDefaultColor(Color.Gray);
lp.SetPaintingStrategy(PaintingStrategy.HORIZONTAL);