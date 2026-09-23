function [bull bear neutral] = candlesticks(TimeTable)
%CANDLESTICKS calculates various types of candlesticks
% 
% Description
%     Since the early days of the Japanese rice traders, candlestick
%     charting has grown into a complex technical analysis tool based
%     primarily on patterns.  Candlestick charts are flexible, because
%     candlestick charts can be used alone or in combination with other
%     technical analysis techniques, not instead of other technical tools.
%     As with all charting methods, candlestick chart patterns are subject
%     to interpretation by the user.  Currently, there are 90 patterns.
% 
% Syntax
%     [bull bear neutral] = candlesticks(open,high,low,close)
% 
% Inputs
%     open  - open price
%     high  - high price
%     low   - low price
%     close - close price
% 
% Outputs
%     bear    - bearish patterns
%     bull    - bullish patterns
%     neutral - neutral patterns
%     Outputs are formatted into cells.  The index of each cell corresponds
%     to the index of that pattern in the order listed under Candlesticks.
%     Each cell holds all of the indices from the input for the end of a
%     pattern.
%     For example:
%     bear{1} is the Abandoned Baby pattern
%     [23; 78; 92] are the contents of that cell and are the indices of the
%     end of that pattern
% 
% Candlesticks
%     Bullish Reversal TimeTable.High Reliability
%         01 - Abandoned Baby
%         02 - Concealing Baby Swallow
%         03 - Kicking
%         04 - Morning Doji Star
%         05 - Morning Star
%         06 - Piercing Line
%         07 - Three Inside Up
%         08 - Three Outside Up
%         09 - Three White Soldiers
%     Bullish Reversal Moderate Reliability
%         10 - Breakaway
%         11 - Counter Attack
%         12 - Doji Star
%         13 - Dragonfly Doji
%         14 - Engulfing
%         15 - Gravestone Doji
%         16 - Harami Cross
%         17 - Homing Pigeon
%         18 - Ladder Bottom
%         19 - Long Legged Doji
%         20 - Matching TimeTable.Low
%         21 - Meeting Lines
%         22 - Stick Sandwich
%         23 - Three Stars in the South
%         24 - Tri Star
%         25 - Unique Three River Bottom
%     Bullish Reversal TimeTable.Low Reliability
%         26 - Belt Hold
%         27 - Hammer
%         28 - Harami
%         29 - Inverted Hammer
%     Bullish Continuation TimeTable.High Reliability
%         30 - Mat Hold
%         31 - Rising Three Methods
%     Bullish Continuation Moderate Reliability
%         32 - Side-by-Side White Lines
%         33 - Upside Tasuki Gap
%         34 - Upside Gap Three Methods
%     Bullish Continuation TimeTable.Low Reliability
%         35 - Separating Lines
%         36 - Three Line Strike
%     Bullish Reversal/Continuation TimeTable.Low Reliability
%         37 - Closing Marubozu
%         38 - Long Line
%         39 - Marubozu
%         40 - Opening Marubozu
% 
%     Bearish Reversal TimeTable.High Reliability
%         01 - Abandoned Baby
%         02 - Dark Cloud Cover
%         03 - Evening Doji Star
%         04 - Evening Star
%         05 - Kicking
%         06 - Three Black Crows
%         07 - Three Inside Down
%         08 - Three Outside Down
%         09 - Upside Gap Two Crows
%     Bearish Reversal Moderate Reliability
%         10 - Advance Block
%         11 - Breakaway
%         12 - Counter Attack
%         13 - Deliberation
%         14 - Doji Star
%         15 - Dragonfly Doji
%         16 - Engulfing
%         17 - Gravestone Doji
%         18 - Harami Cross
%         19 - Identical Three Crows
%         20 - Long Legged Doji
%         21 - Meeting Lines
%         22 - Tri Star
%         23 - Two Crows
%     Bearish Reversal TimeTable.Low Reliability
%         24 - Belt Hold
%         25 - Hanging Man
%         26 - Harami
%         27 - Shooting Star
%     Bearish Continuation TimeTable.High Reliability
%         28 - Falling Three Methods
%     Bearish Continuation Moderate Reliability
%         29 - Downside Gap Three Methods
%         30 - Downside Tasuki Gap
%         31 - In Neck
%         32 - On Neck
%         33 - Side-by-Side White Lines
%     Bearish Continuation TimeTable.Low Reliability
%         34 - Separating Lines
%         35 - Three Line Strike
%         36 - Thrusting
%     Bearish Reversal/Continuation TimeTable.Low Reliability
%         37 - Closing Marubozu
%         38 - Long Line
%         39 - Marubozu
%         40 - Opening Marubozu
% 
%     Neutral Reversal Moderate Reliability
%         01 - TimeTable.High Wave
%         02 - Inverted Takuri/Umbrella
%         03 - Takuri/Umbrella
%     Neutral Reversal/Continuation TimeTable.Low Reliability
%         04 - Doji
%         05 - Four Price Doji
%         06 - Normal Line
%         07 - Rickshaw Man
%         08 - Short Line
%         09 - Spinning Top
%         10 - Stalled Pattern
% 
% Notes
%     - data must be column oriented
%     - there are no argument checks
%     - most patterns require a prior bullish or bearish trend; this code
%     does not check for that
%     - all patterns either require, recommend, or suggest confirmation;
%     this code does not check for that
% 
% Example
%     load disney.mat
%     [bull bear neutral] = candlesticks(dis_OPEN,dis_HIGH,dis_LOW,dis_CLOSE);
% 
% Further Information
%     For an in depth analysis of how many of these candlesticks work,
%     refer to one of the following websites or Google it.
%     http://www.candlesticker.com/
%

