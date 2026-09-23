function events=setIbWrapperEvents(ibWrapper)

events.eventhandlerError= addlistener(ibWrapper,'HandledError',@HandledErrorFcn);
events.eventhandlerTick = addlistener(ibWrapper,'HandledTickPrice',@HandledTickPriceFcn);
events.eventhandlerOrderStatus = addlistener(ibWrapper,'HandledOrderStatus',@HandledOrderStatusFcn);
events.eventhandlerPositions= addlistener(ibWrapper,'HandledPosition',@HandledPositionFcn);
events.eventhandlerHistoricalDataUpdate= addlistener(ibWrapper,'HandledHistoricalDataUpdate',@HandledHistoricalDataUpdateFcn);
%no need to listen here, only slows thins down
events.eventhandlerHistoricalData=addlistener(ibWrapper,'HandledHistoricalData',@HandledHistoricalDataFcn);
events.eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@HandledHistoricalDataEnd_getarray_Fcn_ignore); 
events.eventhandlerAccountSummary= addlistener(ibWrapper,'HandledAccountSummary',@HandledAccountSummaryFcn); 
events.eventhandlerAccountSummaryEnd= addlistener(ibWrapper,'HandledAccountSummaryEnd',@HandledAccountSummaryEndFcn); 
events.eventhandlerPositionEnd= addlistener(ibWrapper,'HandledPositionEnd',@HandledPositionEndFcn); 
events.eventhandlerOpenOrder= addlistener(ibWrapper,'HandledOpenOrder',@HandledOpenOrderFcn); 
events.eventhandlerCompletedOrder= addlistener(ibWrapper,'HandledCompletedOrder',@HandledCompletedOrderFcn); 
events.eventhandlerMarketDataType= addlistener(ibWrapper,'HandledMarketDataType',@HandledMarketDataTypeFcn); 
events.eventhandlerConnectionClose= addlistener(ibWrapper,'HandledConnectionClose',@HandledConnectionCloseFcn); 
events.eventhandlerRealtimeBar= addlistener(ibWrapper,'HandledRealtimeBar',@HandledRealtimeBarFcn); 
events.eventhandlerContractDetails= addlistener(ibWrapper,'HandledContractDetails',@HandledContractDetailsFcn);
events.eventhandlerExecDetails= addlistener(ibWrapper,'HandledExecDetails',@HandledExecDetailsFcn); 
events.eventhandlerHistoricalNews= addlistener(ibWrapper,'HandledHistoricalNews',@HandledHistoricalNewsFcn); 
events.eventhandlerHistoricalNewsEnd= addlistener(ibWrapper,'HandledHistoricalNewsEnd',@HandledHistoricalNewsEndFcn); 
events.eventhandlerSecurityDefinitionOptionParameter= addlistener(ibWrapper,'HandledSecurityDefinitionOptionParameter',@HandledSecurityDefinitionOptionParameterFcn); 
events.eventhandlerSecurityDefinitionOptionParameterEnd= addlistener(ibWrapper,'HandledSecurityDefinitionOptionParameterEnd',@HandledSecurityDefinitionOptionParameterEndFcn); 
events.eventhandlerUpdateMktDepth= addlistener(ibWrapper,'HandledUpdateMktDepth',@HandledUpdateMktDepthFcn); 
events.eventhandlerUpdateMktDepthL2= addlistener(ibWrapper,'HandledUpdateMktDepthL2',@HandledUpdateMktDepthL2Fcn); 
events.eventhandlerUpdateNewsBulletin= addlistener(ibWrapper,'HandledUpdateNewsBulletin',@HandledUpdateNewsBulletinFcn); 
events.eventhandlerFundamentalData = addlistener(ibWrapper,'HandledFundamentaldData',@HandledFundamentalDataFcn);
events.eventhandlerScannerData = addlistener(ibWrapper,'HandledScannerData',@HandledScannerDataFcn);
events.eventhandlerScannerDataEnd = addlistener(ibWrapper,'HandledScannerDataEnd',@HandledScannerDataEndFcn);
%events.eventhandler= addlistener(ibWrapper,'Handled',@HandledFcn); 

end