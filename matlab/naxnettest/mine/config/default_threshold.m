function thresh=default_threshold()

thresh.dcs.fight.min=1.1;
thresh.avs.min=2;
thresh.rvs.min=0.3; 
thresh.dvs.open.min=0.3;
thresh.dvs.close.min=0.2;
thresh.dvs.total.min=0.2;
thresh.dsma5.min=0.03;
thresh.dsma5settling.min=0;
thresh.ddsma5.min=0.02;

thresh.dcs.fight.max=10;
thresh.avs.max=40;
thresh.rvs.max=3; 
thresh.dvs.open.max=50;
thresh.dvs.close.max=50;
thresh.dvs.total.max=50;
thresh.dsma5.max=5;
thresh.dsma5settling.max=2;
thresh.ddsma5.max=5;

thresh.minNextLvlByPercent=0.05;

end