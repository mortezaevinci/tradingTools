function lvls=roundLevels(close)
try
  if (close<20)
      rval=1;
      rval2=0.5;
  elseif (close<100)
      rval=5;
      rval2=1;
  elseif (close<500)
      rval=10;
      rval2=5;
  elseif (close<1000)
      rval=20;
      rval2=10;
  else
      rval=50;
      rval2=10;
  end

    lvls=[floor(close/rval)*rval ceil(close/rval)*rval floor(close/rval2)*rval2 ceil(close/rval2)*rval2];
catch exception
getReport(exception,'extended','hyperlinks','off')
lvls=[];
end
end