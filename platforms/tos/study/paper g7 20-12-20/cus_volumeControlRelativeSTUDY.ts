declare lower;
def pchange = (close - open) / open;
def pchangevol = pchange * volume;


plot pcvtol = TotalSum(pchangevol);