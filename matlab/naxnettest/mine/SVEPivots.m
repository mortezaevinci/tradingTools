function pivots=SVEPivots(mc,mh,ml)

try
%monthly SVE pivots
%Pivot Point (PP) = (Daily High + Daily Low + Close) / 3
% R1 = (2 x Pivot Point) – Daily Low
% R2 = Pivot Point + (Daily High – Daily Low)
% S1 = (2 x Pivot Point) – Daily High
% S2 = Pivot Point – (Daily High – Daily Low)
% R3 = Daily High + 2 x (Pivot Point – Daily Low)
% S3 = Daily Low – 2 x (Daily High – Pivot Point)

pivots(5)=(mc+mh+ml)/3;
pivots(6)=2*pivots(5)-ml;
pivots(7)=pivots(5)+mh-ml;
pivots(8)=mh+2*(pivots(5)-ml);
pivots(4)=2*pivots(5)-mh;
pivots(3)=pivots(5)-(mh-ml);
pivots(2)=ml-2*(mh-pivots(5));
pivots(1)=pivots(5)+2*(ml-mh);
pivots(9)=pivots(5)+2*(mh-ml);
catch exception
getReport(exception,'extended','hyperlinks','off')
pivots=[];
end
end