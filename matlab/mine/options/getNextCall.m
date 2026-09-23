function  option=getNextCall(currentprice,baseoptions)
nc=numel(baseoptions.options.calls);
if (iscell(baseoptions.options.calls))
for i=1:nc
    if (~isempty(baseoptions.options.calls{i}))
         option= baseoptions.options.calls{i};
   if (baseoptions.options.calls{i}.strike>=currentprice)
     
      break;
    end
    end
end
end

% if (isstruct(baseoptions.options.calls))
% for i=1:nc
%     if (~isempty(baseoptions.options.calls(1)))
%          option= baseoptions.options.calls(1);
%    if (baseoptions.options.calls(1).strike>=currentprice)
%      
%       break;
%     end
%     end
% end
% end

end