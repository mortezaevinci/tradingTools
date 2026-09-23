function table = stocktable_mul(table,factor)
    table.Close=table.Close*factor;
    table.Open=table.Open*factor;
    table.High=table.High*factor;
    table.Low=table.Low*factor;
end

