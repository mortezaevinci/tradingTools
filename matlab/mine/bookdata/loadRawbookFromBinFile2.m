function marketdata=loadRawbookFromBinFile2(filename)
marketdata.Book=zeros(120,8,2000);
posixtime=zeros(2000,1);

tempfn=[filename '.temp'];

status = copyfile(filename, tempfn);
fileID = fopen(tempfn,'r');

if (fileID<0)
   marketdata=[];
    return;
end

rbc=1;

while (feof(fileID)==0)
    try
   temp=fread(fileID,1,'uint32');
   if (~isempty(temp))
posixtime(rbc)=temp;
fread(fileID,28,'uint8');
marketdata.Book(:,:,rbc)=fread(fileID,[120,8],'single');

    
    sumsums=sum(sum(squeeze(marketdata.Book(:,1:4,rbc))));
    sumsumb=sum(sum(squeeze(marketdata.Book(:,5:8,rbc))));
    if (sumsums==0 || sumsumb==0)
      %disp('skipped book...');
    else
     rbc=rbc+1;
    end
     
   end
  catch exception
dumpReport('error.log', exception)
end
    
end
rbc=rbc-1;
fclose(fileID);
try
delete(tempfn);
catch
end
marketdata.Book=marketdata.Book(1:120,1:8,1:rbc);
posixtime=posixtime(1:rbc);
marketdata.Date=datetime(posixtime, 'ConvertFrom', 'posixtime');
end

