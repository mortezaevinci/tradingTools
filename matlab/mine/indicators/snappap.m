function SnappedPAP=snappap(timetable,params)
%% process
tms=size(timetable,1);
ttp.min=min(timetable.Open);
ttp.max=max(timetable.Open);

ttp.snap1=timetable.Open(1);
ttp.snap2=timetable.Open(end);

wd=weekday(timetable.Date(1));

SnappedPAP=movmedian(params.PriceActionProfile.Open,[1 1]);

pap.min=min(SnappedPAP(1:tms));
pap.max=max(SnappedPAP(1:tms));

SnappedPAP=SnappedPAP*(ttp.max-ttp.min)/(pap.max-pap.min);
pap.snap1=SnappedPAP(1);
pap.snap2=SnappedPAP(tms);

snapextention=numel(SnappedPAP);

ttpl=linspace(ttp.snap1,ttp.snap2+(ttp.snap2-ttp.snap1)*snapextention/(tms+snapextention),snapextention)';
papl=linspace(pap.snap1,pap.snap2+(pap.snap2-pap.snap1)*snapextention/(tms+snapextention),snapextention)';

SnappedPAP=SnappedPAP-papl+ttpl;
end