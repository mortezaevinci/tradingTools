function A=shiftpad(A,n)
if (n==0)
    return;
end
if (isempty(A))
    return;
end
try
   
if (n>=0)
     a=A(1,:);
    nn=min(n,size(A,1));
A = [repmat(a,nn,1); A(1:end-n,:)];
else
     a=A(end,:);
    nn=min(-n,size(A,1));
A = [A(1-n:end,:);repmat(a,nn,1)];  
end
catch exception
dumpReport('error.log', exception)
end
end