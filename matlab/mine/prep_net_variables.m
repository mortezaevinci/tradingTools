    if (looperEngine.makeNetDataOnlyIfTheyDoNotExist==0 )
        XX{si}=[];
        TT{si}=[];
        tt{si}=[];
        viewxx{si}=[];
    else
        if (~exist('XX') || ~iscell(XX))
            XX{si}=[];
            TT{si}=[];
            tt{si}=[];
            viewxx{si}=[];
        end
    end