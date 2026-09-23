input tradeSize = 1;

def enter = TTM_ScalperAlert(0)."PivotLow" is true;
def exit=TTM_ScalperAlert(0)."PivotHigh" is true;


AddOrder(OrderType.BUY_TO_OPEN, enter, open[-1], tradeSize, Color.GREEN, Color.GREEN,"@"+ open[-1]);

AddOrder(OrderType.SELL_TO_CLOSE, exit, open[-1], tradeSize, Color.RED, Color.RED, "@ " +open[-1]);