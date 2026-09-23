function []=RegenerateUniqueContracts(src,des)
gencons='';

fsrc = fopen(src);
fdes = fopen(des,'w+');
tline = fgetl(fsrc);
while ischar(tline)
    
    gencon = extractBefore(tline,",...");
    if (isempty(gencon))
       fprintf(fdes,'%s\n',[tline]);
    else
    doescontain=containsgencon(gencon,gencons);
    if (doescontain)
        %do nothing
    else
     disp(tline);
     gencons=[gencons '.' gencon];
     fprintf(fdes,'%s\n',[tline]);
    end
    
    end
    tline = fgetl(fsrc);
end

fclose(fsrc);
fclose(fdes);
end

function does=containsgencon(gencon,gencons)
does=0;
if (isempty(gencons))
    return;
end
does=contains(gencons,gencon);

 
end

