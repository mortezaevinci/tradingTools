si=5;

tt=mainticks{si}.params.TimeTables.Minute;

size(tt)

tt=updaterealtime(mainticks{si}.params.symbol,tt);

size(tt)