for si=1:numel(contracts)
    fs=filefriendlysymbol(contracts{si}.FileSymbol);
    disp(fs);
    files = dir([base fs '_*.bn2']);
    for i=1:numel(files)
        src=[base files(i).name];
        des=[base fs '\' files(i).name];
        movefile(src,des);
    end
end