try
    if (looperEngine.graph.saveFigures && looperEngine.graph.show>0)
    disp('saving figures...');
    nfig=numel(bbFig);
    for i=1:nfig
        if (nfig==numel(looperEngine.contracts))
            symname=looperEngine.contracts{i}.FileSymbol;
        else
          symname='';
          for i=1:numel(looperEngine.contracts)
            symname=[symname looperEngine.contracts{i}.FileSymbol '_'];
          end
        end
       
       saveas(bbFig{i},[looperEngine.directories.figures 'fig_' filefriendlysymbol(symname) ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.svg']);
       savefig(bbFig{i},['_' looperEngine.directories.figures '_fig_' filefriendlysymbol(symname) ' ' datestr(datetime(),"yy-mm-dd hh_MM_ss") '.fig']);
    end
    end
catch exception
    
end