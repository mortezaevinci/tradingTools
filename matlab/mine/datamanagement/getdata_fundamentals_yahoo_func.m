function  getdata_fundamentals_yahoo_func(basedir,contracts,date1)


rq=[];
c=[];

  version='yahoo';
for i=1:numel(contracts)
	try

name=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\' filefriendlysymbol(contracts{i}.FileSymbol) ' fundamentals ' date1 '.mat'];
if (~exist(name))

     directory_=[basedir filefriendlysymbol(contracts{i}.FileSymbol) '\'];
   if (~exist(directory_))
    mkdir(directory_);
    end
    
    contracts{i}.Symbol
   [fundamentals,jfundamentals,rq,c]=getFundamentalsViaYahoo(contracts{i}.Symbol, rq,c); 
   if (~isempty(fundamentals))

   save(name,'fundamentals','jfundamentals','version');
   else
       disp('coud not grab fundamental data.');
      

       pause(0.5);
   end
end
   catch exception
       dumpReport('error.log', exception) 
        
   end
end
end

