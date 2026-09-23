close all

 global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY parf;

%looperparams_realtimeD;
%run('config\looperparams_nn_t9_ID3.m');
run('config\looperparams_nn_t9_ID3_offline_allsymbols.m');
%looperEngine.contracts={genContract([],'COMP')};
%looperEngine.contracts={genContract([],'AAPL')};

% looperEngine.contracts={...
% genContract([],'AAL'),...
% genContract([],'AAPL'),...
% genContract([],'AMD'),...
% genContract([],'AMZN'),...
% genContract([],'BAC'),...
% genContract([],'BA'),...
% genContract([],'TSLA'),...
% genContract([],'BYND'),...
% genContract([],'WMT'),...
% genContract([],'SHOP'),...
% genContract([],'MSFT','MSFT','STK','SMART','NASDAQ'),...
% genContract([],'NVDA'),...
% genContract([],'NFLX'),...
% genContract([],'DIS'),...
% genContract([],'FB'),...
% genContract([],'SPY'),...
% genContract([],'GLD'),...
% genContract([],'SLV'),...
% genContract([],'$TICK'),...
% genContract([],'$VOLD')...
% };

commonticks={};
%main params
run('config\mainparams_backtest_test_t9_STUDY_ID3.m');

patternrec_prepare_t7;

crumb=[];
rq=[];

ntdates_c=0; %% counting the days that worked
ntdates_i=0; %% counting the days that worked
% xxxmor, for last 60 days

numberofdays=90;


 for si=1:ncontracts
initprofile=1;

if (strcmp(looperEngine.contracts{si}.SecType,'IND') || strcmp(looperEngine.contracts{si}.SecType,'FUT'))
continue;
end


  for ds=0:numberofdays
      
 try
 looperEngine.date=datestr(datetime()-days(ds),'yyyy-mm-dd');
 
 if (isbusday(looperEngine.date))
 
     performanceMatrixP1=struct();
     
 looperEngine.dateMinutesNextDay=datetime( looperEngine.date)+days(1);
  disp(looperEngine.date);
 
   
        for csi=1:ncommon
   
     disp(['init ' commonticks{csi}.params.contract.Symbol '...']);
    
if (looperEngine.data.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperEngine,commonticks{csi}.params,rq,crumb,0,0);
end
    
    commonticks{csi}.params=strategy_getdata(looperEngine,commonticks{csi}.params);
 commonticks{csi}.params=loadprofile_PAPP1(commonticks{csi}.params,looperEngine);
end

 %% evaluate commonticks
 %%tic
   %;disp('eval commonticks');
    for si2=1:ncommon
        
        commonticks{si2}.params=strategy_getdata(looperEngine,commonticks{si2}.params);
        %commonticks{si2}.params=loadprofile_PAPP1(commonticks{si2}.params,looperEngine);
 [commonticks{si}.calculations,commonticks{si}.debug_daily]=strategy_dailytrend_t10(looperEngine,commonticks{si}.params,[]);
