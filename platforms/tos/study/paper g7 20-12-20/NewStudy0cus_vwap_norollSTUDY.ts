
input yyymmdd=210000;

def volumeSum;
def volumeVwapSum;
def volumeVwap2Sum;

def yyyyMmDd = getYyyyMmDd();
def periodIndx;

    periodIndx = roundDown(yyyyMmDd /yyymmdd, 0);

def isPeriodRolled = compoundValue(1, periodIndx != periodIndx[1], yes);

if (isPeriodRolled) {
    volumeSum = volume;
volumeVwapSum = volume * vwap;
volumeVwap2Sum = volume * Sqr(vwap);
} else {
    volumeSum = compoundValue(1, volumeSum[1] + volume, volume);
volumeVwapSum = CompoundValue(1, volumeVwapSum[1] + volume * vwap, volume * vwap);
volumeVwap2Sum = CompoundValue(1, volumeVwap2Sum[1] + volume * Sqr(vwap), volume * Sqr(vwap));
}
def price = volumeVwapSum / volumeSum;
def deviation = Sqrt(Max(volumeVwap2Sum / volumeSum - Sqr(price), 0));

plot VWAP = price;

VWAP.SetDefaultColor(GetColor(4));