% Version : 1.0 (11/02/2011)
% Author  : Nate Jensen
% Created : 10/25/2011
% History :
%  - v1.0 11/02/2011 : initial release

% To Do
%  - add more candlesticks

%% Initialize


% Number of observer_ations
observer_  = size(TimeTable.Open,1);
indices = (1:observer_)';

% Format Output
bear    = cell(40,1);
bull    = cell(40,1);
neutral = cell(10,1);

if (size(TimeTable,1)<=10)
    return;
end

% Defaults
% Example:
% BodyLongDef = [10 1];
% A body will be considered long if it is 1x longer than the average of the
% past 10 bodies

% Name                  = [period mul_fac]
BodyLongDef             = [10 1];
% BodyVeryLongDef         = [10 3];
BodyShortDef            = [10 1];
BodyVeryShortDef        = [10 0.1];
ShadowLongDef           = [0 1];
ShadowVeryLongDef       = [0 2];
% ShadowShortDef          = [10 1];
ShadowVeryShortDef      = [10 0.1];
UpperShadowLongDef      = [0 1];
% UpperShadowVeryLongDef  = [0 2];
UpperShadowShortDef     = [10 1];
UpperShadowVeryShortDef = [10 0.1];
LowerShadowLongDef      = [0 1];
LowerShadowVeryLongDef  = [0 2];
LowerShadowShortDef     = [10 1];
LowerShadowVeryShortDef = [10 0.1];

% Candle parts
Body        = TimeTable.Close-TimeTable.Open;
White       = Body > 0;
Body        = abs(Body);
HighLow     = TimeTable.High-TimeTable.Low;
UpperShadow = TimeTable.High-max(TimeTable.Open,TimeTable.Close);
LowerShadow = min(TimeTable.Open,TimeTable.Close)-TimeTable.Low;
FullShadow  = UpperShadow+LowerShadow;
Top         = max(TimeTable.Open,TimeTable.Close);
Bottom      = min(TimeTable.Open,TimeTable.Close);

% Candle Relative Aspects
BodyLong             = CandleRelativeAspects(Body,1,BodyLongDef,Body,observer_);
% BodyVeryLong         = CandleRelativeAspects(Body,1,BodyVeryLongDef,Body,observer_);
BodyShort            = CandleRelativeAspects(Body,2,BodyShortDef,Body,observer_);
BodyVeryShort        = CandleRelativeAspects(Body,2,BodyVeryShortDef,HighLow,observer_);
ShadowLong           = CandleRelativeAspects(FullShadow,1,ShadowLongDef,Body,observer_);
ShadowVeryLong       = CandleRelativeAspects(FullShadow,1,ShadowVeryLongDef,Body,observer_);
% ShadowShort          = CandleRelativeAspects(FullShadow,2,ShadowShortDef,Body,observer_);
ShadowVeryShort      = CandleRelativeAspects(FullShadow,2,ShadowVeryShortDef,Body,observer_);
UpperShadowLong      = CandleRelativeAspects(UpperShadow,1,UpperShadowLongDef,Body,observer_);
% UpperShadowVeryLong  = CandleRelativeAspects(UpperShadow,1,UpperShadowVeryLongDef,Body,observer_);
UpperShadowShort     = CandleRelativeAspects(UpperShadow,2,UpperShadowShortDef,Body,observer_);
UpperShadowVeryShort = CandleRelativeAspects(UpperShadow,2,UpperShadowVeryShortDef,Body,observer_);
LowerShadowLong      = CandleRelativeAspects(LowerShadow,1,LowerShadowLongDef,Body,observer_);
LowerShadowVeryLong  = CandleRelativeAspects(LowerShadow,1,LowerShadowVeryLongDef,Body,observer_);
LowerShadowShort     = CandleRelativeAspects(LowerShadow,2,LowerShadowShortDef,Body,observer_);
LowerShadowVeryShort = CandleRelativeAspects(LowerShadow,2,LowerShadowVeryShortDef,Body,observer_);

%% Bullish (Bearish) Reversal TimeTable.High Reliability

