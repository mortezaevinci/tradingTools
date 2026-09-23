
    def prevVol = volume ; #/2 for ordinary volume
    
    def nonlarge=volume[1]+volume[2]+volume[3]+volume[4];

    def largevolume = prevVol/ nonlarge ;# if ( prevVol > volhigh * multiplier) then prevVol / volhigh * multiplier else 0;
    plot vol = largevolume;

plot thresh=1;