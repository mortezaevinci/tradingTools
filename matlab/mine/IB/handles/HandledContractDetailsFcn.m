function output=HandledContractDetailsFcn(src,event)
try
ms=src.ContractDetailsMessages;

for i=0:ms.Count-1
    m=ms.Item(i);
    disp([m.ContractDetails.Contract.Symbol.char '@' m.ContractDetails.Contract.PrimaryExch.char ':']);

disp(['market=' m.ContractDetails.MarketName.char ]);
  disp([  'mintick=' num2str(m.ContractDetails.MinTick) ]);
  disp([  'exchs=' m.ContractDetails.ValidExchanges.char ]);
  disp([  'conid=' num2str(m.ContractDetails.UnderConId)]);

    disp(['stocktype=' m.ContractDetails.StockType.char]);
end
catch exception
    
end

end