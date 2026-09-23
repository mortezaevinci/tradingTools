def signalendofhigh = TTM_ScalperAlert().PivotHigh;
def signalendoflow = TTM_ScalperAlert().PivotLow;

AddOrder(OrderType.sell_TO_CLOSE, signalendofhigh, tickcolor = GetColor(1), arrowcolor = GetColor(1), name = "TTM HX");
AddOrder(OrderType.buy_TO_CLOSE, signalendoflow, tickcolor = GetColor(1), arrowcolor = GetColor(1), name = "TTM LX");