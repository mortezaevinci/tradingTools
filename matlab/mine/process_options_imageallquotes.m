symbol='AAPL';
basemondaydate='2020-08-24';
  optionprofilefilename=['Z:\My files\Project trading\traderdata\options\' filefriendlysymbol(symbol) '\' filefriendlysymbol(symbol) ' options base ' datestr(basemondaydate,'yyyy-mm-dd') '.mat'];
  load(optionprofilefilename,'options');
 
  no=numel(options);
  
  %first get all possible strikes
  allstrikes=[];

  for io=1:no 
    allstrikes=[allstrikes ;options{io}.strikes];
 
  end
  allstrikes=unique(allstrikes);
  allepochs=options{io}.expirationDates; % this is common for data received on the same day
  allexdates=datetime(allepochs,'ConvertFrom','posixtime');
  imcall.lastPrice=nan(numel(allstrikes),numel(allepochs));
  imput.lastPrice=nan(numel(allstrikes),numel(allepochs));
  
   imcall.percentChange=nan(numel(allstrikes),numel(allepochs));
  imput.percentChange=nan(numel(allstrikes),numel(allepochs));
  
    imcall.volume=nan(numel(allstrikes),numel(allepochs));
  imput.volume=nan(numel(allstrikes),numel(allepochs));
  
    imcall.openInterest=nan(numel(allstrikes),numel(allepochs));
  imput.openInterest=nan(numel(allstrikes),numel(allepochs));
  
  
   for io=1:no 
    nc=numel(options{io}.options.calls);
    np=numel(options{io}.options.puts);
    %get index of expiration date
    exdate=options{io}.options.expirationDate;
    exdateindex=find(allepochs==exdate);
    
    
    for ic=1:nc
        try
        option=options{io}.options.calls{ic};
        strikeindex=find(allstrikes==option.strike);
          imcall.lastPrice(strikeindex,exdateindex)=option.lastPrice;
          imcall.percentChange(strikeindex,exdateindex)=option.percentChange;
          imcall.volume(strikeindex,exdateindex)=option.volume;
          imcall.openInterest(strikeindex,exdateindex)=option.openInterest;
        catch
            
        end
    end
    
     for ip=1:np
         try
        option=options{io}.options.puts{ip};
        strikeindex=find(allstrikes==option.strike);
          imput.lastPrice(strikeindex,exdateindex)=option.lastPrice;
          imput.percentChange(strikeindex,exdateindex)=option.percentChange;
          imput.volume(strikeindex,exdateindex)=option.volume;
          imput.openInterest(strikeindex,exdateindex)=option.openInterest;
           catch
            
        end
    end   
   end
  
   figure('Name','imcall.lastPrice');
  imagesc((1:no),allstrikes,imcall.lastPrice);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
   
  figure('Name','imput.lastPrice');
    imagesc((1:no),allstrikes,  imput.lastPrice);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
    figure('Name','imcall.percentChange');
    imagesc((1:no),allstrikes,  imcall.percentChange);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
      figure('Name','imput.percentChange');
    imagesc((1:no),allstrikes,  imput.percentChange);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
      figure('Name','imcall.volume');
    imagesc((1:no),allstrikes,  imcall.volume);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
    figure('Name','imput.volume');
    imagesc((1:no),allstrikes,  imput.volume);  
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
    figure('Name','imcall.openInterest');
    imagesc((1:no),allstrikes,  imcall.openInterest);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
      figure('Name','imput.openInterest');
    imagesc((1:no),allstrikes,  imput.openInterest);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));
     
  figure('Name','imcall.openInterest-imput.openInterest');
    imagesc((1:no),allstrikes,  imcall.openInterest-imput.openInterest);
   set(gca,'XTick',(1:no)');
   set(gca,'XTickLabel',datestr(allexdates));