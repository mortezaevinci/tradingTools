function table1 = stocktable_addnum(table1,num)
    table1.Close=table1.Close+num;
    table1.Open=table1.Open+num;
    table1.High=table1.High+num;
    table1.Low=table1.Low+num;
end

