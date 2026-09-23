function plots=relativeStrength(tabledes,tableref)
    od=tabledes.Open(1);
    odx=tableref.Open(1);
    ors=od/odx;
    maxcommonindex=min(numel(tabledes.Close),numel(tableref.Close));
    maxuncommonindex=max(numel(tabledes.Close),numel(tableref.Close));
    rs=tabledes.Close(1:maxcommonindex)./tableref.Close(1:maxcommonindex);
    rs(isinf(rs))=0;
    rs(isnan(rs))=0;
    
    nc=numel(tabledes.Close);
    nrs=numel(rs);
    if (nc>nrs)
        rs((nrs+1):nc)=0;
    end
    
    percentile=(rs-ors)*(1)/ors;
    plots=[percentile zeros(size(rs))];

end