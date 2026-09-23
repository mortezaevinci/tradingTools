function contractTrigger=NewContractTriggersFromContracts(contracts)
nc=numel(contracts);
volmax=500000000000;
pricemax=500000;
ThDiffVolMax=volmax*ones(nc,1);
ThDiffVolAve=volmax*ones(nc,1);
ThVol=volmax*ones(nc,1);
ThMaxHigh=pricemax*ones(nc,1);
ThEntryStp=pricemax*ones(nc,1);
ThEntryLmt=pricemax*ones(nc,1);
ThMAtr=pricemax*ones(nc,1);
ThTrailAmt=pricemax*ones(nc,1);
ThTarget1=pricemax*ones(nc,1);
ThTarget2=pricemax*ones(nc,1);
ThTarget=pricemax*ones(nc,1);
ThStpLmtDiffPerc=pricemax*ones(nc,1);
ThAbsVol=volmax*ones(nc,1);
ThVolRate=volmax*ones(nc,1);
Marked=zeros(nc,1);

cr=cell2mat(contracts);
fnames=fieldnames(cr);
af=struct2cell(cr);
Symbol=squeeze(af(strcmp('Symbol', fieldnames(cr)), :, :));
FileSymbol=squeeze(af(strcmp('FileSymbol', fieldnames(cr)), :, :));
contractTrigger=table(Symbol,FileSymbol,Marked,...
    ThDiffVolMax,ThDiffVolAve,ThVol,ThAbsVol,ThVolRate,...
    ThMaxHigh,ThEntryStp,ThEntryLmt,ThMAtr,ThTrailAmt,...
    ThTarget,ThTarget1,ThTarget2,ThStpLmtDiffPerc);
end