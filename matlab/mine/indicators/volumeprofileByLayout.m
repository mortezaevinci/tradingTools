%%volume profile test
function n=volumeprofile(TimeTables.Minute,barhandle)
n=0;
[ha,hb]=histcounts(TimeTables.Minute.Close,250);
 bah=barh(hb(1:end-1),ha);
 
 %alpha(bah,0);
 %bah.EdgeColor='b';
 
end