% Abandoned Baby
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 3
% - 1st: black (white), long
% - 2nd: very short, downside (upside) shadow gap with 1st
% - 3rd: white (black), moves well within the first candle, not short,
% upside (downside) shadow gap with 2nd
cs1 = ~White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(TimeTable.High,2,TimeTable.Low,2,observer_);
cs3 = White & ~BodyShort & CandleRelativePosition(TimeTable.Low,1,TimeTable.High,2,observer_) & CandleRelativePosition(TimeTable.Close,TimeTable.Open,TimeTable.Close,3,observer_);
bull{1} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(TimeTable.Low,1,TimeTable.High,2,observer_);
cs3 = ~White & ~BodyShort & CandleRelativePosition(TimeTable.High,2,TimeTable.Low,2,observer_) & CandleRelativePosition(TimeTable.Close,TimeTable.Close,TimeTable.Open,3,observer_);
bear{1} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Concealing Baby Swallow
% Direction    : Bullish
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 4
% - 1st: black, very short shadows
% - 2nd: black, very short shadows
% - 3rd: black, opens gapping down, upper shadow extends into 2nd body
% - 4th: black, body engulfs 3rd shadow
cs1 = ~White & ShadowVeryShort;
cs2 = ~White & ShadowVeryShort;
cs3 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.High,1,TimeTable.Close,2);
cs4 = ~White & CandleRelativePosition(TimeTable.Open,1,TimeTable.High,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Low,2);
bull{2} = indices(cs1(1:observer_-3) & cs2(2:observer_-2) & cs3(3:observer_-1) & cs4(4:observer_))+3;

% Kicking
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Required
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% 1st: black (white), very short shadows
% 2nd: white (black), very short shadows, upside (downside) shadow gap with
% 1st
cs1 = ~White & ShadowVeryShort;
cs2 = White & ShadowVeryShort & CandleRelativePosition(TimeTable.Low,1,TimeTable.High,2);
bull{3} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White & ShadowVeryShort;
cs2 = ~White & ShadowVeryShort & CandleRelativePosition(TimeTable.High,2,TimeTable.Low,2);
bear{5} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Morning Doji Star (Evening Doji Star)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 3
% - 1st: black (white), long body
% - 2nd: very short body, downside (upside) body gap with 1st
% - 3rd: white (black), moves well within 1st body
cs1 = ~White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(Top,2,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Close,TimeTable.Open,TimeTable.Close,3);
bull{4} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(Bottom,1,TimeTable.Close,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bear{3} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Morning Star (Evening Star)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 3
% - 1st: black (white), long body
% - 2nd: short body, downside (upside) body gap with 1st
% - 3rd: white (black), moves well within 1st body
cs1 = ~White & BodyLong;
cs2 = BodyShort & CandleRelativePosition(Top,2,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Close,TimeTable.Open,TimeTable.Close,3);
bull{5} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = White & BodyLong;
cs2 = BodyShort & CandleRelativePosition(Bottom,1,TimeTable.Open,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bear{4} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Piercing Line (Dark Cloud Cover)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white), long body
% - 2nd: white (black), long body, open below 1st low (high), closes above
% (below) midpoint of 2nd, closes below (above) open of 1st
cs1 = ~White & BodyLong;
cs2 = White & BodyLong & CandleRelativePosition(TimeTable.Open,2,TimeTable.Low,2) & CandleRelativePosition(TimeTable.Close,TimeTable.Open,(TimeTable.Open+TimeTable.Close)/2,2);
bull{6} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White & BodyLong;
cs2 = ~White & BodyLong & CandleRelativePosition(TimeTable.Open,2,TimeTable.High,2) & CandleRelativePosition(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Open,2);
bear{2} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Three Inside Up (Three Inside Down)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 3
% - 1st: black (white), long body
% - 2nd: white (black), short body, body engulfed by 1st
% - 3rd: white (black), closes higher (lower) than 2nd close
cs1 = ~White & BodyLong;
cs2 = White & BodyShort & CandleRelativePosition(TimeTable.Close,2,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
bull{7} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = White & BodyLong;
cs2 = ~White & BodyShort & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Open,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2);
bear{7} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Three Outside Up (Three Outside Down)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bullish (Bearish)
% Sticks       : 3
% - 1st: black (white)
% - 2nd: white (black), body engulfs 1st body
% - 3rd: white (black), higher (lower) close than close of 2nd
cs1 = ~White;
cs2 = White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Open,2);
cs3 = White & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
bull{8} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = White;
cs2 = ~White & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Open,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2);
bear{8} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Three White Soldiers (Three Black Crows)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 3
% - 1st: white (black), not short
% - 2nd: white (black), not short, higher (lower) close than 1st close,
% open in body of 1st
% - 3rd: white (black), not short, higher (lower) close than 2nd close,
% open in body of 2nd
cs1 = White & ~BodyShort;
cs2 = White & ~BodyShort & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
cs3 = White & ~BodyShort & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
bull{9} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = ~White & ~BodyShort;
cs2 = ~White & ~BodyShort & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Open,TimeTable.Open,TimeTable.Close,2);
cs3 = ~White & ~BodyShort & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Open,TimeTable.Open,TimeTable.Close,2);
bear{6} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Upside Gap Two Crows
% Direction    : Bearish
% Type         : Reversal
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bullish
% Sticks       : 3
% - 1st: white, long body
% - 2nd: black, short body, upside body gap with 1st
% - 3rd: black, body engulfs 2nd body, closes above 1st close
cs1 = White & BodyLong;
cs2 = ~White & BodyShort & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Open,1,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,3);
bear{9} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

