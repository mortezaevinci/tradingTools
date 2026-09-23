def shooth=if (high==low) then 0 else (high-max(open,close))/(high-low);
def shootl=if (high==low) then 0 else (min(open,close)-low)/(high-low);
plot averageh=2*movingaverage(AverageType.Simple ,shooth,20);
plot averagel=2*movingaverage(AverageType.Simple ,shootl,20);
#plot Data = if (high==low) then 0 else volume*(1-(absvalue(close-open))/(high-low));
#plot averagedata=2*movingaverage(AverageType.Simple ,Data,20);

rec lastfighth=if (shooth>averageh and shooth[1]<averageh ) then (high) else (lastfighth[1]);
rec lastfightl=if (shootl>averagel and shootl[1]<averagel ) then (low) else (lastfightl[1]);
plot lfl=lastfightl;
plot lfh=lastfighth;

lfl.assignvaluecolor(color.dark_red);
lfh.assignvaluecolor(color.dark_green);
