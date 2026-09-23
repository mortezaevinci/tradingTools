# Global Market Opens and Closes
# Vertical lines mark all open and closes
# Horizontal lines mark US, AUD opens and closes
# ThinkScript Chat Room Group 
# Added Close / Open Lines for US and AUD

declare hide_on_daily;

input Plot_Verticle_Line = yes;
input Show_US = yes;
input Show_London = yes;
input Show_Sydney = yes;
input Show_Asian = yes; #HINT Show_Asian: IMPORTANT, BE SURE to adjust for part of year where USA goes to Daylight Savings but Asia remains on Standard time

input osc_line=0940;
input flag_line=0950;

input US_Open = 0930;
input US_Close = 1600;
input GBP_Open = 0300;
input GBP_Close = 1130;
input AUD_Open = 1800;
input AUD_Close = 0000;
input JPY_Open = 1900; #HINT JPY_Open: IMPORTANT, BE SURE to adjust for part of year where USA goes to Daylight Savings but Asia remains on Standard time
input JPY_Close = 0100; #HINT JPT_Close: IMPORTANT, BE SURE to adjust for part of year where USA goes to Daylight Savings but Asia remains on Standard time
input US_Bond_Close = 1500;
input Metals_Futures_Close = 1700;

AddVerticalLine(secondsFromTime(osc_line)[1] < 0 && secondsFromTime(osc_line) >= 0 and
                  Plot_Verticle_Line and 
                  1, concat("", ""), Color.Gray, curve.POINTS);

AddVerticalLine(secondsFromTime(flag_line)[1] < 0 && secondsFromTime(flag_line) >= 0 and
                  Plot_Verticle_Line and 
                  1, concat("", ""), Color.Gray, curve.POINTS);

#US
  AddVerticalLine(secondsFromTime(US_Open)[1] < 0 && secondsFromTime(US_Open) >= 0 and
                  Plot_Verticle_Line and 
                  Show_US, concat("", ""), Color.Gray, curve.POINTS);
  AddVerticalLine(secondsFromTime(US_Close)[1] < 0 && secondsFromTime(US_Close) >= 0 and
                  Plot_Verticle_Line and 
                  Show_US, concat("", ""), Color.Gray, curve.POINTS);
#AUD
   def AUDopen = if secondsFromTime(AUD_Open)[1] < 0 && 
                    secondsFromTime(AUD_Open) >= 0 
                 then barnumber() 
                 else AUDopen[1];
   def DataAUDopenLine = if barnumber()-1 == AudOpen 
                         then if IsNaN(barnumber()) 
                              then HighestAll(open[1]) 
                              else open[1] 
                         else DataAUDopenLine[1];

  AddVerticalLine(secondsFromTime(AUD_Open)[1] < 0 && 
                  secondsFromTime(AUD_Open) >= 0 and 
                  Plot_Verticle_Line and 
                  Show_Sydney, concat("", " "), Color.Yellow, curve.POINTS);

   def AUDclose = if secondsFromTime(AUD_Close)[1] < 0 && 
                    secondsFromTime(AUD_Close) >= 0 
                  then barnumber() 
                  else AUDclose[1];
   def DataAUDcloseLine = if barnumber()-1 == Audclose 
                          then if IsNaN(barnumber()) 
                               then HighestAll(close[1]) 
                               else close[1] 
                          else DataAUDcloseLine[1];
AddVerticalLine(secondsFromTime(AUD_Close)[1]<0 && secondsFromTime(AUD_Close) >=0 and
                Plot_Verticle_Line and 
                Show_Sydney, concat("",""),Color.Gray, curve.POINTS);
# JPY
  AddVerticalLine(secondsFromTime(JPY_Open)[1] < 0 && 
                  secondsFromTime(JPY_Open) >= 0 and 
                  Plot_Verticle_Line and 
                  Show_Asian, concat("", ""), Color.Gray, curve.POINTS);

  AddVerticalLine(secondsFromTime(JPY_Close)[1] < 0 && 
                  secondsFromTime(JPY_Close) >= 0 and 
                  Plot_Verticle_Line and 
                  Show_Asian, concat("", ""), Color.Gray, curve.POINTS);
# GBP
  AddVerticalLine(secondsFromTime(GBP_Open)[1] < 0 && 
                  secondsFromTime(GBP_Open) >= 0 and 
                  Plot_Verticle_Line and 
                  Show_London, concat("", ""), Color.Gray, curve.POINTS);

  AddVerticalLine(secondsFromTime(GBP_Close)[1] < 0 && 
                  secondsFromTime(GBP_Close) >= 0 and 
                  Plot_Verticle_Line and 
                  Show_London, concat("", ""), Color.Gray, curve.POINTS);
# US Bond Close
  AddVerticalLine(secondsFromTime(US_Bond_Close)[1] < 0 && 
                  secondsFromTime(US_Bond_Close) >= 0 and 
                  Plot_Verticle_Line and 
                  Show_London, concat("", ""), Color.Gray, curve.POINTS);
# Metals Futures Close
  AddVerticalLine(secondsFromTime(Metals_Futures_Close)[1] < 0 && 
                  secondsFromTime(Metals_Futures_Close) >= 0 and 
                  Plot_Verticle_Line and 
                  Show_London, concat("", ""), Color.Gray, curve.POINTS);
# End Code
