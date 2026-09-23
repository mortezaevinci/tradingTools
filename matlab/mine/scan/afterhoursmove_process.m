for sh=1:3
                    vv{sh}=eliminateshift(params.TimeTables.Day.Volume,sh-realmode,maxelim);
                    cc{sh}=eliminateshift(params.TimeTables.Day.Close,sh-realmode,maxelim);
                    oo{sh}=eliminateshift(params.TimeTables.Day.Open,sh-realmode,maxelim);
                    dd{sh}=cc{sh}-oo{sh};
                    end
                    for sh=1:2
                    af{sh}=oo{sh}-cc{sh+1};
                    end
                    tol=cc{1}*.01;
                    
                    sma20=movmean(oo{1},[20 0]);
                    sma50=movmean(oo{1},[50 0]);
                    sma100=movmean(oo{1},[100 0]);
                    sma200=movmean(oo{1},[200 0]);
                    
                    dsma20=sma20-shiftpad(sma20,1);
                    dsma50=sma50-shiftpad(sma50,1);
                    dsma100=sma50-shiftpad(sma100,1);
                    dsma200=sma200-shiftpad(sma200,1);
                    
                    %buy signal
                    enter=(dsma20>0 & dsma50<0 & dsma200<0 ...
                    & cc{1}>50 ...
            &   vv{1}>vv{2} & vv{1}>100000 ...
                    & dd{1}>0 & dd{2}>tol & dd{3}<-tol ...
                            & af{1}<0 & af{2}<0 & af{1}>af{2});
                                         