declare lower;
  input length = 20;
    input multiplier = 0.1;

def newDay=Getday()[1]<>getday()[2];
rec rfirstvolume=if (newday) then volume[1]/2+volume/2 else rfirstvolume[1];
plot firstvolume=rfirstvolume*multiplier;


  

def diffVolume =(Volume * (close*2 - low- high) / (high - low));

    plot prevVol = (diffVolume*2 + diffVolume[1])/3; #/2 for ordinary volume

    def largevolume =prevVol / firstvolume ;# if ( prevVol > volhigh * multiplier) then prevVol / volhigh * multiplier else 0;
    plot vol = largevolume;

plot np=-firstvolume;