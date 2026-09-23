si=1;



arraymeasures=[mainticks{si}.calculations.up.final mainticks{si}.calculations.dn.final mainticks{si}.calculations.dcs{1}.fight,mainticks{si}.calculations.dcs{2}.fight,mainticks{si}.calculations.avs{1},mainticks{si}.calculations.avs{2},mainticks{si}.calculations.rvs{1},mainticks{si}.calculations.rvs{2},mainticks{si}.calculations.dsma5,mainticks{si}.calculations.ddsma5,mainticks{si}.calculations.dvs{1}.close,mainticks{si}.calculations.dvs{2}.close,mainticks{si}.calculations.dvs{1}.open,mainticks{si}.calculations.dvs{2}.open,mainticks{si}.calculations.dvs{1}.total,mainticks{si}.calculations.dvs{2}.total]
amb=arraymeasures;
amb(mainticks{si}.calculations.pbto==0,:)=[];

ams=arraymeasures;
ams(mainticks{si}.calculations.psto==0,:)=[];


disp('[up mode, dn mode]:dcs.fight dcs.fight (5)avs avs rcs rcs, (9)dsma5, ddsma5, (11)dvs.close, dvs.close, (13)open, open, (15)total, totsl');
amb

ams