%% Bullish (Bearish) Reversal Moderate Reliability

% Advance Block
% Direction    : Bearish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bullish
% Sticks       : 3
% - 1st: white, not short body
% - 2nd: white, higher close than 1st close, weakening, not very short
% upper shadow, opens within body of 1st
% - 3rd: white, higher close than 2nd close, weakening, not short upper
% shadow, opens within body of 2nd
cs1 = White & BodyLong;
cs2 = White & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2) & CandleRelativePosition(Body,2,Body,2) & ~UpperShadowVeryShort & ...
    CandleRelativePosition(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
cs3 = White & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2) & CandleRelativePosition(Body,2,Body,2) & ~UpperShadowShort & ...
    CandleRelativePosition(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
bear{10} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Breakaway
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Recommended
% Prior Trend  : Bearish (Bullish)
% Sticks       : 5
% - 1st: black (white), long
% - 2nd: black (white), downside (upside) body gap
% - 3rd: lower (higher) bottom and lower (higher) top than 2nd
% - 4th: black (white), lower (higher) close and lower (higher) open than 3rd
% - 5th: white (black), closes higher (lower) than high (low) of 2nd
cs1 = ~White & BodyLong;
cs2 = ~White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2);
cs3 = CandleRelativePosition(Top,2,TimeTable.Open,2) & CandleRelativePosition(Bottom,2,TimeTable.Close,2);
cs4 =  ~White & CandleRelativePosition(TimeTable.Open,2,Top,2) & CandleRelativePosition(TimeTable.Close,2,Bottom,2);
cs5 = White & CandleRelativePosition(TimeTable.Close,1,TimeTable.High,4);
bull{10} = indices(cs1(1:observer_-4) & cs2(2:observer_-3) & cs3(3:observer_-2) & ...
    cs4(4:observer_-1) & cs5(5:observer_))+4;
cs1 = White & BodyLong;
cs2 = White & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2);
cs3 = CandleRelativePosition(Top,1,TimeTable.Close,2) & CandleRelativePosition(Bottom,1,TimeTable.Open,2);
cs4 = White & CandleRelativePosition(TimeTable.Open,1,Bottom,2) & CandleRelativePosition(TimeTable.Close,1,Top,2);
cs5 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Low,4);
bear{11} = indices(cs1(1:observer_-4) & cs2(2:observer_-3) & cs3(3:observer_-2) & ...
    cs4(4:observer_-1) & cs5(5:observer_))+4;

% Counter Attack
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white), long
% - 2nd: white (black), long, close near 1st close
cs1 = ~White & BodyLong;
cs2 = White & BodyLong;
bull{11} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White & BodyLong;
cs2 = ~White & BodyLong;
bear{12} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Deliberation
% Direction    : Bearish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bullish
% Sticks       : 3
% - 1st: white, long body
% - 2nd: white, long body
% - 3rd: white, short body, upside body gap
cs1 = White & BodyLong;
cs2 = White & BodyLong;
cs3 = White & BodyShort & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2);
bear{13} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Doji Star
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white), long
% - 2nd: very short body, downside (upside) body gap
cs1 = ~White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(Top,2,TimeTable.Close,2);
bull{12} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(Bottom,1,TimeTable.Close,2);
bear{14} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Dragonfly Doji
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 1
% - 1st: very short body, very short upper shadow, very long lower
% shadow
cs1 = BodyVeryShort & UpperShadowVeryShort & LowerShadowVeryLong;
bull{13} = indices(cs1);
cs1 = BodyVeryShort & UpperShadowVeryShort & LowerShadowVeryLong;
bear{15} = indices(cs1);

