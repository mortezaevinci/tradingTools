function plots=relativeStrength(tabledes,tableref)
    od=tabledes.Open(1);
    odx=tableref.Open(1);
    ors=od/odx;
    rs=tabledes.Close./tableref.Close;
    rs(isinf(rs))=0;
    rs(isnan(rs))=0;
    percentile=(rs-ors)*100/ors;
    plots=[percentile zeros(size(rs))];

end