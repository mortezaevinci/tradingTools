
function cndl2(D,H,L,O,C)

%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=C-O;
l=length(d);
hold on
%%%%%%%%draw line from Low to High%%%%%%%%%%%%%%%%%
for i=1:l
   line([D(i) D(i)],[L(i) H(i)],'Color','black');
end
%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
if ~isempty(n)
   for i=1:length(n)
       line([D(n(i)) D(n(i))],[C(n(i)) O(n(i))],'Color','red','LineWidth',5);
   end
end
n=find(d>=0);
if ~isempty(n)
   for i=1:length(n)

        line([D(n(i)) D(n(i))],[C(n(i)) O(n(i))],'Color','green','LineWidth',5);
   end
end

hold off