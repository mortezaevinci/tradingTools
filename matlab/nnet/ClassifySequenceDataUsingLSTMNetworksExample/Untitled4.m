n=500;
X=cell(1,n);
T=cell(1,n);

jj1=0;
jj2=0;
jj3=0;
jj4=0;
jj5=0;
for i=1:n
T{i}=[jj4;jj5];
jj1=rand;
jj2=1+jj1.^2-jj1;
jj3=cos(jj1).*3;
jj4=tan(jj1)./(jj1.^2+.1)+rand/10;
jj5=1./(jj1+2);
X{i}=[jj2;jj3];

end

T=T(1,2:end);
X=X(1,2:end);