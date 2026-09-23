function contract=genContract(DataManager,Symbol,FileSymbol,SecType,Exchange,PrimaryExch,Currency,LastTradeDateOrContractMonth,Strike,Right,LocalSymbol,IncludeExpired)

contract=struct();
if (nargin<12)
contract.IncludeExpired=false;
else
  contract.IncludeExpired=IncludeExpired;  
end
if (nargin<11)
contract.LocalSymbol="";
else
  contract.LocalSymbol=LocalSymbol;
end
if (nargin<10)
contract.Right="None";
else
  contract.Right=Right;
end
if (nargin<9)
contract.Strike=0;
else
  contract.Strike=Strike;
end
if (nargin<8)
contract.LastTradeDateOrContractMonth="";
else
  contract.LastTradeDateOrContractMonth=LastTradeDateOrContractMonth;
end
if (nargin<7)
contract.Currency="USD";
else
  contract.Currency=Currency;
end
if (nargin<6)
contract.PrimaryExch="";
else
  contract.PrimaryExch=PrimaryExch;
end
if (nargin<5)
contract.Exchange="SMART";
else
  contract.Exchange=Exchange;
end
if (nargin<4)
contract.SecType="STK";
else
  contract.SecType=SecType;
end

if (nargin<3)
contract.FileSymbol=Symbol;
else
contract.FileSymbol=FileSymbol;
end

if (nargin<2)
contract.DataManager.DataProvider.RealTime={'yahoo','ib'};
contract.DataManager.DataProvider.Historical={'yahoo','tda','ib'};
else
    contract.DataManager=DataManager;
end


contract.Symbol=Symbol;

if (isempty(contract.FileSymbol))
contract.FileSymbol=contract.Symbol;
end

if (isempty(contract.DataManager))
  contract.DataManager=struct();  
contract.DataManager.DataProvider.RealTime={'yahoo','ib'};
contract.DataManager.DataProvider.Historical={'yahoo','tda','ib'};
contract.DataManager.FileSymbol=Symbol;
end

if (isempty(contract.SecType))
contract.SecType="STK";
end

contract.Multiplier="";
contract.ConId=0;


end