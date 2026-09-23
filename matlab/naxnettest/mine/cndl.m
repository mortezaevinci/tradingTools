% Nagi Hatoum, Candlestick chart ploter function, 5/29/03

function cndl(D,H,L,O,C)

%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=C-O;
l=length(d);


w=1/l/10; %width of body, change to draw body thicker or thinner
hold on
%%%%%%%%draw line from Low to High%%%%%%%%%%%%%%%%%
for i=1:l
   line([D(i) D(i)],[L(i) H(i)])
end
%%%%%%%%%%draw red body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
if ~isempty(n)
   for i=1:length(n)
      x=[D(n(i))-w D(n(i))-w D(n(i))+w D(n(i))+w D(n(i))-w];
      y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
      fill(x,y,'r');%patch(x,y,'r')
   end
   %plot(n,C(n),'rs','MarkerFaceColor','r')
end
%%%%%%%%%%draw blue body(up day)%%%%%%%%%%%%%%%%%%%
n=find(d>=0);
if ~isempty(n)
   for i=1:length(n)
      x=[D(n(i))-w D(n(i))-w D(n(i))+w D(n(i))+w D(n(i))-w];
      y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
      fill(x,y,'g');%patch(x,y,'g')
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off