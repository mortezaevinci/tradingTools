function symbols=extractOptioncontracts(options)
symbols={};
no=numel(options);
scnt=1;
try
for io=1:no
    try
    nc=numel(options{io}.options.calls);
    for ic=1:nc
        try
       symbols{scnt}=options{io}.options.calls(ic).contractSymbol;
       scnt=scnt+1;
        catch
  
        end
    end
    np=numel(options{io}.options.puts);
    for ip=1:np
        try
       symbols{scnt}=options{io}.options.calls(ip).contractSymbol;
       scnt=scnt+1;
        catch
  
        end
    end
    catch
  
end
end

catch
  
end

end