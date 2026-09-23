book=zeros(120,8,2000);
%dt=datetime()+zeros(1,2000);
posixtime=zeros(2000,1);
filename=['Q:\My files\Project Trading\traderdata\book\AAL_book_history 2020-06-11.bn2'];
fileID = fopen(filename,'r');

bcnt=1;
while (feof(fileID)==0)
    try

%fseek(fileID,3872,'bof');

posixtime(bcnt)=fread(fileID,1,'uint32');

reserved_=fread(fileID,28,'uint8');
book(:,:,bcnt)=fread(fileID,[120,8],'single');
bcnt=bcnt+1;
    catch
        
    end
    
end

fclose(fileID);


dt=datetime(posixtime, 'ConvertFrom', 'posixtime');