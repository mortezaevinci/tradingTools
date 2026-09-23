input day_of_week = {Monday, Tuesday, Wednesday, Thursday, default Friday, Saturday, Sunday};
def date=GetYYYYMMDD();

def fridaydate=fold index=0 to 6 with p=date do (if (GetDayOfWeek(p)==day_of_week+1) then p else p+1);
def optiondate=20200522;#fridaydate;#fridaydate-20000000;

addlabel(1,optiondate);
addlabel(1,getsymbol());
addlabel(1,""+close(getATMOption(getunderlyingsymbol(),optiondate,optionclass.call)));

plot co=close(getATMOption(getsymbol(),optiondate,optionclass.call));

