input PilotsAgg1 = AggregationPeriod.DAY;
input PilotsAgg2 = AggregationPeriod.WEEK;
input PilotsAgg3 = AggregationPeriod.MONTH;
input crossoverlength = 4;

script checkopenbelow {
    input level = 0;
    input crossoverlength = 4;
    plot isbelow = (fold index = 1 to crossoverlength with p = 1 do (p and open[index] < level));
}

script crosspivots {
    input crossoverleng = 4;
    input pivots=SVEpivots();
    def upcross1d = checkopenbelow(s3d, crossoverlength) and   Crosses(close, s3d, CrossingDirection.ABOVE);
    def upcross2d = checkopenbelow(s2d, crossoverlength) and  Crosses(close, s2d, CrossingDirection.ABOVE);
    def upcross3d = checkopenbelow(s1d, crossoverlength) and  Crosses(close, S1d, CrossingDirection.ABOVE);
    def upcross4d = checkopenbelow(ppd, crossoverlength) and  Crosses(close, PPd, CrossingDirection.ABOVE);
    def upcross5d = checkopenbelow(r1d, crossoverlength) and  Crosses(close, R1d, CrossingDirection.ABOVE);
    def upcross6d = checkopenbelow(r2d, crossoverlength) and   Crosses(close, r2d, CrossingDirection.ABOVE);
    def upcross7d = checkopenbelow(r3d, crossoverlength) and  Crosses(close, r3d, CrossingDirection.ABOVE);

    def upcrossd = if (upcross1d) then r3d else (if (upcross2d) then r2d else (if (upcross3d ) then R1d else (if (upcross4d) then PPd else (if (upcross5d) then S1d else (if (upcross6d ) then s2d else (if (upcross7d ) then s3d else 0))))));
}

plot pupcrossd = upcrossd;

    pupcrossd.SetPaintingStrategy(PaintingStrategy.BOOLEAN_ARROW_UP);