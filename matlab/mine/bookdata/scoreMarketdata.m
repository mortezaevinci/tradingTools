function scores=scoreMarketdata(marketdata)


scores.dist.buys=squeeze(marketdata.PercentileBook(:,2,:).*marketdata.PercentileBook(:,1,:));
scores.dist.sells=squeeze(marketdata.PercentileBook(:,4,:).*marketdata.PercentileBook(:,3,:));
scores.dist.relative=scores.dist.sells-scores.dist.buys;

percentilesize=size(scores.dist.relative,1);

scores.dist.relativeSumTotal=sum(scores.dist.relative,1);
scores.dist.relativeSumClose=sum(scores.dist.relative(1:2,:),1);
scores.dist.relativeSumMid{1}=sum(scores.dist.relative(3:4,:),1);
scores.dist.relativeSumMid{2}=sum(scores.dist.relative(5:6,:),1);
scores.dist.relativeSumMid{3}=sum(scores.dist.relative(7:8,:),1);

scores.shares.buys=squeeze(marketdata.PercentileBook(:,1,:));
scores.shares.sells=squeeze(marketdata.PercentileBook(:,3,:));
scores.shares.totalBuys=sum(scores.shares.buys,1);
scores.shares.totalBuysClose=sum(scores.shares.buys(1:2,:),1);
scores.shares.totalSells=sum(scores.shares.buys,1);
scores.shares.totalSellsClose=sum(scores.shares.sells(1:2,:),1);
scores.shares.relativeTotal=scores.shares.totalSells-scores.shares.totalBuys;
scores.shares.relativeTotalClose=scores.shares.totalSellsClose-scores.shares.totalBuysClose;
end