function scanParams=genScanParamsMain(marketCapAbove1e6,volumeAbove,priceAbove,priceBelow)
    scanParams{1}.key="priceAbove"; scanParams{1}.value=num2str(priceAbove);
    scanParams{2}.key="priceBelow"; scanParams{2}.value=num2str(priceBelow);
    scanParams{3}.key="avgVolumeAbove"; scanParams{3}.value=num2str(volumeAbove);
    scanParams{4}.key="marketCapAbove1e6"; scanParams{4}.value=num2str(marketCapAbove1e6);
end