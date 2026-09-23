function events=setIbWrapperClassEvents(ibWrapper,ibDataHandler)

events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerTickPrice = addlistener(ibWrapper,'HandledTickPrice',@ibDataHandler.HandledTickPriceFcn);
events.eventhandlerTickSize = addlistener(ibWrapper,'HandledTickSize',@ibDataHandler.HandledTickSizeFcn);
events.eventhandlerOrderStatus = addlistener(ibWrapper,'HandledOrderStatus',@ibDataHandler.HandledOrderStatusFcn);
events.eventhandlerPositions= addlistener(ibWrapper,'HandledPosition',@ibDataHandler.HandledPositionFcn);
events.eventhandlerHistoricalDataUpdate= addlistener(ibWrapper,'HandledHistoricalDataUpdate',@ibDataHandler.HandledHistoricalDataUpdateFcn);
%no need to listen here, only slows thins down
%events.eventhandlerHistoricalData=addlistener(ibWrapper,'HandledHistoricalData',@ibDataHandler.HandledHistoricalDataFcn);
%events.eventhandlerHistoricalEndData= addlistener(ibWrapper,'HandledHistoricalDataEnd',@ibDataHandler.HandledHistoricalDataEnd_getarray_Fcn_ignore);
events.eventhandlerAccountSummary= addlistener(ibWrapper,'HandledAccountSummary',@ibDataHandler.HandledAccountSummaryFcn);
events.eventhandlerAccountSummaryEnd= addlistener(ibWrapper,'HandledAccountSummaryEnd',@ibDataHandler.HandledAccountSummaryEndFcn);
events.eventhandlerPositionEnd= addlistener(ibWrapper,'HandledPositionEnd',@ibDataHandler.HandledPositionEndFcn);
events.eventhandlerOpenOrder= addlistener(ibWrapper,'HandledOpenOrder',@ibDataHandler.HandledOpenOrderFcn);
events.eventhandlerCompletedOrder= addlistener(ibWrapper,'HandledCompletedOrder',@ibDataHandler.HandledCompletedOrderFcn);
events.eventhandlerMarketDataType= addlistener(ibWrapper,'HandledMarketDataType',@ibDataHandler.HandledMarketDataTypeFcn);
events.eventhandlerConnectionClose= addlistener(ibWrapper,'HandledConnectionClose',@ibDataHandler.HandledConnectionCloseFcn);
events.eventhandlerRealtimeBar= addlistener(ibWrapper,'HandledRealtimeBar',@ibDataHandler.HandledRealtimeBarFcn);
events.eventhandlerContractDetails= addlistener(ibWrapper,'HandledContractDetails',@ibDataHandler.HandledContractDetailsFcn);
events.eventhandlerExecDetails= addlistener(ibWrapper,'HandledExecDetails',@ibDataHandler.HandledExecDetailsFcn);
events.eventhandlerHistoricalNews= addlistener(ibWrapper,'HandledHistoricalNews',@ibDataHandler.HandledHistoricalNewsFcn);
events.eventhandlerHistoricalNewsEnd= addlistener(ibWrapper,'HandledHistoricalNewsEnd',@ibDataHandler.HandledHistoricalNewsEndFcn);
events.eventhandlerSecurityDefinitionOptionParameter= addlistener(ibWrapper,'HandledSecurityDefinitionOptionParameter',@ibDataHandler.HandledSecurityDefinitionOptionParameterFcn);
events.eventhandlerSecurityDefinitionOptionParameterEnd= addlistener(ibWrapper,'HandledSecurityDefinitionOptionParameterEnd',@ibDataHandler.HandledSecurityDefinitionOptionParameterEndFcn);
events.eventhandlerUpdateMktDepth= addlistener(ibWrapper,'HandledUpdateMktDepth',@ibDataHandler.HandledUpdateMktDepthFcn);
events.eventhandlerUpdateMktDepthL2= addlistener(ibWrapper,'HandledUpdateMktDepthL2',@ibDataHandler.HandledUpdateMktDepthL2Fcn);
events.eventhandlerUpdateNewsBulletin= addlistener(ibWrapper,'HandledUpdateNewsBulletin',@ibDataHandler.HandledUpdateNewsBulletinFcn);
events.eventhandlerFundamentalData = addlistener(ibWrapper,'HandledFundamentaldData',@ibDataHandler.HandledFundamentalDataFcn);
events.eventhandlerScannerData = addlistener(ibWrapper,'HandledScannerData',@ibDataHandler.HandledScannerDataFcn);
events.eventhandlerScannerDataEnd = addlistener(ibWrapper,'HandledScannerDataEnd',@ibDataHandler.HandledScannerDataEndFcn);

end