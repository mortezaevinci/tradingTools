p = System.Diagnostics.Process();
p.StartInfo.FileName = 'cmd';
Start(p);

pause(2);

Kill(p);