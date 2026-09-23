function localOptimaProfile=localOptimaProfiler(datalength,params,combine)

se = strel('line',datalength,90);
hh = imdilate(params.TimeTables.Minute.High,se);
ll = imerode(params.TimeTables.Minute.Low,se);

if (combine)
islocaloptima{1}=ll==params.TimeTables.Minute.Low;%islocalmin(params.TimeTables.Minute.Low);
islocaloptima{2}=hh==params.TimeTables.Minute.High;%islocalmax(params.TimeTables.Minute.High);
localOptimaProfile.localoptima{1}=islocaloptima{1}.*params.TimeTables.Minute.Low;
localOptimaProfile.localoptima{2}=islocaloptima{2}.*params.TimeTables.Minute.High;
localOptimaProfile.indices=find(islocaloptima{1}>0 | islocaloptima{2}>0);


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
islocaloptima{1}=ll==params.TimeTables.Minute.Low;%islocalmin(params.TimeTables.Minute.Low);
islocaloptima{2}=hh==params.TimeTables.Minute.High;%islocalmax(params.TimeTables.Minute.High);
localOptimaProfile.localoptima{1}=islocaloptima{1}.*params.TimeTables.Minute.Low;
localOptimaProfile.localoptima{2}=islocaloptima{2}.*params.TimeTables.Minute.High;

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