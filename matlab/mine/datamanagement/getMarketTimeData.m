function [tm,jm]=getMarketTimeData(tmfull)
tm=[];
jm=[];
if(~isempty(tmfull))
%startmarkettime =(datetime([datestring ' 9:30:00']));
%endmarkettime =(datetime([datestring ' 16:00:00']));

tmfulltime=tmfull.Date.Hour+tmfull.Date.Minute/60;
  
    inds=find(tmfulltime>=9.5 & tmfulltime<16);
    tm=tmfull(inds,:);
end
end