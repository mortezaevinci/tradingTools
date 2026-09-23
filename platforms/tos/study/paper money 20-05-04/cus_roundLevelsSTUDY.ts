def rval;


if (close < 10) {
    rval = 1;
} else if (close < 100) {
    rval = 5;
} else if (close < 200) {
    rval = 10;
}else if (close<500) {
rval=20;
} else {
rval=50;
}

def rd=roundDown(close*1.02/rval,0)*rval;
    def ru = RoundUp(close * .98 / rval, 0) * rval;

    plot prd = if (rd == rd[1]) then rd else Double.NaN;
    plot pru = if (ru == ru[1] ) then ru else Double.NaN;