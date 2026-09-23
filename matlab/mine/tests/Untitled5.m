si=5;

tt=mainticks{si}.params.TimeTables.Minute;

size(tt)

tt=updaterealtime(looperEngine,mainticks{si}.params,tt);

size(tt)