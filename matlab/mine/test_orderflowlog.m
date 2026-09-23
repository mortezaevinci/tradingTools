fn='C:\temp\tradingTools\csharp\IB2\OrderFlowLogSimulationSpy\bin\Debug\netcoreapp3.1\orderflow.log';
fields_per_line = 5;
fmt = repmat('%s',1,fields_per_line);
fid = fopen(fn,'r');

if (fid<0)
  
    return;
end

filebycolumn = textscan(fid, fmt, 'Delimiter', '\t');
fclose(fid);

nc=numel(filebycolumn);
diff=str2double(filebycolumn{4});
    plot(diff);
 