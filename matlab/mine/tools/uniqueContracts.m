function cout=uniqueContracts(cin,identifier)
ccnt=0;
idcon='';
nc=numel(cin);
for i=1:nc
   cid=cin{i}.(identifier);
   if (~contains(idcon,[cid '.']))
       idcon=[idcon '.' cid];
       ccnt=ccnt+1;
       cout{ccnt}=cin{i};
   end
end
end