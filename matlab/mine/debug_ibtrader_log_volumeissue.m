src='Z:\My files\Project Trading\traderdata\algotrading\autoswing\trader\ibmanageorders_xavol.log';

fsrc = fopen(src);
tline = fgetl(fsrc);

 volMap = containers.Map('KeyType','char','ValueType','any');


while ischar(tline)
    
    

   if (contains(tline,[char(9) 'volume=']))
    %has volume in
    p1=split(tline,[char(9) 'volume=']);  
    if (numel(p1)==2)
        prs=split(p1{1},')');
        if (numel(prs)==2)
           symbol=prs{2};
           pr=split(prs{1}(2:end),':');
           if (numel(pr)==2)
              absrid=str2num(pr{1});
              relrid=str2num(pr{2});
              vol=str2num(p1{2});
              if (isKey(volMap,symbol))
                 volMap(symbol)=[volMap(symbol); [vol, absrid,relrid]];
              else
                  volMap(symbol)=[vol, absrid,relrid];
                  
              end
           end
        end
    end
   end
      
    
   tline = fgetl(fsrc); 
end

fclose(fsrc);

%now, check whether volume is going up and down
symbols=keys(volMap);
ns=numel(symbols);

for ni=1:ns
   sym=cell2mat(symbols(ni));
   map=volMap(sym); 
   volumes=map(:,1);
   absrid=map(:,2);
   %now check whether vals, went up and down
   violations=find(shiftpad(volumes,1)>volumes);
   nviolations=numel(violations);
  
   if (nviolations>0)
       disp([sym ' ' num2str(violations')]);
       disp(num2str([volumes absrid]'));
   end
       
end
