function genericEquityContract=MatContract2Ib(matlabcontract)

genericEquityContract = IBApi.Contract();

genericEquityContract.LastTradeDateOrContractMonth = matlabcontract.LastTradeDateOrContractMonth;
genericEquityContract.PrimaryExch = matlabcontract.PrimaryExch;
genericEquityContract.IncludeExpired = matlabcontract.IncludeExpired;
genericEquityContract.Right = matlabcontract.Right;

genericEquityContract.Strike = matlabcontract.Strike;
genericEquityContract.Multiplier = matlabcontract.Multiplier;

genericEquityContract.ConId = matlabcontract.ConId;
genericEquityContract.Currency = matlabcontract.Currency;
genericEquityContract.Exchange = matlabcontract.Exchange;
genericEquityContract.SecType = matlabcontract.SecType;
genericEquityContract.LocalSymbol = matlabcontract.LocalSymbol;
genericEquityContract.Symbol = matlabcontract.Symbol;


end