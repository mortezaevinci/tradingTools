function []=dumpReport(filename, exception)

msg = getReport(exception,'extended','hyperlinks','on');
disp(msg);
 fid = fopen(filename,'at');
 fprintf(fid, "%s", msg);
 fclose(fid);

end