%%volume profile test
function n=volumeprofile(TimeTables.Minute,barhandle)
n=0;
try
[ha,hb]=histcounts(TimeTables.Minute.Close,250);
if (nargin()==1)
 bah=barh(hb(1:end-1),ha);
else
     set(barhandle, 'XData', hb(1:end-1), 'YData',ha);
end

catch exception
dumpReport('error.log', exception)
end
end