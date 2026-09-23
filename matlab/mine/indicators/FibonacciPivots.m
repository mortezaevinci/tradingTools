function pivots=FibonacciPivots(mc,mh,ml)

try
    %pp
pivots(5)=(mc+mh+ml)/3;
%res
pivots(6)=pivots(5)+(mh-ml)*.382;
pivots(7)=pivots(5)+(mh-ml)*.618;
pivots(8)=pivots(5)+(mh-ml)*1;
pivots(9)=pivots(5)+(mh-ml)*1.618;
%support
pivots(4)=pivots(5)-(mh-ml)*.382;
pivots(3)=pivots(5)-(mh-ml)*.618;
pivots(2)=pivots(5)-(mh-ml)*1;
pivots(1)=pivots(5)-(mh-ml)*1.618;

catch exception
dumpReport('error.log', exception)
pivots=[];
end
end