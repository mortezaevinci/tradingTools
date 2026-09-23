filename=['Q:\My files\Project trading\repo\csharp\bookViewRunner\testSerialize\bin\Debug\netcoreapp3.1\t1.bn2'];

fileID = fopen(filename,'r');

%fseek(fileID,3872,'bof');

posixtime=fread(fileID,1,'uint32');

reserved_=fread(fileID,28,'uint8');
book=fread(fileID,[120,8],'single');

fclose(fileID);