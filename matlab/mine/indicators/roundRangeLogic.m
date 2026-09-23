function rval=roundRangeLogic(price)

  if (price<5)
      rval(2)=0.5;
      rval(1)=0.25;
  elseif (price<20)    
      rval(2)=1;
      rval(1)=0.5;
       elseif (price<50)    
      rval(2)=1;
      rval(1)=0.75;
       elseif (price<100)    
      rval(2)=1.5;
      rval(1)=1;
  elseif (price<200)
      rval(2)=2;
      rval(1)=1;
  elseif (price<300)    
      rval(2)=1;
      rval(1)=1.2;
 elseif (price<400)    
      rval(2)=1;
      rval(1)=1.5;
  elseif (price<500)
      rval(2)=5;
      rval(1)=2;     
   elseif (price<600)    
      rval(2)=1;
      rval(1)=2.5;
       elseif (price<800)    
      rval(2)=1;
      rval(1)=3;
      
  elseif (price<1000)
      rval(2)=10;
      rval(1)=5;
       elseif (price<1500)    
      rval(2)=12;
      rval(1)=6;
      
  elseif (price<2000)
      rval(2)=20;
      rval(1)=10;
       elseif (price<3000)    
      rval(2)=25;
      rval(1)=13;
       elseif (price<4000)    
      rval(2)=30;
      rval(1)=15;
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