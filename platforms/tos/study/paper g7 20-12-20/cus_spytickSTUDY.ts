declare lower;
plot Data = close("$TIKSP");
Data.AssignValueColor(color.gray);

input alarmthresh=180;

plot th = alarmthresh;
plot thn = -alarmthresh;

th.AssignValueColor(Color.RED);
thn.AssignValueColor(Color.GREEN);

th.SetStyle(Curve.SHORT_DASH);
thn.SetStyle(Curve.SHORT_DASH);

plot th1 = 250;
plot thn1 = -250;

th1.AssignValueColor(Color.RED);
thn1.AssignValueColor(Color.GREEN);

plot overflow = Data > th ;
overflow.SetPaintingStrategy(PaintingStrategy.BOOLEAN_POINTS);
overflow.AssignValueColor(Color.RED);

plot overflowg =  Data < thn;
overflowg.SetPaintingStrategy(PaintingStrategy.BOOLEAN_POINTS);
overflowg.AssignValueColor(Color.GREEN);