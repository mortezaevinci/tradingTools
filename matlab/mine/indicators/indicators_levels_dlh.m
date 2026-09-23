function [levels] = indicators_levels_dlh(timetable,intradaydateend,length,preps)
levels.values=zeros(1,length*2);
levels.color=cell(1,length*2);
levels.dir=zeros(1,length*2);
levels.width=ones(1,length*2);
levels.power=zeros(1,length*2);power_dailyHighLow(1:2)=[1,1];
levels.style=cell(1,length*2);
levels.name=cell(1,length*2);
levels.id=zeros(1,length*2);
try
  themorningdate=datetime([datestr(intradaydateend,'yyyy-mm-dd') ' 09:30:00']);

  tr=timerange(themorningdate-days(60), themorningdate-hours(themorningdate.Hour)-minutes(themorningdate.Minute)-hours(4));
  ddlast=timetable(tr,:);
    
%maintick.params.lenPreviousDayPivots=0;

alphadiff=preps.alpha/length;
 for i=1:length
     try
 lastdayquote=ddlast(end+1-i,:);
 levels.values(i*2-1)=lastdayquote.Low;
 levels.values(i*2)=lastdayquote.High;
 levels.color{i*2-1}=[0 0 1  preps.alpha-alphadiff*i];
 levels.color{i*2}=[0 0 1  preps.alpha-alphadiff*i];
 levels.style{i*2-1}=':';
 levels.style{i*2}=':';
 levels.name{i*2-1}=['DL' num2str(i)];
  levels.name{i*2}=['DH' num2str(i)];
 levels.dir(i*2-1:i*2)=[0 0];%[-1 1];
 x1=(0x0100)+i*2-1;
 x2=(0x0100)+i*2;
 levels.id(i*2-1:i*2)=[x1 x2];
     catch exception
   dumpReport('error.log', exception)  
         
     end
 end
 

catch exception
   dumpReport('error.log', exception)  
end
end

