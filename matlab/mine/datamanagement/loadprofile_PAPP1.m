function params=loadprofile_PAPP1(params,looperEngine)
try
% this only needs to load once.
vfilename=[looperEngine.directories.PAP 'PAPP1 ' filefriendlysymbol(params.contract.FileSymbol) '.mat'];
if (exist(vfilename))
load(vfilename);
params.PriceActionProfile=PriceActionProfile;
params.PriceActionProfileW=PriceActionProfileW;
end

catch exception
dumpReport('error.log', exception)
end

end