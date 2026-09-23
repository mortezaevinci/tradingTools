function pp =findw(tm,calculations)
try
    
pp.gx=[];
pp.gy=[];

pp.rx=[];
pp.ry=[];
    
for pli=1:numel(calculations.localOptimaProfile)



th=calculations.atr(end)/10;

lo=[calculations.localOptimaProfile{pli}.localoptima{1},calculations.localOptimaProfile{pli}.localoptima{2}];
lo=reshape(lo',[numel(lo),1]);
dir=[ones(size(calculations.localOptimaProfile{pli}.localoptima{1})),zeros(size(calculations.localOptimaProfile{pli}.localoptima{2}))];
dir=reshape(dir',[numel(dir),1]);
ind=[(1:numel(calculations.localOptimaProfile{pli}.localoptima{1}))',(1:numel(calculations.localOptimaProfile{pli}.localoptima{2}))'];
ind=reshape(ind',[numel(ind),1]);

havelo=find(lo>0);
lo=lo(havelo);
dir=dir(havelo);
ind=ind(havelo);

%hasw=findsignal(dir,[1 0 1],'MaxNumSegments',20,'Metric','absolute');
hasw = strfind(dir',[1 0 1]);

for i=1:numel(hasw)

 hasw1=hasw(i);
 wn1=ind(hasw1);
 wn2=ind(hasw1+2);
 wnm=ind(hasw1+1);
 wdistance=wn2-wn1;
 minindfirst=max(1,wn1-wdistance);
 maxfirst=max(tm.High(minindfirst:wn1));
maxindlast=min(wn2+wdistance,numel(tm.Date));
maxlast=max(tm.High(wn2:maxindlast));

 wl1=tm.Low(wn1);
 wl2=tm.Low(wn2);
 whm=tm.High(wnm);
 wm=(wl2-wl1)/(wn2-wn1);
 wb=wl1-wm*wn1;
 wbm=whm-wm*wnm;
 %conditions

 wup4=whm>wl1+th  & whm>wl2+th;
 wup1=wl1<wl2;
 wup2=maxfirst>whm;% this has to be based on wm,wb instead
 wup3=maxlast>whm; % this has to be based on wm,wb instead
 %wup3 is only for detection , not for plotting
 
 wup=wup1&wup2&wup4;
 
 if (wup)
    %plot([tm.Date(wn1) tm.Date(wn2)],[wm*wn1+wb wm*wn2+wb],'g');
    % plot([tm.Date(wn1) tm.Date(maxindlast)],[wm*wn1+wbm wm*maxindlast+wbm],'r');
    pp.gx=[pp.gx tm.Date(wn1) tm.Date(wn2) tm.Date(wn2)];
    pp.gy=[pp.gy wm*wn1+wb wm*wn2+wb nan];
    pp.rx=[pp.rx tm.Date(wn1) tm.Date(maxindlast) tm.Date(maxindlast)];
    pp.ry=[pp.ry wm*wn1+wbm wm*maxindlast+wbm nan];
 end
 
end


 
hasw = strfind(dir',[0 1 0]);

for i=1:numel(hasw)

 hasw1=hasw(i);
 wn1=ind(hasw1);
 wn2=ind(hasw1+2);
 wnm=ind(hasw1+1);
 wdistance=wn2-wn1;
 minindfirst=max(1,wn1-wdistance);
 minfirst=min(tm.Low(minindfirst:wn1));
maxindlast=min(wn2+wdistance,numel(tm.Date));
minlast=min(tm.Low(wn2:maxindlast));

 wl1=tm.High(wn1);
 wl2=tm.High(wn2);
 whm=tm.Low(wnm);
 wm=(wl2-wl1)/(wn2-wn1);
 wb=wl1-wm*wn1;
 wbm=whm-wm*wnm;
 %conditions

  wdn4=whm<wl1-th  & whm<wl2-th;
 wdn1=wl1>wl2;
 wdn2=minfirst<whm;% this has to be based on wm,wb instead
 wdn3=minlast<whm; % this has to be based on wm,wb instead
  %wdn3 is only for detecytion , not for plotting
  wdn=wdn1&wdn2&wdn4;
 
 if (wdn)
   % plot([tm.Date(wn1) tm.Date(wn2)],[wm*wn1+wb wm*wn2+wb],'g');
    % plot([tm.Date(wn1) tm.Date(maxindlast)],[wm*wn1+wbm wm*maxindlast+wbm],'r');
    pp.gx=[pp.gx tm.Date(wn1) tm.Date(wn2) tm.Date(wn2)];
    pp.gy=[pp.gy wm*wn1+wb wm*wn2+wb nan];
    pp.rx=[pp.rx tm.Date(wn1) tm.Date(maxindlast) tm.Date(maxindlast)];
    pp.ry=[pp.ry wm*wn1+wbm wm*maxindlast+wbm nan];
 end
 
end

end
catch exception
dumpReport('error.log', exception)
end
end