function A=shiftpad(A,n)
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
getReport(exception,'extended','hyperlinks','off')
end
end