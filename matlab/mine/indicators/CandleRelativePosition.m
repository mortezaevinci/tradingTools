function tf = CandleRelativePosition(part1,gtlt,part2,num,observer_)
    %CandleRelativePosition compares relative position of candle
    % 
    % Description
    %     CandleRelativePosition stands for Candle Relative Position
    % 
    % Syntax
    %     CandleRelativePosition(part1,position,part2,num)
    %     CandleRelativePosition(part1,part2,part3,num)
    % 
    % Inputs
    %     part1 - part1
    %     gtlt  - 1,2,part2 (>,<,part2)
    %     part2 - part2,part3
    %     num   - number to go back to compare part1 to -1.  1 is current
    %             index, 2 is 1 index back, 3 is 2 indices back
    % 
    % Output
    %     tf    - logical vector, true if conditions are met
    % 
    % Examples
    %     % tf = Top(2:end) > Bottom(1:end-1)
    %     tf = CandleRelativePosition(Top,1,Bottom,2)
    %     % tf = Bottom(4:end) < Top(1:end-3)
    %     tf = CandleRelativePosition(Bottom,2,Top,4)
    %     % tf = Top(3:end) < TimeTable.High(1:end-2) & Top(3:end) > TimeTable.Low(1:end-2)
    %     tf = CandleRelativePosition(Top,TimeTable.High,TimeTable.Low,4)
    %
    
    if     gtlt == 1
        tf = [false(num-1,1); part1(num:observer_) > part2(1:observer_-num+1)];
    elseif gtlt == 2
        tf = [false(num-1,1); part1(num:observer_) < part2(1:observer_-num+1)];
    else
        tf = [false(num-1,1); part1(num:observer_) >= part2(1:observer_-num+1) & ...
            part1(num:observer_) <= gtlt(1:observer_-num+1)];
    end
    
end
