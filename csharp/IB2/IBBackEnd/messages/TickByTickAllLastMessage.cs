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
    public class TickByTickAllLastMessage
    {
        public int ReqId { get;  set; }
        public int TickType { get;  set; }
        public long Time { get;  set; }
        public double Price { get;  set; }
        public long Size { get;  set; }
        public TickAttribLast TickAttribLast { get;  set; }
        public string Exchange { get;  set; }
        public string SpecialConditions { get;  set; }

        public TickByTickAllLastMessage()
        {

        }

        public TickByTickAllLastMessage(int reqId, int tickType, long time, double price, long size, TickAttribLast tickAttribLast, string exchange, string specialConditions)
        {
            ReqId = reqId;
            TickType = tickType;
            Time = time;
            Price = price;
            Size = size;
            TickAttribLast = tickAttribLast;
            Exchange = exchange;
            SpecialConditions = specialConditions;
        }
    }
}
