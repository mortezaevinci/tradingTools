%dir=0 is down, dir=1 is up
function result=thresholdCondition(valuein,condtionminmax,direction)

    if (direction==0)
     result=valuein<  -condtionminmax.min & valuein>-condtionminmax.max; 
    else
 result=valuein>  condtionminmax.min & valuein<condtionminmax.max; 
    end
end