function generalPlotCallback(src,event)
  
   
   x=0.1;%event.IntersectionPoint(1);
   y=0.9;%event.IntersectionPoint(2);
  
   
   ydata=get(src,'YData');
   txt=[get(src, 'DisplayName') ',' num2str(ydata(1)) ',{',datestr(datetime(event.IntersectionPoint(1),'ConvertFrom','datenum')) ',' num2str(event.IntersectionPoint(2) ) '}'];
    disp(txt);
     name = text(x,y,txt,'units','normalized');
  pause(1);
  delete (name);
end