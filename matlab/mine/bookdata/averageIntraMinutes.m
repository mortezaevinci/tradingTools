function mk2=averageIntraMinutes(marketdata)
%mk2=marketdata;

%get first minute
d1=marketdata.Date(1);
dl0=d1-seconds(second(d1));
dl1=datetime();

cnt=1;

dt=marketdata.Date(end)-marketdata.Date(1);
mk2l=1:minutes(dt);
mk2.Date=marketdata.Date(mk2l);
mk2.Book=marketdata.Book(:,:,mk2l);

for i=mk2l
   dl1=dl0+minutes(1);
   mk2.Date(i)=dl0;
   inds=find(marketdata.Date>dl0 & marketdata.Date<dl1);
   if (numel(inds)==0)
       mk2.Book(:,:,i)=NaN(120,8);
   else
   
   mk2.Book(:,:,i)=mean(marketdata.Book(:,:,inds),3);
   end
   cnt=cnt+1;
   dl0=dl1;
end

end