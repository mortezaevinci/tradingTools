function [probability,conddays]=condition2probability(result,direction)
conddays=sum(result);
correct=result & direction;
corrdays=sum(correct);
% if (conddays==0 && corrdays==0)
%     conddays=1;
% end
probability= corrdays/conddays;

end