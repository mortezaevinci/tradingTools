function mk2=lastIntraMinutes(marketdata)
try
mk2=struct();

%get first minute
d1=marketdata.Date(1);
dl0=d1-seconds(second(d1));
dl1=datetime();

cnt=1;
dt=marketdata.Date(end)-marketdata.Date(1);
mk2l=1:minutes(dt);%1:min(minutes(dt),numel(marketdata.Date));

for i=mk2l
   dl1=dl0+minutes(1);
   mk2.Date(i)=dl0;
   inds=find(marketdata.Date>dl0 & marketdata.Date<dl1);
   if (numel(inds)==0)
       mk2.Book(:,:,i)=zeros(120,8);%NaN(120,8);
   else
   
       %find an index that is non-zero and non-nan
       jj=numel(inds);
       for j=numel(inds):-1:1
           buysample=marketdata.Book(1,3,inds(j));
           sellsample=marketdata.Book(1,7,inds(j));
           if (~isnan(buysample) && ~isnan(sellsample) && buysample>0 && sellsample>0)
               break;               
           end
       end
       
   mk2.Book(:,:,i)=marketdata.Book(:,:,inds(jj));
   end
   cnt=cnt+1;
   
   dl0=dl1;
end
catch exception
   dumpReport('error.log', exception) 
end

end