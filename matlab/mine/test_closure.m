dt0=datetime();

for i=1:300
    dt=dt0-days(i);
     if (ismarketopen(dt) ~= isbusday(dt))
         dt
         disp([num2str(ismarketopen(dt)) ' ' num2str(ismarketopen(datestr(dt,'yyyy-mm-dd'))) ' ' num2str((isbusday(dt)))]);
  
    end
end