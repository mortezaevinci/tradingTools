function rval=roundRange(price)

  if (price<5)
      rval(2)=0.5;
      rval(1)=0.25;
  elseif (price<20)    
      rval(2)=1;
      rval(1)=0.5;
  elseif (price<200)
      rval(2)=2;
      rval(1)=1;
  elseif (price<500)
      rval(2)=5;
      rval(1)=2;     
  elseif (price<1000)
      rval(2)=10;
      rval(1)=5;
  elseif (price<2000)
      rval(2)=20;
      rval(1)=10;
  elseif (price<5000)
      rval(2)=50;
      rval(1)=20;
  elseif (price<10000)
      rval(2)=100;
      rval(1)=50;
  elseif (price<500000)
      rval(2)=5000;
      rval(1)=1000;
  else
      rval(2)=50000;
      rval(1)=10000; 
  end
  
end