commonticks{si2}=strategy_breakout_t10(looperEngine,commonticks{si2},[]);
    end
 %%ticbcommon=toc
 
      disp(['init ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) '...']);
    
if (looperEngine.data.getdatainit==1)
   [rq,c]=getdata_yahoo_func(looperEngine,mainticks{si}.params,rq,crumb,0,0);
end
 
  [mainticks{si}.params,success]=strategy_getdata(looperEngine,mainticks{si}.params);
  if (success==0)
      continue;
  end
%mainticks{si}.params=loadprofile_PAPP1(mainticks{si}.params,looperEngine);

[mainticks{si}.calculations,mainticks{si}.debug_daily]=strategy_dailytrend_t10(looperEngine,mainticks{si}.params,commonticks);
[mainticks{si},debug]=strategy_breakout_t10(looperEngine,mainticks{si},commonticks);
mainticks{si}.debug=debug;
if (mainticks{si}.calculations.finished)

if (initprofile==1)
initprofile=0;
vsize=size(mainticks{si}.debug.AllConditions,2);
performanceMatrix{si}.conditions.test=zeros(2,size(vsize,2));
performanceMatrix{si}.conditions.trend=zeros(2,size(vsize,2));
performanceMatrix{si}.conditions.testiftrend=zeros(2,size(vsize,2));
performanceMatrix{si}.conditions.trendiftest=zeros(2,size(vsize,2));
performanceMatrix{si}.conditions.testandtrend=zeros(2,size(vsize,2));
vsize=table2array(mainticks{si}.calculations.indicators{1}.lower);
performanceMatrix{si}.indicators.test=zeros(2,size(vsize,2));
performanceMatrix{si}.indicators.trend=zeros(2,size(vsize,2));
performanceMatrix{si}.indicators.testiftrend=zeros(2,size(vsize,2));
performanceMatrix{si}.indicators.trendiftest=zeros(2,size(vsize,2));
performanceMatrix{si}.indicators.testandtrend=zeros(2,size(vsize,2));

algoreturn{si}=1;
end


performanceMatrixP1.conditions=evaluateConditions(mainticks{si}.params,mainticks{si}.calculations,mainticks{si}.debug);
performanceMatrix{si}.conditions.test=performanceMatrix{si}.conditions.test+performanceMatrixP1.conditions.test;
performanceMatrix{si}.conditions.trend=performanceMatrix{si}.conditions.trend+performanceMatrixP1.conditions.trend;
performanceMatrix{si}.conditions.testiftrend=performanceMatrix{si}.conditions.testiftrend+performanceMatrixP1.conditions.testiftrend;
performanceMatrix{si}.conditions.trendiftest=performanceMatrix{si}.conditions.trendiftest+performanceMatrixP1.conditions.trendiftest;
performanceMatrix{si}.conditions.testandtrend=performanceMatrix{si}.conditions.testandtrend+performanceMatrixP1.conditions.testandtrend;
ntdates_c=ntdates_c+1;

performanceMatrixP1.indicators=evaluateIndicators(mainticks{si}.params,mainticks{si}.calculations);
performanceMatrix{si}.indicators.test=performanceMatrix{si}.indicators.test+performanceMatrixP1.indicators.test;
performanceMatrix{si}.indicators.trend=performanceMatrix{si}.indicators.trend+performanceMatrixP1.indicators.trend;
performanceMatrix{si}.indicators.testiftrend=performanceMatrix{si}.indicators.testiftrend+performanceMatrixP1.indicators.testiftrend;
performanceMatrix{si}.indicators.trendiftest=performanceMatrix{si}.indicators.trendiftest+performanceMatrixP1.indicators.trendiftest;
performanceMatrix{si}.indicators.testandtrend=performanceMatrix{si}.indicators.testandtrend+performanceMatrixP1.indicators.testandtrend;
ntdates_i=ntdates_i+1;

    filename=['Z:\My files\Project trading\traderdata\data_processed\indicatorprofile\PMATP1 ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) ' ID' num2str(looperEngine.performance.setupId) ' ' looperEngine.date '.mat'];
    save(filename,'performanceMatrixP1');

end

end
catch exception
   dumpReport('error.log', exception) 
end
  
  end
  
  % if possible process and save performance matrix
  try
  
 disp(['performance matrix of conditions for ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol)]); 
   performanceMatrix{si}.conditions.test=performanceMatrix{si}.conditions.test/ntdates_c;
   performanceMatrix{si}.conditions.trend=performanceMatrix{si}.conditions.trend/ntdates_c;
   performanceMatrix{si}.conditions.testiftrend=performanceMatrix{si}.conditions.testiftrend/ntdates_c;
   performanceMatrix{si}.conditions.trendiftest=performanceMatrix{si}.conditions.trendiftest/ntdates_c;
   performanceMatrix{si}.conditions.testandtrend=performanceMatrix{si}.conditions.testandtrend/ntdates_c;

%rateskew=sum(performanceMatrix{si}.conditionsTotal(1,:))/sum(performanceMatrix{si}.conditionsTotal(2,:));
%performanceMatrix{si}.conditionsTotal(1,:)=performanceMatrix{si}.conditionsTotal(1,:)./rateskew;

dispPerformanceMatrix(mainticks{si}.debug,performanceMatrix{si}.conditions);


  performanceMatrix{si}.indicators.test=performanceMatrix{si}.indicators.test/ntdates_i;
   performanceMatrix{si}.indicators.trend=performanceMatrix{si}.indicators.trend/ntdates_i;
   performanceMatrix{si}.indicators.testiftrend=performanceMatrix{si}.indicators.testiftrend/ntdates_i;
   performanceMatrix{si}.indicators.trendiftest=performanceMatrix{si}.indicators.trendiftest/ntdates_i;
   performanceMatrix{si}.indicators.testandtrend=performanceMatrix{si}.indicators.testandtrend/ntdates_i;

dispPerformanceMatrix_indicatorsAverage(mainticks{si}.calculations,performanceMatrix{si}.indicators);

performanceMatrix{si}.indicatorsProfile.mean=(performanceMatrix{si}.indicators.trendiftest(1,:)+performanceMatrix{si}.indicators.trendiftest(2,:))/2;
performanceMatrix{si}.indicatorsProfile.range=1./((performanceMatrix{si}.indicators.trendiftest(1,:)-performanceMatrix{si}.indicators.trendiftest(2,:))/2);


excludeindexes=[14,15,16,17,18,19,20,27,28,91,92,94,98:107];
performanceMatrix{si}.indicatorsProfile=fixpconditionbased(performanceMatrix{si}.indicatorsProfile,excludeindexes);

    performanceMatrixP1=performanceMatrix{si};

    filename=['Z:\My files\Project trading\traderdata\data_processed\indicatorprofile\PMATP1 ' filefriendlysymbol(mainticks{si}.params.contract.FileSymbol) ' ID' num2str(looperEngine.performance.setupId) '.mat'];

    save(filename,'performanceMatrixP1');
catch exception
   dumpReport('error.log', exception) 
end
  
 end 
  
performancematrixall.conditions.test=zeros(size(performanceMatrix{1}.conditions.test));
performancematrixall.conditions.trend=zeros(size(performanceMatrix{1}.conditions.trend));
performancematrixall.conditions.testiftrend=zeros(size(performanceMatrix{1}.conditions.testiftrend));
performancematrixall.conditions.trendiftest=zeros(size(performanceMatrix{1}.conditions.trendiftest));
performancematrixall.conditions.testandtrend=zeros(size(performanceMatrix{1}.conditions.testandtrend));
 for si=1:ncontracts
performancematrixall.conditions.test=performancematrixall.conditions.test+performanceMatrix{si}.conditions.test;
performancematrixall.conditions.trend=performancematrixall.conditions.test+performanceMatrix{si}.conditions.trend;
performancematrixall.conditions.testiftrend=performancematrixall.conditions.test+performanceMatrix{si}.conditions.testiftrend;
performancematrixall.conditions.trendiftest=performancematrixall.conditions.test+performanceMatrix{si}.conditions.trendiftest;
performancematrixall.conditions.testandtrend=performancematrixall.conditions.test+performanceMatrix{si}.conditions.testandtrend;
 end
performancematrixall.conditions.test=performancematrixall.conditions.test/ncontracts;
performancematrixall.conditions.trend=performancematrixall.conditions.trend/ncontracts;
performancematrixall.conditions.testiftrend=performancematrixall.conditions.testiftrend/ncontracts;
performancematrixall.conditions.trendiftest=performancematrixall.conditions.trendiftest/ncontracts;
performancematrixall.conditions.testandtrend=performancematrixall.conditions.testandtrend/ncontracts;
 disp(['performance matrix of conditions for all averaged']); 
  dispPerformanceMatrix(mainticks{1}.debug,performancematrixall.conditions);

 
performancematrixall.indicators.test=zeros(size(performanceMatrix{1}.indicators.test));
performancematrixall.indicators.trend=zeros(size(performanceMatrix{1}.indicators.trend));
performancematrixall.indicators.testiftrend=zeros(size(performanceMatrix{1}.indicators.testiftrend));
performancematrixall.indicators.trendiftest=zeros(size(performanceMatrix{1}.indicators.trendiftest));
performancematrixall.indicators.testandtrend=zeros(size(performanceMatrix{1}.indicators.testandtrend));
 for si=1:ncontracts
performancematrixall.indicators.test=performancematrixall.indicators.test+performanceMatrix{si}.indicators.test;
performancematrixall.indicators.trend=performancematrixall.indicators.test+performanceMatrix{si}.indicators.trend;
performancematrixall.indicators.testiftrend=performancematrixall.indicators.test+performanceMatrix{si}.indicators.testiftrend;
performancematrixall.indicators.trendiftest=performancematrixall.indicators.test+performanceMatrix{si}.indicators.trendiftest;
performancematrixall.indicators.testandtrend=performancematrixall.indicators.test+performanceMatrix{si}.indicators.testandtrend;
 end
performancematrixall.indicators.test=performancematrixall.indicators.test/ncontracts;
performancematrixall.indicators.trend=performancematrixall.indicators.trend/ncontracts;
performancematrixall.indicators.testiftrend=performancematrixall.indicators.testiftrend/ncontracts;
performancematrixall.indicators.trendiftest=performancematrixall.indicators.trendiftest/ncontracts;
performancematrixall.indicators.testandtrend=performancematrixall.indicators.testandtrend/ncontracts;
 disp(['performance matrix of indicators  for all averaged']); 
  dispPerformanceMatrix_indicatorsAverage(mainticks{1}.calculations,performancematrixall.indicators);
 
  for si=1:ncontracts
     disp(['total algo return of ' looperEngine.contracts{si}.Symbol '='  num2str(algoreturn{si})]);
 end
 