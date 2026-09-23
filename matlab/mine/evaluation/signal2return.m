function rtn=signal2return(timetable,signal)
if (size(timetable.Date,1)<2)
    rtn=100;
    return;
end
tempret=[tick2ret(timetable.Open);0].*signal;
rtn=ret2tick(tempret(2:end));

end