% Engulfing
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white)
% - 2nd: white (black), body engulfs 2nd body
cs1 = ~White;
cs2 = White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Open,2);
bull{14} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White;
cs2 = ~White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
bear{16} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Gravestone Doji
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white)
% - 2nd: very short body, very short lower shadow, long upper shadow,
% upside body gap with 1st
cs1 = ~White;
cs2 = BodyVeryShort & LowerShadowVeryShort & UpperShadowLong & CandleRelativePosition(Bottom,1,TimeTable.Close,2);
bull{15} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White;
cs2 = BodyVeryShort & LowerShadowVeryShort & UpperShadowLong & CandleRelativePosition(Bottom,1,TimeTable.Close,2);
bear{17} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Harami Cross
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Recommended
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white), long body
% - 2nd: very short body, body engulfed by 1st body
cs1 = ~White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(Top,2,TimeTable.Open,2) & CandleRelativePosition(Bottom,1,TimeTable.Close,2);
bull{16} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CandleRelativePosition(Top,2,TimeTable.Close,2) & CandleRelativePosition(Bottom,1,TimeTable.Open,2);
bear{18} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Homing Pigeon
% Direction    : Bullish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 2
% - 1st: black, long body
% - 2nd: black, short body, body engulfed by 1st body
cs1 = ~White & BodyLong;
cs2 = ~White & BodyShort & CandleRelativePosition(TimeTable.Open,2,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
bull{17} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Identical Three Crows
% Direction    : Bearish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bullish
% Sticks       : 3
% 1st: black, very short lower shadow
% 2nd: black, very short lower shadow, open near close of 1st
% 3rd: black, very short lower shadow, open near close of 2nd
cs1 = ~White & LowerShadowVeryShort;
cs2 = ~White & LowerShadowVeryShort & CandleRelativePosition(TimeTable.Open,2,(TimeTable.Open+TimeTable.Close)/2,2);
cs3 = ~White & LowerShadowVeryShort & CandleRelativePosition(TimeTable.Open,2,(TimeTable.Open+TimeTable.Close)/2,2);
bear{19} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Ladder Bottom
% Direction    : Bullish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 5
% - 1st: black, close less than prior high, short lower shadow
% - 2nd: black, close less than 1st close, short lower shadow
% - 3rd: black, close less than 2nd close, short lower shadow
% - 4th: black, not very short upper shadow
% - 5th: white, opens above 4th body, closes above 4th high
cs1 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.High,2) & LowerShadowShort;
cs2 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2) & LowerShadowShort;
cs3 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2) & LowerShadowShort;
cs4 = ~White & ~UpperShadowVeryShort;
cs5 = White & CandleRelativePosition(TimeTable.Open,1,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.High,2);
bull{18} = indices(cs1(1:observer_-4) & cs2(2:observer_-3) & cs3(3:observer_-2) & ...
    cs4(4:observer_-1) & cs5(5:observer_))+4;

% Long Legged Doji
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Required
% Prior Trend  : Bearish (Bullish)
% Sticks       : 1
% - 1st: very short body, long upper or lower shadow
cs1 = BodyVeryShort & ShadowLong;
bull{19} = indices(cs1);
cs1 = BodyVeryShort & ShadowLong;
bear{20} = indices(cs1);

% Matching TimeTable.Low
% Direction    : Bullish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 2
% - 1st: black
% - 2nd: black, close near close of 1st
cs1 = ~White;
cs2 = ~White & CandleRelativePosition(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bull{20} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Meeting Lines
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white)
% - 2nd: white (black), long body, close near close of 1st
cs1 = ~White;
cs2 = White & BodyLong & CandleRelativePosition(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bull{21} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White;
cs2 = ~White & BodyLong & CandleRelativePosition(TimeTable.Close,TimeTable.High,(TimeTable.Open+TimeTable.Close)/2,2);
bear{21} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Stick Sandwich
% Direction    : Bullish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 3
% - 1st: black, very short lower shadow
% - 2nd: white, low greater than 1st close
% - 3rd: black, very short lower shadow, close near 1st close
cs1 = ~White & LowerShadowVeryShort;
cs2 = White & CandleRelativePosition(TimeTable.Low,1,TimeTable.Close,2);
cs3 = ~White & LowerShadowVeryShort & CandleRelativePosition(TimeTable.Close,(TimeTable.Open+TimeTable.Low)/2,TimeTable.Low,3);
bull{22} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Three Stars In The South
% Direction    : Bullish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 3
% - 1st: black, long, long lower shadow
% - 2nd: black, body smaller than prior, opens between 1st high and close
% - 3rd: black, very short shadows, engulfed by 2nd shadow
cs1 = ~White & BodyLong & LowerShadowLong;
cs2 = ~White & CandleRelativePosition(Body,2,Body,2) & CandleRelativePosition(TimeTable.Open,TimeTable.High,TimeTable.Close,2);
cs3 = ~White & ShadowVeryShort & CandleRelativePosition(TimeTable.High,2,TimeTable.High,2) & CandleRelativePosition(TimeTable.Low,1,TimeTable.Low,2);
bull{23} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Tri Star
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish (Bullish)
% Sticks       : 3
% - 1st: very short body
% - 2nd: very short body, downside (upside) body gap with 1st
% - 3rd: very short body, upside (downside) body gap with 2nd
cs1 = BodyVeryShort;
cs2 = BodyVeryShort & CandleRelativePosition(Top,2,Bottom,2);
cs3 = BodyVeryShort & CandleRelativePosition(Bottom,1,Top,2);
bull{24} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = BodyVeryShort;
cs2 = BodyVeryShort & CandleRelativePosition(Bottom,1,Top,2);
cs3 = BodyVeryShort & CandleRelativePosition(Top,2,Bottom,2);
bear{22} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Two Crows
% Direction    : Bearish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bullish
% Sticks       : 3
% - 1st: white, long
% - 2nd: black, not very short, body gap
% - 3rd: black, opens within 2nd, closes within 1st
cs1 = White & BodyLong;
cs2 = ~White & ~BodyVeryShort & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Open,TimeTable.Open,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bear{23} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Unique 3 River Bottom
% Direction    : Bullish
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 3
% - 1st: black, long
% - 2nd: black, short body, low is lower than 1st low
% - 3rd: white, short body, open higher than 2nd low, close lower than 2nd
% open
cs1 = ~White & BodyLong;
cs2 = ~White & BodyShort & CandleRelativePosition(TimeTable.Low,2,TimeTable.Low,2);
cs3 = White & BodyShort & CandleRelativePosition(TimeTable.Open,1,TimeTable.Low,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Open,2);
bull{25} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

%% Bullish (Bearish) Reversal TimeTable.Low Reliability

% Belt Hold
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : Bearish (Bullish)
% Sticks       : 1
% - 1st: white (black), long, very short lower (upper) shadow
cs1 = White & BodyLong & LowerShadowVeryShort;
bull{26} = indices(cs1);
cs1 = ~White & BodyLong & UpperShadowVeryShort;
bear{24} = indices(cs1);

% Hammer (Hanging Man)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : Bearish (Bullish)
% Sticks       : 1
% - 1st: short body, very short upper shadow, very long lower shadow
cs1 = BodyShort & UpperShadowVeryShort & LowerShadowVeryLong;
bull{27} = indices(cs1);
cs1 = BodyShort & UpperShadowVeryShort & LowerShadowVeryLong;
bear{25} = indices(cs1);

% Harami
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.Low
% Confirmation : Recommended
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white), long body
% - 2nd: white (black), short body, body engulfed by 1st body
cs1 = ~White & BodyLong;
cs2 = White & BodyShort & CandleRelativePosition(TimeTable.Close,2,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2);
bull{28} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White & BodyLong;
cs2 = ~White & BodyShort & CandleRelativePosition(TimeTable.Close,1,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2);
bear{26} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Inverted Hammer (Shooting Star)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : Bearish (Bullish)
% Sticks       : 2
% - 1st: black (white)
% - 2nd: short body, long upper shadow, very short lower shadow, downside
% (upside) body gap with 1st
cs1 = ~White;
cs2 = BodyShort & UpperShadowLong & LowerShadowVeryShort & CandleRelativePosition(Top,2,TimeTable.Close,2);
bull{29} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White;
cs2 = BodyShort & UpperShadowLong & LowerShadowVeryShort & CandleRelativePosition(Bottom,1,TimeTable.Close,2);
bear{27} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

