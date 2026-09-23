
ibSignal=IBApi.EReaderMonitorSignal;
ibClient=IBApi.IBClient(ibSignal);
ibReader = IBApi.EReader(ibClient.ClientSocket, ibSignal);
ibWrapper=IBApi.IBWrapper(ibClient,ibSignal);