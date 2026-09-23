function y=linearMap(x,minx,maxx,y1,y2)
x(x>maxx)=maxx;
x(x<minx)=minx;

m=(y2-y1)/(maxx-minx);

y=m*(x-minx)+y1;
end