%% Bullish (Bearish) Continuation TimeTable.High Reliability

% Mat Hold
% Direction    : Bullish
% Type         : Continuation
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bullish
% Sticks       : 5
% - 1st: white, long body
% - 2nd: black, short body, upside body gap with 1st
% - 3rd: short body, top is less than high of 2nd and bottom is greater
% than low of 1st
% - 4th: short body, top is less than high of 3rd and bottom is greater
% than low of 1st
% - 5th: white, opens above bottom of 4th, closes higher than high of all
cs1 = White & BodyLong;
cs2 = ~White & BodyShort & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
cs3 = BodyShort & CandleRelativePosition(Top,2,TimeTable.High,2) & CandleRelativePosition(Bottom,1,TimeTable.Low,3);
cs4 = BodyShort & CandleRelativePosition(Top,2,TimeTable.High,2) & CandleRelativePosition(Bottom,1,TimeTable.Low,4);
cs5 = White & CandleRelativePosition(TimeTable.Open,1,Bottom,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.High,2) & ...
    CandleRelativePosition(TimeTable.Close,1,TimeTable.High,3) & CandleRelativePosition(TimeTable.Close,1,TimeTable.High,4) & CandleRelativePosition(TimeTable.Close,1,TimeTable.High,5);
bull{30} = indices(cs1(1:observer_-4) & cs2(2:observer_-3) & cs3(3:observer_-2) & ...
    cs4(4:observer_-1) & cs5(5:observer_))+4;

% Rising Three Methods (Falling Three Methods)
% Direction    : Bullish (Bearish)
% Type         : Continuation
% Reliability  : TimeTable.High
% Confirmation : Suggested
% Prior Trend  : Bullish (Bearish)
% Sticks       : 5
% - 1st: white (black), long body
% - 2nd: short body, bottom (top) in body of 1st
% - 3rd: short body, bottom (top) lower (higher) than bottom (top) of 2nd
% - 4th: short body, bottom (top) lower (higher) than bottom (top) of 3rd
% - 5th: white (black), opens above (below) bottom (top) of 4th, closes
% higher (lower) than close of 1st
cs1 = White & BodyLong;
cs2 = BodyShort & CandleRelativePosition(Bottom,TimeTable.Close,TimeTable.Open,2);
cs3 = BodyShort & CandleRelativePosition(Bottom,2,Bottom,2);
cs4 = BodyShort & CandleRelativePosition(Bottom,2,Bottom,2);
cs5 = White & CandleRelativePosition(TimeTable.Open,1,Bottom,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,5);
bull{31} = indices(cs1(1:observer_-4) & cs2(2:observer_-3) & cs3(3:observer_-2) & ...
    cs4(4:observer_-1) & cs5(5:observer_))+4;
