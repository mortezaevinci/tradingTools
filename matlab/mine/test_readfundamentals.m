basedir='Z:\My files\Project trading\traderdata\fundamentals\';
symbol='AAPL';

AEF=[basedir 'analyst estimates ' symbol '.xml'];
AE=parseXML(AEF);
