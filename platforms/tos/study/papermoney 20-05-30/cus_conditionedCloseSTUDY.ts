input length = 15;

plot condtionedClose = if (close > 0) then high else low;

def marktestarted = (GetTime() - RegularTradingStart(GetYYYYMMDD())) / 1000 / 60; #ignore first 4 minutes

#def movinglength=min(marktestarted,length);

plot CCMA;


if (marktestarted<5) {
ccma=condtionedClose;
} else {
 ccma= Average(condtionedClose, length);
}