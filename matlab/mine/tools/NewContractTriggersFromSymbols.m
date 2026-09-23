function contractTrigger=NewContractTriggersFromContracts(contracts)
nc=numel(contracts);
volmax=500000000000;
pricemax=500000;
ThMovMaxDiffVol=volmax*ones(nc,1);
ThLastDiffVol=volmax*ones(nc,1);
ThVol=volmax*ones(nc,1);
ThMaxHigh=pricemax*ones(nc,1);
ThClose=pricemax*ones(nc,1);
ThMAtr=pricemax*ones(nc,1);
ThTarget=pricemax*ones(nc,1);
Marked=zeros(nc,1);

cr=cell2mat(contracts);
fnames=fieldnames(cr);
af=struct2cell(cr);
Symbol=squeeze(af(strcmp('Symbol', fieldnames(cr)), :, :));
FileSymbol=squeeze(af(strcmp('FileSymbol', fieldnames(cr)), :, :));
contractTrigger=table(Symbol,FileSymbol,Marked,ThMovMaxDiffVol,ThLastDiffVol,ThVol,ThMaxHigh,ThClose,ThMAtr,ThTarget);
end