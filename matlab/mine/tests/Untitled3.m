dt=datetime('2020-06-01 09:30:00')+minutes((0:389)');
Date=minutes(dt-dt(1))+1;
dat=(1:390)';

tt=table(Date,dat);

dt=datetime('2020-06-02 09:30:00')+minutes((0:389)');
Date=minutes(dt-dt(1))+1;
tt2=table(Date,dat);
tt2.dat=tt2.dat/2;

tt2.dat(381)=nan;
tt2(380,:)=[];


zz=zeros(size(dat));
dt=datetime('2020-06-03 09:30:00')+minutes((0:389)');
Date=minutes(dt-dt(1))+1;
dat=zz;
tt3=table(Date,dat,zz);


cum1=ones(size(tt.Date));
cum1(isnan(tt.dat))=0;


cum2=ones(size(tt2.Date));
cum2(isnan(tt2.dat))=0;

tt3(tt.Date,:).zz=tt3(tt.Date,:).zz+cum1;
tt3(tt2.Date,:).zz=tt3(tt2.Date,:).zz+cum2;

dat1=tt.dat;
dat1(isnan(dat1))=0;

dat2=tt2.dat;
dat2(isnan(dat2))=0;

tt3(tt.Date,:).dat=tt3(tt.Date,:).dat+dat1;
tt3(tt2.Date,:).dat=tt3(tt2.Date,:).dat+dat2;
