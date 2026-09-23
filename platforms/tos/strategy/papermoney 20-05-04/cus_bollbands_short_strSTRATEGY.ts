##Nick Radge Bollinger Band Breakout Strat short version
##
##Basic Strategy used on a Daily, Weekly timeframe.
# 1) Bollinger bands Period 100 days
# 2) Boll bands set to 1 standard deviation
# 3) Buy on the open day after the signal
# 4) Bottom Bollinger band set to -2 stdv
# 6) Sell when price closes above the top band on the following day
# 7) Use a regime filter to gague the overall market sentimate
# 8) Gaged by the 200day MA on then index that you can select from the drop down.  SPX is default.
# 9) 3.5 ATR trailing stop on by defult adjust according to your strategy.

input roc = 20;
input bbPeriod = 100;
input bbUpper = 1;
input bbLower = -2;
input bbAvg = AverageType.SIMPLE;
input market = {default SPX, NDX, RUT, DJX};


## Indicator
def bbBreakUp = close crosses above BollingerBands(close, length = bbPeriod, "num dev up" = bbUpper, "average type" = bbAvg, "num dev dn" = bbLower).UpperBand;
def bbBreakDown = close crosses below BollingerBands(price = open, length = bbPeriod, "num dev dn" = bbLower, "num dev up" = bbUpper, "average type" = bbAvg).LowerBand;
def bbShortUp = close crosses above BollingerBands(close, length = bbPeriod, "num dev up" = bbUpper, "average type" = bbAvg, "num dev dn" = bbLower).LowerBand;

## Regime Filter
#Is the market this stock is apart of above the 200 day MA

def RF = SimpleMovingAvg(close(symbol = market), length = 200);

def marClose = close(market);
AddLabel(1, Concat("Index: ", Concat(market, Concat(" " + marClose, " 200SMA= " + RF))), if marClose > RF
  then Color.GREEN
  else Color.RED);

## Confirmation rate of change
def rate = RateOfChange(roc);

########################################################################
## Trailing Stop

input trailType = {default modified, unmodified};
input ATRPeriod = 5;
input ATRFactor = 3.5;
input firstTrade = {default short, long};

Assert(ATRFactor > 0, "'atr factor' must be positive: " + ATRFactor);

def HiLo = Min(high - low, 1.5 * Average(high - low, ATRPeriod));
def HRef = if low <= high[1]
  then high - close[1]
  else (high - close[1]) - 0.5 * (low - high[1]);
def LRef = if high >= low[1]
  then close[1] - low
  else (close[1] - low) - 0.5 * (low[1] - high);
def ATRMod = ExpAverage(Max(HiLo, Max(HRef, LRef)), 2 * ATRPeriod - 1);
def loss;
switch (trailType) {
case modified:
    loss = ATRFactor * ATRMod;
case unmodified:
    loss = ATRFactor * Average(TrueRange(high,  close,  low),  ATRPeriod);
}

def state = {default init, long, short};
def trail;

switch (state[1]) {
case init:
    if (!IsNaN(loss)) {
        switch (firstTrade) {
        case long:
            state = state.long;
            trail =  close - loss;
        case short:
            state = state.short;
            trail = close + loss;
    }
    } else {
        state = state.init;
        trail = Double.NaN;
    }
case long:
    if (close > trail[1]) {
        state = state.long;
        trail = Max(trail[1], close - loss);
    } else {
        state = state.short;
        trail = close + loss;
    }
case short:
    if (close < trail[1]) {
        state = state.short;
        trail = Min(trail[1], close + loss);
    } else {
        state = state.long;
        trail =  close - loss;
    }
}

plot TrailingStop = trail;
TrailingStop.SetPaintingStrategy(PaintingStrategy.POINTS);
TrailingStop.DefineColor("Buy", GetColor(0));
TrailingStop.DefineColor("Sell", GetColor(1));
TrailingStop.AssignValueColor(if state == state.long
  then TrailingStop.Color("Sell")
  else TrailingStop.Color("Buy"));

plot cross = close crosses TrailingStop;
cross.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
#end


###Plots###
plot upper = BollingerBands(close, length = bbPeriod, "num dev up" = bbUpper, "average type" = bbAvg, "num dev dn" = bbLower).UpperBand;
plot lower = BollingerBands(close, length = bbPeriod, "num dev up" = bbLower, "average type" = bbAvg, "num dev dn" = bbLower).LowerBand;
plot buySignal = bbBreakUp;
buySignal.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);
buySignal.SetLineWeight(2);
buySignal.SetDefaultColor(Color.GREEN);
plot sellSignal = bbBreakDown and rate < 10 and marClose < RF;
sellSignal.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_DOWN);
sellSignal.SetLineWeight(2);
sellSignal.SetDefaultColor(Color.RED);

AddOrder(condition = bbBreakUp, type = OrderType.BUY_TO_CLOSE, price = open, name = "bbBreak_SX",tradesize=1);
AddOrder(condition = bbBreakDown, type = OrderType.SELL_TO_OPEN, price = open, name = "bbBreak_SE",tradesize=1);
AddOrder(condition = cross, type = OrderType.BUY_TO_CLOSE, price = open, name = "TrailStop",tradesize=1);