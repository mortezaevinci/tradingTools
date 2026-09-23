function A=eliminateshift(A,n,elim)
try
  A=A((1+elim-n):(end-n));
catch exception
dumpReport('error.log', exception)
end
end