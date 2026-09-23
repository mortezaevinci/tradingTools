base='Z:\My files\Project trading\traderdata\book\';

% contracts_yahoo;
% for si=1:numel(contracts)
%     fs=filefriendlysymbol(contracts{si}.FileSymbol);
%     if (exist([base fs])==0)
%     mkdir(base,fs);
%     end
% end
%
% contracts_TDA;
% for si=1:numel(contracts)
%     fs=filefriendlysymbol(contracts{si}.FileSymbol);
%     if (exist([base fs])==0)
%     mkdir(base,fs);
%     end
% end
%
% contracts_ib;
% for si=1:numel(contracts)
%     fs=filefriendlysymbol(contracts{si}.FileSymbol);
%     if (exist([base fs])==0)
%     mkdir(base,fs);
%     end
% end
'yahoo'
contracts_yahoo;
dochangedir;
'tda'
contracts_TDA;
dochangedir;
'ib'
contracts_ib;
dochangedir;