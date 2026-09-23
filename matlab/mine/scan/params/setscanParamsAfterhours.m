scanid=1;tempcnt=1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="afterHoursChangePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="1";tempcnt=tempcnt+1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="afterHoursChangePercBelow";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="15";tempcnt=tempcnt+1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="lastVsEMAChangeRatio20Above";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0";tempcnt=tempcnt+1;
scantemp{scanid}.ScanCode='TOP_AFTER_HOURS_PERC_GAIN';

scanid=2;tempcnt=1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="afterHoursChangePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="1";tempcnt=tempcnt+1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="changePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0";tempcnt=tempcnt+1;
scantemp{scanid}.ScanCode='HOT_BY_PRICE';

scanid=3;tempcnt=1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="afterHoursChangePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0.5";tempcnt=tempcnt+1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="changePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0.5";tempcnt=tempcnt+1;
sscantemp{scanid}.ScanCode='HOT_BY_VOLUME';

scanid=4;tempcnt=1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="afterHoursChangePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0.5";tempcnt=tempcnt+1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="changePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0.5";tempcnt=tempcnt+1;
scantemp{scanid}.ScanCode='TOP_TRADE_RATE';

scanid=5;tempcnt=1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="afterHoursChangePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0.5";tempcnt=tempcnt+1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="changePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="0.5";tempcnt=tempcnt+1;
scantemp{scanid}.ScanCode='TOP_VOLUME_RATE';

scanid=6;tempcnt=1;
scantemp{scanid}.scanSecondaryParams{tempcnt}.key="afterHoursChangePercAbove";
scantemp{scanid}.scanSecondaryParams{tempcnt}.value="10";tempcnt=tempcnt+1;
scantemp{scanid}.ScanCode='TOP_AFTER_HOURS_PERC_GAIN';


