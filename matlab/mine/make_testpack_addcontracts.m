ncontracts=numel(contracts);
for ci=1:ncontracts
            
           
            if (~contains(donesymbols,[contracts{ci}.FileSymbol '.']))
                try
                     testpack{scnt}.contract=contracts{ci};
                      disp(testpack{scnt}.contract.FileSymbol);
                        donesymbols=[donesymbols testpack{scnt}.contract.FileSymbol '.'];
           
                    fn=[basedir contracts{ci}.FileSymbol '\' contracts{ci}.FileSymbol ' ' datatype ' ' date '.mat'];
                    if (exist(fn))
                    load(fn);
                    testpack{scnt}.params.TimeTables.Day=table2timetable(td);
                    
                       scnt=scnt+1;                
                    end    
                catch exception
                    dumpReport('error.log', exception)
                    
                end
            end
        end