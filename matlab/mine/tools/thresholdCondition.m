%dir=0 is down, dir=1 is up
function result=thresholdCondition(valuein,condtionminmax,direction)

    if (direction==0)  %It's breaking out smaller
     result=valuein<  -condtionminmax.min & valuein>-condtionminmax.max; 
    elseif (direction==1) %it's breaking out larger
 result=valuein>  condtionminmax.min & valuein<condtionminmax.max; 
    elseif (direction==3) %it's getting smaller toward 0
    result=valuein<  condtionminmax.min;  
    elseif (direction==2) %it's getting smaller toward 0
    result=valuein>- condtionminmax.min;  
    end
end