cs1 = ~White & BodyLong;
cs2 = BodyShort & CandleRelativePosition(Top,TimeTable.Open,TimeTable.Close,2);
cs3 = BodyShort & CandleRelativePosition(Top,1,Top,2);
cs4 = BodyShort & CandleRelativePosition(Top,1,Top,2);
cs5 = ~White & CandleRelativePosition(TimeTable.Open,2,Top,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,5);
bear{28} = indices(cs1(1:observer_-4) & cs2(2:observer_-3) & cs3(3:observer_-2) & ...
    cs4(4:observer_-1) & cs5(5:observer_))+4;

%% Bullish (Bearish) Continuation Moderate Reliability

% In Neck
% Direction    : Bearish
% Type         : Continuation
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 2
% - 1st: black, long body
% - 2nd: white, open below low of 1st, close near close of 1st
cs1 = ~White & BodyLong;
cs2 = White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Low,2) & CandleRelativePosition(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bear{31} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% On Neck
% Direction    : Bearish
% Type         : Continuation
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bearish
% Sticks       : 2
% - 1st: black, long body
% - 2nd: white, open below 1st low, close near 1st low
cs1 = ~White & BodyLong;
cs2 = White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Low,2) & CandleRelativePosition(TimeTable.Close,TimeTable.Close,TimeTable.Low-(TimeTable.Close-TimeTable.Low),2);
bear{32} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Side-by-Side White Lines
% Direction    : Bullish (Bearish)
% Type         : Continuation
% Reliability  : Moderate
% Confirmation : Recommended
% Prior Trend  : Bullish (Bearish)
% Sticks       : 3
% - 1st: white (black)
% - 2nd: white, upside (downside) body gap with 1st
% - 3rd: white, open near 2nd open, close near 2nd close
cs1 = White;
cs2 = White & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Open,(TimeTable.Close+TimeTable.Open)/2,TimeTable.Low,2) & CandleRelativePosition(TimeTable.Close,TimeTable.High,(TimeTable.Close+TimeTable.Open)/2,2);
bull{32} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = ~White;
cs2 = White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Open,(TimeTable.Close+TimeTable.Open)/2,TimeTable.Low,2) & CandleRelativePosition(TimeTable.Close,TimeTable.High,(TimeTable.Close+TimeTable.Open)/2,2);
bear{33} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Upside Gap Three Methods (Downside Gap Three Methods)
% Direction    : Bullish (Bearish)
% Type         : Continuation
% Reliability  : Moderate
% Confirmation : Suggested
% Prior Trend  : Bullish (Bullish)
% Sticks       : 3
% - 1st: white (black), long body
% - 2nd: white (black), long body, upside (downside) body gap with 1st
% - 3rd: black (white), opens within body of 2nd, closes in body of 1st
cs1 = White & BodyLong;
cs2 = White & BodyLong & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Open,TimeTable.Close,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bull{33} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = ~White & BodyLong;
cs2 = ~White & BodyLong & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Open,TimeTable.Open,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,TimeTable.Open,TimeTable.Close,3);
bear{29} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

% Upside Tasuki Gap (Downside Tasuki Gap)
% Direction    : Bullish (Bearish)
% Type         : Continuation
% Reliability  : Moderate
% Confirmation : Recommended
% Prior Trend  : Bullish (Bearish)
% Sticks       : 3
% - 1st: white (black)
% - 2nd: white (black), upside (downside) body gap with 1st
% - 3rd: black (white), opens in body of 2nd, closes in gap of 1st and 2nd
cs1 = White;
cs2 = White & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Open,TimeTable.Close,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,3);
bull{34} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;
cs1 = ~White;
cs2 = ~White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Open,TimeTable.Open,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Open,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,3);
bear{30} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

%% Bullish (Bearish) Continuation TimeTable.Low Reliability

% Separating Lines
% Direction    : Bullish (Bearish)
% Type         : Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : Bullish (Bearish)
% Sticks       : 2
% - 1st: black (white)
% - 2nd: white (black), long, very short lower (upper) shadow, open near
% open of 1st
cs1 = ~White;
cs2 = White & BodyLong & LowerShadowVeryShort & CandleRelativePosition(TimeTable.Open,TimeTable.High,(TimeTable.Open+TimeTable.Close)/2,2);
bull{35} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;
cs1 = White;
cs2 = ~White & BodyLong & UpperShadowVeryShort & CandleRelativePosition(TimeTable.Open,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bear{34} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

% Three Line Strike
% Direction    : Bullish (Bearish)
% Type         : Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : Bullish (Bearish)
% Sticks       : 4
% - 1st: white (black)
% - 2nd: white (black), higher (lower) close than close of 1st
% - 3rd: white (black), higher (lower) close than close of 2nd
% - 4th: black (white), opens above (below) close of 3rd, closes below
% (above) open of 1st
cs1 = White;
cs2 = White & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
cs3 = White & CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
cs4 = ~White & CandleRelativePosition(TimeTable.Open,1,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,2,TimeTable.Open,4);
bull{36} = indices(cs1(1:observer_-3) & cs2(2:observer_-2) & cs3(3:observer_-1) & cs4(4:observer_))+3;
cs1 = ~White;
cs2 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2);
cs3 = ~White & CandleRelativePosition(TimeTable.Close,2,TimeTable.Close,2);
cs4 = White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Close,2) & CandleRelativePosition(TimeTable.Close,1,TimeTable.Open,4);
bear{35} = indices(cs1(1:observer_-3) & cs2(2:observer_-2) & cs3(3:observer_-1) & cs4(4:observer_))+3;

