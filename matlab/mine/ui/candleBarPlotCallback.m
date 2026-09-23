function candleBarPlotCallback(src,event)
  
global lstinteractionPoint;
   lstinteractionPoint=event.IntersectionPoint;
   
   
   txt=['{',datestr(datetime(event.IntersectionPoint(1),'ConvertFrom','datenum')) ',' num2str(event.IntersectionPoint(2) ) '}'];
    disp(txt);

    try
    si=str2num(get(src, 'DisplayName'));
    if (~isempty(si))
        debug_showConditions_func(si);
    end
    catch
        
    end
end