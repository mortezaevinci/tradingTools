function tt=genNanTimeTable(Date)
Open=nan(size(Date));
Close=Open;
High=Open;
Low=Open;
Volume=Open;

tt=timetable(Date,Open,High,Low,Close,Volume);


end