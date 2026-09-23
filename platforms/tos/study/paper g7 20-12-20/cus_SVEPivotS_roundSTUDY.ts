input PilotsAgg = AggregationPeriod.DAY;

def multiplier=if (close<500) then 4 else 2;

plot pp = roundup(SVEPivots(PilotsAgg)."PP"*multiplier,0)/multiplier;
plot ppl = rounddown(SVEPivots(PilotsAgg)."PP"*multiplier,0)/multiplier;
plot s1 = rounddown(SVEPivots(PilotsAgg)."S1"*multiplier,0)*multiplier;
plot r1 = roundup(SVEPivots(PilotsAgg)."R1"*multiplier,0)/multiplier;

plot r2=roundup(SVEPivots(PilotsAgg)."R2"*multiplier,0)/multiplier;
plot s2=rounddown(SVEPivots(PilotsAgg)."s2"*multiplier,0)/multiplier;

plot r3=roundup(SVEPivots(PilotsAgg)."R3"*multiplier,0)/multiplier;
plot s3=rounddown(SVEPivots(PilotsAgg)."s3"*multiplier,0)/multiplier;

pp.AssignValueColor(Color.pLUM);
ppl.AssignValueColor(Color.pLUM);
s1.AssignValueColor(Color.LIGHT_GREEN);
s2.AssignValueColor(Color.LIGHT_GREEN);
s3.AssignValueColor(Color.LIGHT_GREEN);

r1.AssignValueColor(Color.LIGHT_RED);
r2.AssignValueColor(Color.LIGHT_RED);
r3.AssignValueColor(Color.LIGHT_RED);