function localOptimaProfile=localOptimaProfiler(datalength,timetable,combine)

mlow=movmean(timetable.Low,[datalength datalength]);
mhigh=movmean(timetable.High,[datalength datalength]);

 mll=movmin(mlow,[ datalength/2 datalength/2]);
 mhh=movmax(mhigh,[ datalength/2 datalength/2]);
 
 mmll=movmin(mlow,[ datalength/4 datalength/4]);
 mmhh=movmax(mhigh,[ datalength/4 datalength/4]);
 
%se = strel('line',datalength,90);
%mhigh(isnan(mhigh))=0;
%mlow(isnan(mlow))=inf;
%hh = imdilate(mhigh,se);
%ll = imerode(mlow,se);

if (combine)
islocaloptima{1}=mll==mlow;%islocalmin(timetable.Low);
islocaloptima{2}=mhh==mhigh;%islocalmax(timetable.High);

islocaloptima{1}=movmax(islocaloptima{1},[datalength/4 datalength/4]);
islocaloptima{2}=movmax(islocaloptima{2},[datalength/4 datalength/4]);
islocaloptima{1}=islocaloptima{1} & (mmll==mlow);
islocaloptima{2}=islocaloptima{2} & (mmhh==mhigh);

localOptimaProfile.localoptima{1}=islocaloptima{1}.*timetable.Low;
localOptimaProfile.localoptima{2}=islocaloptima{2}.*timetable.High;
localOptimaProfile.indices{1}=find(islocaloptima{1}>0);
localOptimaProfile.indices{2}=find(islocaloptima{2}>0);

localoptima_=[localOptimaProfile.localoptima{1};localOptimaProfile.localoptima{2}];

%% profile levels (this one has to update in real-time)
profilebinsize=15;
profilebindivider=10;

    binindex=find(localoptima_);
   binlocaloptima= localoptima_(binindex);
 [profileN,profileEdges] = histcounts(binlocaloptima,profilebinsize);

thresh_=numel(binlocaloptima)/profilebindivider;
profileLevels_=profileEdges(profileN>thresh_);
wp_=profileN(profileN>thresh_)/thresh_/2;

localOptimaProfile.profilelvls=profileLevels_;
localOptimaProfile.width_profilelvls=wp_; 
else
islocaloptima{1}=mll==mlow;%timetable.Low;%islocalmin(timetable.Low);
islocaloptima{2}=mhh==mhigh;%timetable.High;%islocalmax(timetable.High);

islocaloptima{1}=movmax(islocaloptima{1},[datalength/4 datalength/4]);
islocaloptima{2}=movmax(islocaloptima{2},[datalength/4 datalength/4]);
islocaloptima{1}=islocaloptima{1} & (mmll==mlow);
islocaloptima{2}=islocaloptima{2} & (mmhh==mhigh);

localOptimaProfile.localoptima{1}=islocaloptima{1}.*timetable.Low;
localOptimaProfile.localoptima{2}=islocaloptima{2}.*timetable.High;

localOptimaProfile.indices{1}=find(islocaloptima{1}>0);
localOptimaProfile.indices{2}=find(islocaloptima{2}>0);

%% profile levels (this one has to update in real-time)
profilebinsize=15;
profilebindivider=10;

for i=1:2
    binindex{i}=find(localOptimaProfile.localoptima{i});
   binlocaloptima{i}= localOptimaProfile.localoptima{i}(binindex{i});
 [profileN{i},profileEdges{i}] = histcounts(binlocaloptima{i},profilebinsize);
end

for i=1:2
thresh_=numel(binlocaloptima{i})/profilebindivider;
profileLevels_{i}=profileEdges{i}(profileN{i}>thresh_);
wp_{i}=profileN{i}(profileN{i}>thresh_)/thresh_/2;
end
localOptimaProfile.profilelvls=[profileLevels_{1} profileLevels_{2}];
localOptimaProfile.width_profilelvls=[wp_{1} wp_{2}];
end
end