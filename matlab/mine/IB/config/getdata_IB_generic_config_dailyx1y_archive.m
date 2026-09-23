basedir='Z:\My files\Project trading\traderdata\data_other\IB\';
baseclientid=1180;

setupname='dailyx1y_archive';

contracts_penniesm2;c1=contracts;
contracts_ib;c2=contracts;
contracts={c1{:},c2{:}};
contracts=uniqueContracts(contracts,'FileSymbol');

%ibcontractmanager.DataProvider.Historical={'ib'};
%ibcontractmanager.DataProvider.RealTime={'ib'};
% contracts={genContract(ibcontractmanager,'AAPL')};

port=[4002 4004 7497];
operation = 0; % 0=hisotrical data, 1=historical ticks accumulate day
    duration = "1 Y"; % //S,D,W,M,Y
    barsize = "1 day";
    keepuptodate = false;
    whattoshow="TRADES";
    
    RTHonly=0; % during market time
    
    dateslist=[...
        datetime('2007-12-28'),datetime('2007-12-31'),...
        datetime('2008-12-28'),datetime('2008-12-31'),...
        datetime('2009-12-28'),datetime('2009-12-31'),...
        datetime('2010-12-28'),datetime('2010-12-31'),...
        datetime('2011-12-28'),datetime('2011-12-31'),...
        datetime('2012-12-28'),datetime('2012-12-31'),...
        datetime('2013-12-28'),datetime('2013-12-31'),...
        datetime('2014-12-28'),datetime('2014-12-31'),...
        datetime('2015-12-28'),datetime('2015-12-31'),...
        datetime('2016-12-28'),datetime('2016-12-31'),...
        datetime('2017-12-28'),datetime('2017-12-31'),...
        datetime('2018-12-28'),datetime('2018-12-31'),...
        datetime('2019-12-28'),datetime('2019-12-31'),...
        datetime('2020-12-28'),datetime('2020-12-31'),...
    ];

    fndataid='dailyx1y';
    timetablename={'td'};

    errorTimeout=10;
    intrpTimeout=3;
    
        shutdownddt0=3;
    shutdownddt1=3.5; %to not shutdown, make dd1 smaller than dd0
    
    maxRequestPerConnection=48;