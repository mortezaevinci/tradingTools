function []=TdaCsv2MatContracts(src,des)

fsrc = fopen(src);
fdes = fopen(des,'w+');
fprintf(fdes,'contracts={\n');
tline = fgetl(fsrc);

afterHeader=0;
firstdone=0;
while ischar(tline)
    
    symbol = extractBefore(tline,",");
    if (isempty(symbol))
        %do nothing, just headers
    else
        if (afterHeader==1)
            disp(tline);
            if (firstdone==1)
                fprintf(fdes,',...\n');
            end
            firstdone=1;
            fprintf(fdes,'genContract([],''%s'',''%s'')',symbol,filefriendlysymbol(symbol));
        else
            if (strcmp(symbol,'Symbol'));afterHeader=1;end
        end
    end
   tline = fgetl(fsrc); 
end


fprintf(fdes,'};\n');
fclose(fsrc);
fclose(fdes);
end
