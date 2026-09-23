base='Z:\My files\Project trading\traderdata\data_other\IB\';

contracts_yahoo;
for si=1:numel(contracts)
    fs=filefriendlysymbol(contracts{si}.FileSymbol);
    if (exist([base fs])==0) 
    mkdir(base,fs);
    end
end

contracts_TDA;
for si=1:numel(contracts)
    fs=filefriendlysymbol(contracts{si}.FileSymbol);
    if (exist([base fs])==0) 
    mkdir(base,fs);
    end
end   

contracts_ib;
for si=1:numel(contracts)
    fs=filefriendlysymbol(contracts{si}.FileSymbol);
    if (exist([base fs])==0) 
    mkdir(base,fs);
    end
end   
'yahoo'
contracts_yahoo;
files = dir(fullfile(base, '*.mat'));
for si=1:numel(contracts)
     fs=filefriendlysymbol(contracts{si}.FileSymbol);
     len=numel(fs)+1;
for i=1:numel(files)
    checksection=files(i).name(1:len);
    if (  strcmp(checksection,[fs ' '])==1)
        src=[base files(i).name];
        des=[base fs '\' files(i).name];
        movefile(src,des);
    end
end
end
'tda'
contracts_TDA;
files = dir(fullfile(base, '*.mat'));
for si=1:numel(contracts)
     fs=filefriendlysymbol(contracts{si}.FileSymbol);
     len=numel(fs)+1;
for i=1:numel(files)
    checksection=files(i).name(1:len);
    if (  strcmp(checksection,[fs ' '])==1)
        src=[base files(i).name];
        des=[base fs '\' files(i).name];
        movefile(src,des);
    end
end
end
'ib'
contracts_ib;
files = dir(fullfile(base, '*.mat'));
for si=1:numel(contracts)
     fs=filefriendlysymbol(contracts{si}.FileSymbol);
     len=numel(fs)+1;
for i=1:numel(files)
    checksection=files(i).name(1:len);
    if (  strcmp(checksection,[fs ' '])==1)
        src=[base files(i).name];
        des=[base fs '\' files(i).name];
        movefile(src,des);
    end
end
end