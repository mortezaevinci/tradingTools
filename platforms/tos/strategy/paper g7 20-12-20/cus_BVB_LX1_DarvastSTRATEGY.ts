#
# TD Ameritrade IP Company, Inc. (c) 2011-2020
#

def state = {default state_1, state_2, state_3, state_4, state_5};

def upper;
def lower;

def prevLower = CompoundValue(1, lower[1], low);
def prevUpper = CompoundValue(1, upper[1], high);

switch (state[1]) {
case state_1:
    lower = low;
    if (prevUpper >= high) {
        upper = high[1];
        state = state.state_2;
    } else {
        upper = high;
        state = state.state_1;
    }
case state_2:
    if (prevUpper >= high) {
        lower = low;
        upper = prevUpper;
        state = state.state_3;
    } else {
        lower = low;
        upper = high;
        state = state.state_1;
    }
case state_3:
    if (prevUpper < high) {
        lower = low;
        upper = high;
        state = state.state_1;
    } else if (prevLower > low) {
        lower = low;
        upper = prevUpper;
        state = state.state_3;
    } else {
        lower = prevLower;
        upper = prevUpper;
        state = state.state_4;
    }
case state_4:
    if (prevUpper < high) {
        lower = low;
        upper = high;
        state = state.state_1;
    } else if (prevLower > low) {
        lower = low;
        upper = prevUpper;
        state = state.state_3;
    } else {
        lower = prevLower;
        upper = prevUpper;
        state = state.state_5;
    }
case state_5:
    if (prevUpper < high) {
        lower = low;
        upper = high;
        state = state.state_1;
    } else if (prevLower > low) {
        lower = low;
        upper = high;
        state = state.state_1;
    } else {
        lower = prevLower;
        upper = prevUpper;
        state = state.state_5;
    }
}

def barNumber = BarNumber();
def barCount = HighestAll(If(IsNaN(close), 0, barNumber));
def boxNum;
def boxUpperIndex;


def BuySignal = CompoundValue(1, state[1] == state.state_5 and prevUpper < high, no);
def SellSignal = CompoundValue(1, state[1] == state.state_5 and prevLower > low, no);

if (IsNaN(close)) {
    boxNum = boxNum[1] + 1;
    boxUpperIndex = 0;

} else {
    boxNum = TotalSum(BuySignal or SellSignal);
    boxUpperIndex = fold indx = 0 to barCount - barNumber + 2 with valInd = Double.NaN
        while IsNaN(valInd)
        do if (GetValue(boxNum, -indx) != boxNum)
            then indx
            else Double.NaN;
}

def marktestarted = GetTime() > RegularTradingStart(GetYYYYMMDD());
def marketnotEnded = GetTime() < RegularTradingEnd(GetYYYYMMDD());
def marketTime = marktestarted and marketnotEnded;


input tradesize = 1;
AddOrder(OrderType.SELL_TO_CLOSE, BuySignal and marketTime, open[-1], tradesize, Color.GREEN, Color.GREEN);
AddOrder(OrderType.BUY_TO_CLOSE, sellsignal  and marketTime, open[-1], tradesize, Color.RED, Color.RED);