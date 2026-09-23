%%volume profile test
function n=profile(ha,hb)
n=0;
try
    % runs too slow
 %n=barh(hb,ha,'k');
 nb1=numel(ha);
 zz=zeros(nb1,1);
xx=reshape([zz,ha,zz]',nb1*3,1);

yy=[hb,hb,hb]';
yy=reshape(yy,nb1*3,1);

plot(xx,yy);

 catch exception
getReport(exception,'extended','hyperlinks','off')
end
end