%%volume profile test
function n=volumeprofile(TimeTables.Minute)
n=0;
try
[ha,hb]=histcounts(TimeTables.Minute.Close,250);
 bah=barh(hb(1:end-1),ha);
 
 %alpha(bah,0);
 %bah.EdgeColor='b';
 catch exception
dumpReport('error.log', exception)
end
end