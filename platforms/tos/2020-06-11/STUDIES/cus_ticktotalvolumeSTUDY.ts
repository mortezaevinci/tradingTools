#HINT: This study color codes volume by amount of volume on up-tick versus amount of volume on down-tick

declare lower;

def diffvol =  volume * (close-close[1]);


plot TSV = TotalSum(diffvol);
