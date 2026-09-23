
function cndl2(D,H,L,O,C)

%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=C-O;

   line([D D]',[L H]','Color','black');

%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
       line([D(n) D(n)]',[C(n) O(n)]','Color','red','LineWidth',5);

n=find(d>=0);
        line([D(n) D(n)]',[C(n) O(n)]','Color','green','LineWidth',5);
