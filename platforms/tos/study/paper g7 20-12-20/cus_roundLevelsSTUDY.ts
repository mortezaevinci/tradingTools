def rval;
def rval2;

if (close < 20) {
    rval = 1;
rval2=0.5;
} else if (close < 100) {
    rval = 5;
rval2=1;
} else if (close < 500) {
    rval = 10;
    rval2=5;
}else if (close<1000) {
rval=20;
rval2=10;
} else {
rval=50;
rval2=10;
}

def rval3=1;

def rd=roundDown(close*1.005/rval,0)*rval;
    def ru = RoundUp(close * .995 / rval, 0) * rval;

    plot prd = if (rd == rd[1]) then rd else Double.NaN;
    plot pru = if (ru == ru[1] ) then ru else Double.NaN;




def rd2=roundDown(close*1.005/rval2,0)*rval2;
    def ru2 = RoundUp(close * .995 / rval2, 0) * rval2;

    plot prd2 = if (rd2 == rd2[1]) then rd2 else Double.NaN;
    plot pru2 = if (ru2 == ru2[1] ) then ru2 else Double.NaN;

def rd3=roundDown(close*1.005/rval3,0)*rval3;
    def ru3 = RoundUp(close * .995 / rval3, 0) * rval3;

    plot prd3 = if (rd3 == rd3[1]) then rd3 else Double.NaN;
    plot pru3 = if (ru3 == ru3[1] ) then ru3 else Double.NaN;

prd.assignvalueColor(color.white);
pru.assignvalueColor(color.white);
prd2.assignvalueColor(color.white);
pru2.assignvalueColor(color.white);
prd3.assignvalueColor(color.white);
pru3.assignvalueColor(color.white);

prd2.setStyle(curve.MEDIUM_DASH);
pru2.setStyle(curve.MEDIUM_DASH);


prd3.setStyle(curve.short_DASH);
pru3.setStyle(curve.short_DASH);