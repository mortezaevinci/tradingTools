function contracts=genContractsFromSymbols(csv)
contracts={};
if (isempty(csv))
return;
end

symbols = split(csv,',');
%symbols=unique(symbols);
ns=numel(symbols);

contracts=[];

cnt=1;
for i=1:ns
    symb=upper(char(symbols(i)));
    if (~isempty(symb))
   contracts{cnt}=genContract([],symb);
   cnt=cnt+1;
    end
end

end