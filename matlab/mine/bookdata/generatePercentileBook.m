function marketdata=generatePercentileBook(marketdata)
baseprice=(marketdata.Book(1,3,:)+marketdata.Book(1,7,:))/2;
repbase=repmat(baseprice,120,1);
%percentilebookprep could be added as part of book for calculation
%efficiency
marketdata.PercentileBookPrep(:,1,:)=(marketdata.Book(:,3,:)-repbase)./repbase;
marketdata.PercentileBookPrep(:,2,:)=(marketdata.Book(:,7,:)-repbase)./repbase;

%selection of percents probably need to be done dynamically

bookSize=size(marketdata.Book,1);

%DROPS THIS VERSION FOR MACHINE LEARNING PURPOSE
%percentiledivisions=60;
%marketdata.PercentileCalcs.percentsover=linspace(0,0.02,percentiledivisions)'; % divide 10% into 120 section

marketdata.PercentileCalcs.percentsover=[0; .0005; .001 ;.0015; .002;.0025; .003 ;.004;.005 ;.01 ;.02 ;.05;0.1];
percentileLength=numel(marketdata.PercentileCalcs.percentsover);
percentsbelow=shift(marketdata.PercentileCalcs.percentsover,-1);

matpover=repmat(marketdata.PercentileCalcs.percentsover,1,bookSize);
matpbelow=repmat(percentsbelow,1,bookSize);

nsamples=numel(marketdata.Date);
for i=1:nsamples
    

for j=1:2
comp=repmat(abs(squeeze(marketdata.PercentileBookPrep(:,j,i)))',percentileLength,1);
conversionmat=comp>matpover & comp<=matpbelow;
marketdata.PercentileBook(:,(j-1)*2+1,i)=conversionmat*marketdata.Book(:,2+(j-1)*4,i); %shares
marketdata.PercentileBook(:,(j-1)*2+2,i)=conversionmat*marketdata.Book(:,3+(j-1)*4,i); %percentile price
end

end
end