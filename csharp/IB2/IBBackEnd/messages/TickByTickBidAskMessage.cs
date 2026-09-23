/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using IBApi;

namespace IBApi.messages
{
    [Serializable]
    public class TickByTickBidAskMessage
    {
        public int ReqId { get;  set; }
        public long Time { get;  set; }
        public double BidPrice { get;  set; }
        public double AskPrice { get;  set; }
        public long BidSize { get;  set; }
        public long AskSize { get;  set; }
        public TickAttribBidAsk TickAttribBidAsk { get; set; }
        public TickByTickBidAskMessage()
        { }
        public TickByTickBidAskMessage(int reqId, long time, double bidPrice, double askPrice, long bidSize, long askSize, TickAttribBidAsk tickAttribBidAsk)
        {
            ReqId = reqId;
            Time = time;
            BidPrice = bidPrice;
            AskPrice = askPrice;
            BidSize = bidSize;
            AskSize = askSize;
            TickAttribBidAsk = tickAttribBidAsk;
        }
    }
}
