function thresh=default_threshold()

thresh.dcs.fight.min=1;
thresh.avs.min=1;
thresh.rvs.min=0.1; 
thresh.dvs.open.min=0.1;
thresh.dvs.close.min=0.1;
thresh.dvs.total.min=0.1;
thresh.dsma5.min=1/100*0.5;
thresh.dsma5settling.min=1/100*0;
thresh.ddsma5.min=1/100*0.5;


thresh.volumeBuzz.min=1;
thresh.volumeBuzz.max=5;

thresh.volumeBuzzBuySellDiff.min=.2;
thresh.volumeBuzzBuySellDiff.max=8;

thresh.dcs.fight.max=10;
thresh.avs.max=40;
thresh.rvs.max=3; 
thresh.dvs.open.max=50;
thresh.dvs.close.max=50;
thresh.dvs.total.max=50;
thresh.dsma5.max=1/100*25;
thresh.dsma5settling.max=1/100*5; %this could be cver by Bolinger bands as well
thresh.ddsma5.max=1/100*15;


thresh.ret_sma5.min=1/100*.075;
thresh.ret_sma5.max=1/100*2.5;

thresh.oversoldPercent.min=1/100*0;
thresh.oversoldPercent.max=1/100*50;
thresh.overboughtPercent.min=1/100*50;
thresh.overboughtPercent.max=1/100*100;

thresh.minNextLvlByPercent=1/100*4;
thresh.maxLastLvlByPercent=1/100*1;
thresh.maxTooCloseByPercent=1/100*0.25;

thresh.zerocrossing=0.01;


thresh.ShortTermPerformance.min=0.05;


     thresh.totalConditions.min=0.04;
    thresh.totalConditions.max=5;


thresh.futureGroundTruthHalfWindowSize_ShortTerm=10;
thresh.futureGroundTruthHalfWindowSize_MidTerm=30;
thresh.futureGroundTruthHalfWindowSize_LongTerm=60;

    thresh.totalIndicators.min=400;
     thresh.totalIndicators.max=1500;

 thresh.IndicatorsCount.min=30; %200
     thresh.IndicatorsCount.max=200; %500

end