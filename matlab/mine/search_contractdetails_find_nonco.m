base='Z:\My files\Project trading\traderdata\data_other\IB\';
cdmapfn=[base 'contractdetails.mat'];
load(cdmapfn);
fnames=fieldnames(contractDetailsMap);

newcontractsfn='contracts\contracts_penniesm2_trade.m';

contracts_penniesm2;

nc=numel(contracts);

goodlist='';
first=1;
cndbad=0;
for ci=1:nc
    ffsym=fieldfriendlysymbol(contracts{ci}.Symbol);
   try
        if (ismember(ffsym,fnames))
         stt=contractDetailsMap.(ffsym).StockType;
         if (strcmp(stt,'MLP')==0 && strcmp(stt,'COMMON')==0 && strcmp(stt,'ADR')==0 && strcmp(stt,'PREFERRED')==0)
           disp([contracts{ci}.Symbol ' not suitable for pump trade. Its stock type is ' stt]);
           cndbad=cndbad+1;
         else
             %add them
             if (first)
                 com='';
                 first=0;
             else
                 com=',';
             end

             goodlist=[goodlist com contracts{ci}.Symbol];
         end
       end
   catch exception
        dumpReport('error.log', exception) 
   end
    
end

genContractFileFromSymbols(newcontractsfn,goodlist);