function skipperProfile=getdata_IB_generic_manageDataSuccess(ibDataHandler,contract,skipperProfile,date0)

if (ibDataHandler.IbErrorSummary.Symbol~=0)
    sid=[contract.Symbol];
    if (isKey(skipperProfile,sid))
        skipperProfile(sid)=skipperProfile(sid)+1;
    else
        skipperProfile(sid)=1;
    end
elseif (ibDataHandler.IbErrorSummary.TWS==0 ...
        && ibDataHandler.IbErrorSummary.MarketData==0)
    sid=[contract.Symbol date0];
    if (isKey(skipperProfile,sid))
        skipperProfile(sid)=skipperProfile(sid)+1;
    else
        skipperProfile(sid)=1;
    end
end
end