
function tf = CandleRelativeAspects(part1,gtlt,def,part2,observe_)
    %CandleRelativeAspects determines relative aspects of candle
    % 
    % Description
    %     CandleRelativeAspects stands for Candle Relative Aspects
    % 
    % Sytax
    %     CandleRelativeAspects(part1,gtlt,def,part2)
    % 
    % Input
    %     part1 - part1
    %     gtlt  - 1,2 (>,<)
    %     def   - [period multiplication_factor]
    %     part2 - part2
    % 
    % Output
    %     tf    - logical vector, true if conditions are met
    % 
    % Examples
    %     % Long Bodies
    %     tf = CandleRelativeAspects(Body,1,BodyLongDef,Body);
    %     % Very Short Lower Shadow
    %     tf = CandleRelativeAspects(LowerShadow,2,LowerShadowVeryShortDef,Body);
    %
    
    % Cumulative sum of end indices
    % Output looks like:
    % [1 16 31 46 61 76 91 ... ]
    temp_var1 = cumsum([1;(def(1)+1:observer_)'-(1:observer_-def(1))'+1]);
    % Vector of moving indices
    % Output looks like:
    % [1 2 3 4 5 2 3 4 5 6 3 4 5 6 7 4 5 6 7 8 ... ]
    temp_var2 = ones(temp_var1(observer_-def(1)+1)-1,1);
    temp_var2(temp_var1(1:observer_-def(1))) = 1-def(1);
    temp_var2(1) = 1;
    temp_var2 = cumsum(temp_var2);
    
    % Average size of part2
    if     def(1) > 0
        AvgSize = [nan(def(1),1); ...
            (sum(abs(part2(reshape(temp_var2,def(1)+1,observer_-def(1)))))/def(1))'];
    else
        AvgSize = abs(part2);
    end
    
    % Logical vector
    if     gtlt == 1
        tf = part1 > def(2)*AvgSize;
    elseif gtlt == 2
        tf = part1 < def(2)*AvgSize;
    end
    
end