% Thrusting
% Direction    : Bearish
% Type         : Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : Bearish
% Sticks       : 2
% - 1st: black, long body
% - 2nd: white, open below 1st low, close in body of 1st under midpoint
cs1 = ~White & BodyLong;
cs2 = White & CandleRelativePosition(TimeTable.Open,2,TimeTable.Low,2) & CandleRelativePosition(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Close,2);
bear{36} = indices(cs1(1:observer_-1) & cs2(2:observer_))+1;

%% Bullish (Bearish) Reversal/Continuation TimeTable.Low Reliability

% Closing Marubozo
% Direction    : Bullish (Bearish)
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: white (black), long, very short upper (lower) shadow
cs1 = White & BodyLong & UpperShadowVeryShort;
bull{37} = indices(cs1);
cs1 = ~White & BodyLong & LowerShadowVeryShort;
bear{37} = indices(cs1);

% Long Line
% Direction    : Bullish (Bearish)
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: white (black), long body
cs1 = White & BodyLong;
bull{38} = indices(cs1);
cs1 = ~White & BodyLong;
bear{38} = indices(cs1);

% Marubozu
% Direction    : Bullish (Bearish)
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: white (black), very short upper shadow, very short lower shadow
cs1 = White & UpperShadowVeryShort & LowerShadowVeryShort;
bull{39} = indices(cs1);
cs1 = ~White & UpperShadowVeryShort & LowerShadowVeryShort;
bear{39} = indices(cs1);

% Opening Marubozu
% Direction    : Bullish (Bearish)
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: white (black), long body, very short lower (upper) shadow
cs1 = White & BodyLong & LowerShadowVeryShort;
bull{40} = indices(cs1);
cs1 = ~White & BodyLong & UpperShadowVeryShort;
bear{40} = indices(cs1);

%% Neutral Reversal Moderate Reliability

% TimeTable.High Wave
% Direction    : Neutral
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Recommended
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, very long upper or lower shadow
cs1 = BodyShort & ShadowVeryLong;
neutral{1} = indices(cs1);

% Inverted Takuri/Umbrella
% Takuri/Umbrella
% Direction    : Neutral
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, very short lower shadow, long upper shadow
cs1 = BodyShort & LowerShadowVeryShort & UpperShadowLong;
neutral{2} = indices(cs1);

% Takuri/Umbrella
% Direction    : Neutral
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, very short upper shadow, long lower shadow
cs1 = BodyShort & UpperShadowVeryShort & LowerShadowLong;
neutral{3} = indices(cs1);

%% Neutral Reversal/Continuation TimeTable.Low Reliability

% Doji
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: very short body
cs1 = BodyVeryShort;
neutral{4} = indices(cs1);

% Four Price Doji
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: very short body, very short upper shadow, very short lower shadow
cs1 = BodyVeryShort & UpperShadowVeryShort & LowerShadowVeryShort;
neutral{5} = indices(cs1);

% Normal Line
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: not short body, not long body, not long upper shadow, not long
% lower shadow
cs1 = ~BodyShort & ~BodyLong & ~UpperShadowLong & ~LowerShadowLong;
neutral{6} = indices(cs1);

% Rickshaw Man
% Direction    : Neutral
% Type         : Continuation/Reversal
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: very short body, long upper shaddow, long lower shadow, body near
% center
cs1 = BodyVeryShort & UpperShadowLong & LowerShadowLong & ...
    CandleRelativePosition(UpperShadow,max(UpperShadow,LowerShadow),(UpperShadow+LowerShadow)/3,1);
neutral{7} = indices(cs1);

% Short Line
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, short upper shadow, short lower shadow
cs1 = BodyShort & UpperShadowShort & LowerShadowShort;
neutral{8} = indices(cs1);

% Spinning Top
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, long upper shadow, long lower shadow
cs1 = BodyShort & UpperShadowLong & LowerShadowLong;
neutral{9} = indices(cs1);

% Stalled Pattern
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : Moderate
% Confirmation : Required
% Prior Trend  : Bullish
% Sticks       : 3
% - 1st: white, long
% - 2nd: white, long, very short upper shadow, open near 1st body, close
% higher than 1st close
% - 3rd: white, short
cs1 = White & BodyLong;
cs2 = White & BodyLong & UpperShadowVeryShort & CandleRelativePosition(TimeTable.Open,TimeTable.High,TimeTable.Low,2) & ...
    CandleRelativePosition(TimeTable.Close,1,TimeTable.Close,2);
cs3 = White & BodyShort;
neutral{10} = indices(cs1(1:observer_-2) & cs2(2:observer_-1) & cs3(3:observer_))+2;

end
