function matlabcontract=getGenericContract(ibcontract)
%ignore the naming, it is done this way because of laziness

                    matlabcontract.LastTradeDateOrContractMonth = transferchar(ibcontract.LastTradeDateOrContractMonth);
                    matlabcontract.PrimaryExch =transferchar( ibcontract.PrimaryExch);
                    matlabcontract.IncludeExpired = ibcontract.IncludeExpired;
                    matlabcontract.Right =transferchar( ibcontract.Right);

                    matlabcontract.Strike = ibcontract.Strike;
                    matlabcontract.Multiplier = ibcontract.Multiplier;

                    matlabcontract.ConId = ibcontract.ConId;
                    matlabcontract.Currency = transferchar(ibcontract.Currency);
                    matlabcontract.Exchange = transferchar(ibcontract.Exchange);
                    matlabcontract.SecType = transferchar(ibcontract.SecType);
                    matlabcontract.LocalSymbol = transferchar(ibcontract.LocalSymbol);
                    matlabcontract.Symbol = transferchar(ibcontract.Symbol);
     
                    
end