
input customRowHeight = 1.0;

input multiplier = 1;
input onExpansion = no;
input profiles = 1000;
input showPointOfControl = yes;
input showValueArea = yes;
input valueAreaPercent = 70;
input opacity = 0;

def period;
def yyyymmdd = getYyyyMmDd();
def seconds = secondsFromTime(0);
def month = getYear() * 12 + getMonth();
def day_number = daysFromDate(first(yyyymmdd)) + getDayOfWeek(first(yyyymmdd));
def dom = getDayOfMonth(yyyymmdd);
def dow = getDayOfWeek(yyyymmdd - dom + 1);
def expthismonth = (if dow > 5 then 27 else 20) - dow;
def exp_opt = month + (dom > expthismonth);

    period = floor(month - first(month));


def count = CompoundValue(1, if period != period[1] then (count[1] + period - period[1]) % multiplier else count[1], 0);
def cond = count < count[1] + period - period[1];
def  height = PricePerRow.AUTOMATIC;

profile vol = volumeProfile("startNewProfile" = cond, "onExpansion" = onExpansion, "numberOfProfiles" = profiles, "pricePerRow" = height, "value area percent" = valueAreaPercent);
def con = compoundValue(1, onExpansion, no);
def hVA = if IsNaN(vol.getHighestValueArea()) and con then hVA[1] else vol.getHighestValueArea();
def lVA = if IsNaN(vol.getLowestValueArea()) and con then lVA[1] else vol.getLowestValueArea();

plot VAHigh = hVA ;
plot VALow = lVA ;
