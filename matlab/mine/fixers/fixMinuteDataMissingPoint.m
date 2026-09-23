function [t2,success]=fixMinuteDataMissingPoint(t2)

t2.Date=datetime(t2.Date);

date0=datestr(t2.Date(1),'yyyy-mm-dd');

t1=datetime([date0 ' 09:30:00'])+minutes([0:389]');

missingno=size(t1,1)-size(t2,1);

while(missingno>0)
indices=find(~(t2.Date==t1(1:end-missingno)));
if (isempty(indices))
   missind=size(t2,1);
else
    missind=indices(1);
end

if (missind==1)
t2=[t2(missind,:) ;t2(missind:end,:)];  
t2.Date(missind)=t2.Date(missind)-minutes(1);
elseif (missind==size(t2,1))
  t2=[t2(1:missind,:); t2(missind,:)];     
t2.Date(missind+1)=t2.Date(missind+0)+minutes(1);
else
      
t2=[t2(1:missind-1,:); t2(missind-1,:);t2(missind:end,:)];
t2.Date(missind)=t2.Date(missind)+minutes(1);
end

missingno=size(t1,1)-size(t2,1);
1;
end




success=size(t2,1)==size(t1,1) & isempty(find(~(t2.Date==t1(1:end-missingno))));

end