    input length = 20;
    input multiplier = 0.5;

    def newDay = GetDay()[1] <> GetDay()[2];
    rec rfirstvolume = if (newDay) then volume[1] / 2 + volume / 2 else rfirstvolume[1]*.999;
    plot firstvolume = rfirstvolume * multiplier;


    plot prevVol = volume ; #/2 for ordinary volume

    def largevolume = prevVol / firstvolume ;# if ( prevVol > volhigh * multiplier) then prevVol / volhigh * multiplier else 0;
    plot vol = largevolume;