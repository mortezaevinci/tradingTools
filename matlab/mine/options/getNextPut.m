function  option=getNextPut(currentprice,baseoptions)
np=numel(baseoptions.options.puts);
if (iscell(baseoptions.options.puts))
for i=np:-1:1
     if (~isempty(baseoptions.options.puts{i}))
          option= baseoptions.options.puts{i};
   if (baseoptions.options.puts{i}.strike<=currentprice)
     
      return;
   end
     end
end
end
% if (isstruct(baseoptions.options.puts))
% for i=np:-1:1
%      if (~isempty(baseoptions.options.puts(1)))
%           option= baseoptions.options.puts(1);
%    if (baseoptions.options.puts(1).strike<=currentprice)
%      
%       return;
%    end
%      end
% end
% end
end