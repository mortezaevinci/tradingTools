%%volume profile test

[ha,hb]=histcounts(TimeTables.Minute.Close,100);
 bah=barh(hb(1:end-1),ha);
 
 alpha(bah,0);
 bah.EdgeColor='b';