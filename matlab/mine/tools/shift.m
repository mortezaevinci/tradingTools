function A=shift(A,n)
try
if (n>=0)
A = [zeros(min(n,size(A,1)),size(A,2)); A(1:end-n,:)];
else
A = [A(1-n:end,:);zeros(min(-n,size(A,1)),size(A,2))];  
end
catch exception
dumpReport('error.log', exception)
end
end