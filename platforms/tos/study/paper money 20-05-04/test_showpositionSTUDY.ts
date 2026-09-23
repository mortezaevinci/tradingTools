input symbol="AMZN";
def q=getquantity(symbol);

addlabel(q>0,"owns "+q+" "+symbol);