doalldates=0;
genfigsdaily=0;
[date0,tradedate]=PrevAndTradeDate();
disp(date0);
disp(tradedate);

test_dailyrdiff_volume_observe_scan;
test_dailyxdiff_volume_observe_scan;
trader_preorder_t2;