function bounce=largebounce(table,mindis,dvs_fight)
try
length=5;
ttmulti=3;
tt=zeros(size(dvs_fight));
for i=1:length-1
    tt(length:end)=tt(length:end)+abs(dvs_fight(length-i:end-i));
end
tt=tt/(length-1)*ttmulti;

mdc=(abs(mindis)./table.Close)<.001; %0.1% of stock price close to a level

bounce.up=mdc & (tt<dvs_fight);
bounce.dn=mdc & (-tt>dvs_fight);
catch exception
dumpReport('error.log', exception)
bounce.up=zeros(size(dvs_fight));
bounce.dn=zeros(size(dvs_fight));
end
end