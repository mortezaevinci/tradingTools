function [bull, bear, neutral] = candlesticksCount(TimeTable)
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


% Number of observations
observ  = size(TimeTable.Open,1);
indices = (1:observ)';

% Format Output
bear    = zeros(size(TimeTable,1),1);
bull    = zeros(size(TimeTable,1),1);
neutral = zeros(size(TimeTable,1),1);

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
BodyLong             = CRA(Body,1,BodyLongDef,Body);
% BodyVeryLong         = CRA(Body,1,BodyVeryLongDef,Body);
BodyShort            = CRA(Body,2,BodyShortDef,Body);
BodyVeryShort        = CRA(Body,2,BodyVeryShortDef,HighLow);
ShadowLong           = CRA(FullShadow,1,ShadowLongDef,Body);
ShadowVeryLong       = CRA(FullShadow,1,ShadowVeryLongDef,Body);
% ShadowShort          = CRA(FullShadow,2,ShadowShortDef,Body);
ShadowVeryShort      = CRA(FullShadow,2,ShadowVeryShortDef,Body);
UpperShadowLong      = CRA(UpperShadow,1,UpperShadowLongDef,Body);
% UpperShadowVeryLong  = CRA(UpperShadow,1,UpperShadowVeryLongDef,Body);
UpperShadowShort     = CRA(UpperShadow,2,UpperShadowShortDef,Body);
UpperShadowVeryShort = CRA(UpperShadow,2,UpperShadowVeryShortDef,Body);
LowerShadowLong      = CRA(LowerShadow,1,LowerShadowLongDef,Body);
LowerShadowVeryLong  = CRA(LowerShadow,1,LowerShadowVeryLongDef,Body);
LowerShadowShort     = CRA(LowerShadow,2,LowerShadowShortDef,Body);
LowerShadowVeryShort = CRA(LowerShadow,2,LowerShadowVeryShortDef,Body);

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
cs2 = BodyVeryShort & CRP(TimeTable.High,2,TimeTable.Low,2);
cs3 = White & ~BodyShort & CRP(TimeTable.Low,1,TimeTable.High,2) & CRP(TimeTable.Close,TimeTable.Open,TimeTable.Close,3);
bull = bull+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CRP(TimeTable.Low,1,TimeTable.High,2);
cs3 = ~White & ~BodyShort & CRP(TimeTable.High,2,TimeTable.Low,2) & CRP(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs3 = ~White & CRP(TimeTable.Close,2,TimeTable.Close,2) & CRP(TimeTable.High,1,TimeTable.Close,2);
cs4 = ~White & CRP(TimeTable.Open,1,TimeTable.High,2) & CRP(TimeTable.Close,2,TimeTable.Low,2);
bull = bull+  [0;0;0;(cs1(1:observ-3) & cs2(2:observ-2) & cs3(3:observ-1) & cs4(4:observ))];

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
cs2 = White & ShadowVeryShort & CRP(TimeTable.Low,1,TimeTable.High,2);
bull = bull+ [0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White & ShadowVeryShort;
cs2 = ~White & ShadowVeryShort & CRP(TimeTable.High,2,TimeTable.Low,2);
bear =bear+ [0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = BodyVeryShort & CRP(Top,2,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Close,TimeTable.Open,TimeTable.Close,3);
bull = bull+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CRP(Bottom,1,TimeTable.Close,2);
cs3 = ~White & CRP(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = BodyShort & CRP(Top,2,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Close,TimeTable.Open,TimeTable.Close,3);
bull = bull+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = White & BodyLong;
cs2 = BodyShort & CRP(Bottom,1,TimeTable.Open,2);
cs3 = ~White & CRP(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = White & BodyLong & CRP(TimeTable.Open,2,TimeTable.Low,2) & CRP(TimeTable.Close,TimeTable.Open,(TimeTable.Open+TimeTable.Close)/2,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White & BodyLong;
cs2 = ~White & BodyLong & CRP(TimeTable.Open,2,TimeTable.High,2) & CRP(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Open,2);
bear =bear+ [0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = White & BodyShort & CRP(TimeTable.Close,2,TimeTable.Open,2) & CRP(TimeTable.Open,1,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Close,1,TimeTable.Close,2);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = White & BodyLong;
cs2 = ~White & BodyShort & CRP(TimeTable.Open,2,TimeTable.Close,2) & CRP(TimeTable.Close,1,TimeTable.Open,2);
cs3 = ~White & CRP(TimeTable.Close,2,TimeTable.Close,2);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = White & CRP(TimeTable.Open,2,TimeTable.Close,2) & CRP(TimeTable.Close,1,TimeTable.Open,2);
cs3 = White & CRP(TimeTable.Close,1,TimeTable.Close,2);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = White;
cs2 = ~White & CRP(TimeTable.Open,1,TimeTable.Close,2) & CRP(TimeTable.Close,2,TimeTable.Open,2);
cs3 = ~White & CRP(TimeTable.Close,2,TimeTable.Close,2);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = White & ~BodyShort & CRP(TimeTable.Close,1,TimeTable.Close,2) & CRP(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
cs3 = White & ~BodyShort & CRP(TimeTable.Close,1,TimeTable.Close,2) & CRP(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = ~White & ~BodyShort;
cs2 = ~White & ~BodyShort & CRP(TimeTable.Close,2,TimeTable.Close,2) & CRP(TimeTable.Open,TimeTable.Open,TimeTable.Close,2);
cs3 = ~White & ~BodyShort & CRP(TimeTable.Close,2,TimeTable.Close,2) & CRP(TimeTable.Open,TimeTable.Open,TimeTable.Close,2);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = ~White & BodyShort & CRP(TimeTable.Close,1,TimeTable.Close,2);
cs3 = ~White & CRP(TimeTable.Open,1,TimeTable.Open,2) & CRP(TimeTable.Close,2,TimeTable.Close,2) & CRP(TimeTable.Close,1,TimeTable.Close,3);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = White & CRP(TimeTable.Close,1,TimeTable.Close,2) & CRP(Body,2,Body,2) & ~UpperShadowVeryShort & ...
    CRP(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
cs3 = White & CRP(TimeTable.Close,1,TimeTable.Close,2) & CRP(Body,2,Body,2) & ~UpperShadowShort & ...
    CRP(TimeTable.Open,TimeTable.Close,TimeTable.Open,2);
bear =bear+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = ~White & CRP(TimeTable.Open,2,TimeTable.Close,2);
cs3 = CRP(Top,2,TimeTable.Open,2) & CRP(Bottom,2,TimeTable.Close,2);
cs4 =  ~White & CRP(TimeTable.Open,2,Top,2) & CRP(TimeTable.Close,2,Bottom,2);
cs5 = White & CRP(TimeTable.Close,1,TimeTable.High,4);
bull = bull+[0;0;0;0;(cs1(1:observ-4) & cs2(2:observ-3) & cs3(3:observ-2) & ...
    cs4(4:observ-1) & cs5(5:observ))];
cs1 = White & BodyLong;
cs2 = White & CRP(TimeTable.Open,1,TimeTable.Close,2);
cs3 = CRP(Top,1,TimeTable.Close,2) & CRP(Bottom,1,TimeTable.Open,2);
cs4 = White & CRP(TimeTable.Open,1,Bottom,2) & CRP(TimeTable.Close,1,Top,2);
cs5 = ~White & CRP(TimeTable.Close,2,TimeTable.Low,4);
bear =bear+ [0;0;0;0;(cs1(1:observ-4) & cs2(2:observ-3) & cs3(3:observ-2) & ...
    cs4(4:observ-1) & cs5(5:observ))];

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
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White & BodyLong;
cs2 = ~White & BodyLong;
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs3 = White & BodyShort & CRP(TimeTable.Open,1,TimeTable.Close,2);
bear =bear+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = BodyVeryShort & CRP(Top,2,TimeTable.Close,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CRP(Bottom,1,TimeTable.Close,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
bull = bull+(cs1);
cs1 = BodyVeryShort & UpperShadowVeryShort & LowerShadowVeryLong;
bear =bear+(cs1);

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
cs2 = White & CRP(TimeTable.Open,2,TimeTable.Close,2) & CRP(TimeTable.Close,1,TimeTable.Open,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White;
cs2 = ~White & CRP(TimeTable.Open,2,TimeTable.Open,2) & CRP(TimeTable.Close,1,TimeTable.Close,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = BodyVeryShort & LowerShadowVeryShort & UpperShadowLong & CRP(Bottom,1,TimeTable.Close,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White;
cs2 = BodyVeryShort & LowerShadowVeryShort & UpperShadowLong & CRP(Bottom,1,TimeTable.Close,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = BodyVeryShort & CRP(Top,2,TimeTable.Open,2) & CRP(Bottom,1,TimeTable.Close,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White & BodyLong;
cs2 = BodyVeryShort & CRP(Top,2,TimeTable.Close,2) & CRP(Bottom,1,TimeTable.Open,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = ~White & BodyShort & CRP(TimeTable.Open,2,TimeTable.Open,2) & CRP(TimeTable.Close,1,TimeTable.Close,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = ~White & LowerShadowVeryShort & CRP(TimeTable.Open,2,(TimeTable.Open+TimeTable.Close)/2,2);
cs3 = ~White & LowerShadowVeryShort & CRP(TimeTable.Open,2,(TimeTable.Open+TimeTable.Close)/2,2);
bear =bear+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs1 = ~White & CRP(TimeTable.Close,2,TimeTable.High,2) & LowerShadowShort;
cs2 = ~White & CRP(TimeTable.Close,2,TimeTable.Close,2) & LowerShadowShort;
cs3 = ~White & CRP(TimeTable.Close,2,TimeTable.Close,2) & LowerShadowShort;
cs4 = ~White & ~UpperShadowVeryShort;
cs5 = White & CRP(TimeTable.Open,1,TimeTable.Open,2) & CRP(TimeTable.Close,1,TimeTable.High,2);
bull = bull+[0;0;0;0;(cs1(1:observ-4) & cs2(2:observ-3) & cs3(3:observ-2) & ...
    cs4(4:observ-1) & cs5(5:observ))];

% Long Legged Doji
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : Required
% Prior Trend  : Bearish (Bullish)
% Sticks       : 1
% - 1st: very short body, long upper or lower shadow
cs1 = BodyVeryShort & ShadowLong;
bull = bull+(cs1);
cs1 = BodyVeryShort & ShadowLong;
bear =bear+(cs1);

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
cs2 = ~White & CRP(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = White & BodyLong & CRP(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White;
cs2 = ~White & BodyLong & CRP(TimeTable.Close,TimeTable.High,(TimeTable.Open+TimeTable.Close)/2,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = White & CRP(TimeTable.Low,1,TimeTable.Close,2);
cs3 = ~White & LowerShadowVeryShort & CRP(TimeTable.Close,(TimeTable.Open+TimeTable.Low)/2,TimeTable.Low,3);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = ~White & CRP(Body,2,Body,2) & CRP(TimeTable.Open,TimeTable.High,TimeTable.Close,2);
cs3 = ~White & ShadowVeryShort & CRP(TimeTable.High,2,TimeTable.High,2) & CRP(TimeTable.Low,1,TimeTable.Low,2);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = BodyVeryShort & CRP(Top,2,Bottom,2);
cs3 = BodyVeryShort & CRP(Bottom,1,Top,2);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = BodyVeryShort;
cs2 = BodyVeryShort & CRP(Bottom,1,Top,2);
cs3 = BodyVeryShort & CRP(Top,2,Bottom,2);
bear =bear+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = ~White & ~BodyVeryShort & CRP(TimeTable.Close,1,TimeTable.Close,2);
cs3 = ~White & CRP(TimeTable.Open,TimeTable.Open,TimeTable.Close,2) & CRP(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bear =bear+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = ~White & BodyShort & CRP(TimeTable.Low,2,TimeTable.Low,2);
cs3 = White & BodyShort & CRP(TimeTable.Open,1,TimeTable.Low,2) & CRP(TimeTable.Close,2,TimeTable.Open,2);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
bull = bull+(cs1);
cs1 = ~White & BodyLong & UpperShadowVeryShort;
bear =bear+(cs1);

% Hammer (Hanging Man)
% Direction    : Bullish (Bearish)
% Type         : Reversal
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : Bearish (Bullish)
% Sticks       : 1
% - 1st: short body, very short upper shadow, very long lower shadow
cs1 = BodyShort & UpperShadowVeryShort & LowerShadowVeryLong;
bull = bull+(cs1);
cs1 = BodyShort & UpperShadowVeryShort & LowerShadowVeryLong;
bear =bear+(cs1);

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
cs2 = White & BodyShort & CRP(TimeTable.Close,2,TimeTable.Open,2) & CRP(TimeTable.Open,1,TimeTable.Close,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White & BodyLong;
cs2 = ~White & BodyShort & CRP(TimeTable.Close,1,TimeTable.Open,2) & CRP(TimeTable.Open,2,TimeTable.Close,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = BodyShort & UpperShadowLong & LowerShadowVeryShort & CRP(Top,2,TimeTable.Close,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White;
cs2 = BodyShort & UpperShadowLong & LowerShadowVeryShort & CRP(Bottom,1,TimeTable.Close,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = ~White & BodyShort & CRP(TimeTable.Close,1,TimeTable.Close,2);
cs3 = BodyShort & CRP(Top,2,TimeTable.High,2) & CRP(Bottom,1,TimeTable.Low,3);
cs4 = BodyShort & CRP(Top,2,TimeTable.High,2) & CRP(Bottom,1,TimeTable.Low,4);
cs5 = White & CRP(TimeTable.Open,1,Bottom,2) & CRP(TimeTable.Close,1,TimeTable.High,2) & ...
    CRP(TimeTable.Close,1,TimeTable.High,3) & CRP(TimeTable.Close,1,TimeTable.High,4) & CRP(TimeTable.Close,1,TimeTable.High,5);
bull = bull+[0;0;0;0;(cs1(1:observ-4) & cs2(2:observ-3) & cs3(3:observ-2) & ...
    cs4(4:observ-1) & cs5(5:observ))];

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
cs2 = BodyShort & CRP(Bottom,TimeTable.Close,TimeTable.Open,2);
cs3 = BodyShort & CRP(Bottom,2,Bottom,2);
cs4 = BodyShort & CRP(Bottom,2,Bottom,2);
cs5 = White & CRP(TimeTable.Open,1,Bottom,2) & CRP(TimeTable.Close,1,TimeTable.Close,5);
bull = bull+[0;0;0;0;(cs1(1:observ-4) & cs2(2:observ-3) & cs3(3:observ-2) & ...
    cs4(4:observ-1) & cs5(5:observ))];
cs1 = ~White & BodyLong;
cs2 = BodyShort & CRP(Top,TimeTable.Open,TimeTable.Close,2);
cs3 = BodyShort & CRP(Top,1,Top,2);
cs4 = BodyShort & CRP(Top,1,Top,2);
cs5 = ~White & CRP(TimeTable.Open,2,Top,2) & CRP(TimeTable.Close,2,TimeTable.Close,5);
bear =bear+[0;0;0;0;(cs1(1:observ-4) & cs2(2:observ-3) & cs3(3:observ-2) & ...
    cs4(4:observ-1) & cs5(5:observ))];

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
cs2 = White & CRP(TimeTable.Open,2,TimeTable.Low,2) & CRP(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = White & CRP(TimeTable.Open,2,TimeTable.Low,2) & CRP(TimeTable.Close,TimeTable.Close,TimeTable.Low-(TimeTable.Close-TimeTable.Low),2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = White & CRP(TimeTable.Open,1,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Open,(TimeTable.Close+TimeTable.Open)/2,TimeTable.Low,2) & CRP(TimeTable.Close,TimeTable.High,(TimeTable.Close+TimeTable.Open)/2,2);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = ~White;
cs2 = White & CRP(TimeTable.Open,2,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Open,(TimeTable.Close+TimeTable.Open)/2,TimeTable.Low,2) & CRP(TimeTable.Close,TimeTable.High,(TimeTable.Close+TimeTable.Open)/2,2);
bear =bear+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = White & BodyLong & CRP(TimeTable.Open,1,TimeTable.Close,2);
cs3 = ~White & CRP(TimeTable.Open,TimeTable.Close,TimeTable.Open,2) & CRP(TimeTable.Close,TimeTable.Close,TimeTable.Open,3);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = ~White & BodyLong;
cs2 = ~White & BodyLong & CRP(TimeTable.Open,2,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Open,TimeTable.Open,TimeTable.Close,2) & CRP(TimeTable.Close,TimeTable.Open,TimeTable.Close,3);
bear =bear+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = White & CRP(TimeTable.Open,1,TimeTable.Close,2);
cs3 = ~White & CRP(TimeTable.Open,TimeTable.Close,TimeTable.Open,2) & CRP(TimeTable.Close,2,TimeTable.Open,2) & CRP(TimeTable.Close,1,TimeTable.Close,3);
bull = bull+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];
cs1 = ~White;
cs2 = ~White & CRP(TimeTable.Open,2,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Open,TimeTable.Open,TimeTable.Close,2) & CRP(TimeTable.Close,1,TimeTable.Open,2) & CRP(TimeTable.Close,2,TimeTable.Close,3);
bear =bear+[0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

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
cs2 = White & BodyLong & LowerShadowVeryShort & CRP(TimeTable.Open,TimeTable.High,(TimeTable.Open+TimeTable.Close)/2,2);
bull = bull+[0;(cs1(1:observ-1) & cs2(2:observ))];
cs1 = White;
cs2 = ~White & BodyLong & UpperShadowVeryShort & CRP(TimeTable.Open,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Low,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
cs2 = White & CRP(TimeTable.Close,1,TimeTable.Close,2);
cs3 = White & CRP(TimeTable.Close,1,TimeTable.Close,2);
cs4 = ~White & CRP(TimeTable.Open,1,TimeTable.Close,2) & CRP(TimeTable.Close,2,TimeTable.Open,4);
bull = bull+[0;0;0;(cs1(1:observ-3) & cs2(2:observ-2) & cs3(3:observ-1) & cs4(4:observ))];
cs1 = ~White;
cs2 = ~White & CRP(TimeTable.Close,2,TimeTable.Close,2);
cs3 = ~White & CRP(TimeTable.Close,2,TimeTable.Close,2);
cs4 = White & CRP(TimeTable.Open,2,TimeTable.Close,2) & CRP(TimeTable.Close,1,TimeTable.Open,4);
bear =bear+[0;0;0;(cs1(1:observ-3) & cs2(2:observ-2) & cs3(3:observ-1) & cs4(4:observ))];

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
cs2 = White & CRP(TimeTable.Open,2,TimeTable.Low,2) & CRP(TimeTable.Close,(TimeTable.Open+TimeTable.Close)/2,TimeTable.Close,2);
bear =bear+[0;(cs1(1:observ-1) & cs2(2:observ))];

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
bull = bull+(cs1);
cs1 = ~White & BodyLong & LowerShadowVeryShort;
bear =bear+(cs1);

% Long Line
% Direction    : Bullish (Bearish)
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: white (black), long body
cs1 = White & BodyLong;
bull = bull+(cs1);
cs1 = ~White & BodyLong;
bear =bear+(cs1);

% Marubozu
% Direction    : Bullish (Bearish)
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: white (black), very short upper shadow, very short lower shadow
cs1 = White & UpperShadowVeryShort & LowerShadowVeryShort;
bull = bull+(cs1);
cs1 = ~White & UpperShadowVeryShort & LowerShadowVeryShort;
bear =bear+(cs1);

% Opening Marubozu
% Direction    : Bullish (Bearish)
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : Required
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: white (black), long body, very short lower (upper) shadow
cs1 = White & BodyLong & LowerShadowVeryShort;
bull = bull+(cs1);
cs1 = ~White & BodyLong & UpperShadowVeryShort;
bear =bear+(cs1);

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
neutral = neutral+(cs1);

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
neutral = neutral+(cs1);

% Takuri/Umbrella
% Direction    : Neutral
% Type         : Reversal
% Reliability  : Moderate
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, very short upper shadow, long lower shadow
cs1 = BodyShort & UpperShadowVeryShort & LowerShadowLong;
neutral = neutral+(cs1);

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
neutral = neutral+(cs1);

% Four Price Doji
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: very short body, very short upper shadow, very short lower shadow
cs1 = BodyVeryShort & UpperShadowVeryShort & LowerShadowVeryShort;
neutral = neutral+(cs1);

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
neutral = neutral+(cs1);

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
    CRP(UpperShadow,max(UpperShadow,LowerShadow),(UpperShadow+LowerShadow)/3,1);
neutral = neutral+(cs1);

% Short Line
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, short upper shadow, short lower shadow
cs1 = BodyShort & UpperShadowShort & LowerShadowShort;
neutral = neutral+(cs1);

% Spinning Top
% Direction    : Neutral
% Type         : Reversal/Continuation
% Reliability  : TimeTable.Low
% Confirmation : N/A
% Prior Trend  : N/A
% Sticks       : 1
% - 1st: short body, long upper shadow, long lower shadow
cs1 = BodyShort & UpperShadowLong & LowerShadowLong;
neutral = neutral+(cs1);

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
cs2 = White & BodyLong & UpperShadowVeryShort & CRP(TimeTable.Open,TimeTable.High,TimeTable.Low,2) & ...
    CRP(TimeTable.Close,1,TimeTable.Close,2);
cs3 = White & BodyShort;
neutral = neutral+ [0;0;(cs1(1:observ-2) & cs2(2:observ-1) & cs3(3:observ))];

function tf = CRA(part1,gtlt,def,part2)
    %CRA determines relative aspects of candle
    % 
    % Description
    %     CRA stands for Candle Relative Aspects
    % 
    % Sytax
    %     CRA(part1,gtlt,def,part2)
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
    %     tf = CRA(Body,1,BodyLongDef,Body);
    %     % Very Short Lower Shadow
    %     tf = CRA(LowerShadow,2,LowerShadowVeryShortDef,Body);
    %
    
    % Cumulative sum of end indices
    % Output looks like:
    % [1 16 31 46 61 76 91 ... ]
    temp_var1 = cumsum([1;(def(1)+1:observ)'-(1:observ-def(1))'+1]);
    % Vector of moving indices
    % Output looks like:
    % [1 2 3 4 5 2 3 4 5 6 3 4 5 6 7 4 5 6 7 8 ... ]
    temp_var2 = ones(temp_var1(observ-def(1)+1)-1,1);
    temp_var2(temp_var1(1:observ-def(1))) = 1-def(1);
    temp_var2(1) = 1;
    temp_var2 = cumsum(temp_var2);
    
    % Average size of part2
    if     def(1) > 0
        AvgSize = [nan(def(1),1); ...
            (sum(abs(part2(reshape(temp_var2,def(1)+1,observ-def(1)))))/def(1))'];
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

function tf = CRP(part1,gtlt,part2,num)
    %CRP compares relative position of candle
    % 
    % Description
    %     CRP stands for Candle Relative Position
    % 
    % Syntax
    %     CRP(part1,position,part2,num)
    %     CRP(part1,part2,part3,num)
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
    %     tf = CRP(Top,1,Bottom,2)
    %     % tf = Bottom(4:end) < Top(1:end-3)
    %     tf = CRP(Bottom,2,Top,4)
    %     % tf = Top(3:end) < TimeTable.High(1:end-2) & Top(3:end) > TimeTable.Low(1:end-2)
    %     tf = CRP(Top,TimeTable.High,TimeTable.Low,4)
    %
    
    if     gtlt == 1
        tf = [false(num-1,1); part1(num:observ) > part2(1:observ-num+1)];
    elseif gtlt == 2
        tf = [false(num-1,1); part1(num:observ) < part2(1:observ-num+1)];
    else
        tf = [false(num-1,1); part1(num:observ) >= part2(1:observ-num+1) & ...
            part1(num:observ) <= gtlt(1:observ-num+1)];
    end
    
end

end
