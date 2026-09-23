function ii=genindicatorindextable(timetable)
ii=timetable(1,:);
names=ii.Properties.VariableNames;
nn=numel(names);

cnt=1;

for i=1:nn
   jj=ii(1,names(i)) ;
  jc=size(table2array(jj),2);
  jrep=(1:jc)+cnt-1;
      jj(1,:)=table(jrep);
      cnt=cnt+jc;
   
   ii(1,names(i))=jj;
end


end