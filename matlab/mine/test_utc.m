datesref=datetime('2020-01-01 13:34:00','TimeZone','America/New_York')-days(1:30:90)
dates=datetime('2020-01-01 13:34:00')-days(1:30:90)
[dt,~] = tzoffset(datesref)

dates2=datesref+dt


 Date=datetime([1598982142,1606848142],'ConvertFrom','posixtime','TimeZone','America/New_York')