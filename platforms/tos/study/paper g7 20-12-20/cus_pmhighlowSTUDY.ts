#pm_high_low


input alertPeriodStart = 930;
input alertPeriodEnd = 1130;
input alertOnBreak = no;
input alertOnPullBack = no;
input numberOfDays = 2;
input numberOfYears = 0;


def okToPlot = GetLastDay() - numberOfDays <= GetDay() and GetLastYear() - numberOfYears <= GetYear() ;

def startCounter =  SecondsFromTime(alertPeriodStart);
def endCounter = SecondsTillTime(alertPeriodEnd);

def alertPeriod = if startCounter >= 0 and endCounter >= 0 then 1 else 0;

def regularSessionHours = RegularTradingStart(GetYYYYMMDD()) <= GetTime();
def extendedSessionHours = RegularTradingStart(GetYYYYMMDD()) >= GetTime();

def extendedSessionStart = regularSessionHours[1] and extendedSessionHours;
def regularSessionStart = extendedSessionHours[1] and regularSessionHours;

def extendedSessionHigh = CompoundValue(1, if extendedSessionStart then high else if extendedSessionHours then Max(high, extendedSessionHigh[1]) else extendedSessionHigh[1], high);

def extendedSessionLow = CompoundValue(1, if extendedSessionStart then low else if extendedSessionHours then Min(low, extendedSessionLow[1]) else extendedSessionLow[1],low);

def regularSessionHigh = CompoundValue(1, if regularSessionStart then high else if regularSessionHours then Max(high, regularSessionHigh[1]) else regularSessionHigh[1], 0);

def regularSessionLow = CompoundValue(1, if regularSessionStart then low else if regularSessionHours then Min(low, regularSessionLow[1]) else regularSessionLow[1], 0);


#---------- Plot the overnight high/low during regular market hours
plot overnightHigh =  extendedSessionHigh;
overnightHigh.SetDefaultColor(Color.red);
overnightHigh.SetLineWeight(2);
overnightHigh.SetPaintingStrategy(PaintingStrategy.line);
overnightHigh.SetStyle(curve.firm);
plot overnightLow = extendedSessionLow;
overnightLow.SetDefaultColor(Color.green);
overnightLow.SetLineWeight(2);
overnightLow.SetPaintingStrategy(PaintingStrategy.line);
overnightLow.SetStyle(curve.firm);