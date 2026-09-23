basedir='Z:\My files\Project trading\traderdata\data\';
processdir='Z:\My files\Project trading\traderdata\data_processed\testpack\';
        
%date

datatype='daily 1y';

dtt=datetime();
date='2020-12-11';
dbase=datetime(date);
datedate=dbase
    donesymbols='';
    if (isbusday(datedate))
        date=datestr(datedate,'yyyy-mm-dd');
        scnt=1;
      
        contracts_nasdaq;
        make_testpack_addcontracts;
        
        contracts_yahoo;
        make_testpack_addcontracts;
        
        contracts_ib;
        make_testpack_addcontracts;
        
        contracts_TDA;
        make_testpack_addcontracts;
        %save
        fn=[processdir 'testpack ' datatype ' ' date '.mat']; 
        save(fn,'testpack');
    end