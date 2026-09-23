declare lower;
plot Data = close("$TICK");
Data.AssignValueColor(color.gray);

input alarmthresh=700;

plot th = alarmthresh;
plot thn = -alarmthresh;

th.AssignValueColor(Color.RED);
thn.AssignValueColor(Color.GREEN);

th.SetStyle(Curve.SHORT_DASH);
thn.SetStyle(Curve.SHORT_DASH);

plot th1 = 1000;
plot thn1 = -1000;

th1.AssignValueColor(Color.RED);
thn1.AssignValueColor(Color.GREEN);

plot overflow = Data > th or Data < thn;
overflow.SetPaintingStrategy(PaintingStrategy.BOOLEAN_POINTS);
overflow.AssignValueColor(Color.RED);
Alert(overflow, "TICK overflow", Alert.ONCE, Sound.Ring);