function table1 = stocktable_sub(table1,table2)
    table1.Close=table1.Close-table2.Close;
    table1.Open=table1.Open-table2.Open;
    table1.High=table1.High-table2.High;
    table1.Low=table1.Low-table2.Low;
end

