bookviewcommand=['start /MIN "ONDEMAND" "' 'C:\temp\tradingTools\csharp\bookViewRunner\bookViewRunner\bin\release\bookviewrunner.exe' '" ' 'AAPL' ' 50 5000 "' 'c:\temp\traderdata\book_ondemand\' '"'];
bookviewcommand=['"C:\temp\tradingTools\csharp\bookViewRunner\bookViewRunner\bin\release\bookviewrunner.exe' '" ' 'AAPL' ' 50 5000 "' 'c:\temp\traderdata\book_ondemand\' '"'];

% status = system(bookviewcommand);

proc = System.Diagnostics.Process(); 
proc.StartInfo.FileName = 'C:\temp\tradingTools\csharp\bookViewRunner\bookViewRunner\bin\release\bookviewrunner.exe';
%proc.StartInfo.FileName = 'cmd';
proc.StartInfo.UseShellExecute = false;
proc.StartInfo.Arguments = ['AAPL' ' 50 5000 "' 'c:\temp\traderdata\book_ondemand\' '"'];
%proc.StartInfo.Arguments = [' /c ' bookviewcommand];
%proc.StartInfo.RedirectStandardInput = true;
%proc.StartInfo.RedirectStandardOutput = true;
Start(proc);

% pause(10);
% 
%     proc.StandardInput.AutoFlush = true;
%     proc.StandardInput.Write("exit");  
%     proc.StandardInput.Close(); 
% pause(1);
%Kill(proc);