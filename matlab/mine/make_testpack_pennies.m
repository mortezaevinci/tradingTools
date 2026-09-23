basedir='Z:\My files\Project trading\traderdata\data\';
processdir='Z:\My files\Project trading\traderdata\data_processed\testpack\';
        
%date

datatype='daily 1y';

dtt=datetime();
date='2020-12-21';
dbase=datetime(date);
datedate=dbase
    donesymbols='';
    if (isbusday(datedate))
        date=datestr(datedate,'yyyy-mm-dd');
        scnt=1;
      
        contracts_penniesm2_trade;
        make_testpack_addcontracts;
        %save
        fn=[processdir 'testpack pennies ' datatype ' ' date '.mat']; 
        save(fn,'testpack');
    end