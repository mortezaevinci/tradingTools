/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using IBApi;

namespace IBApi.messages
{
    public class HistoricalTicksLastMessage
    {
        public int ReqId;
        public HistoricalTickLast[] Ticks;

        public HistoricalTicksLastMessage(int reqId, HistoricalTickLast[]  ticks)
        {
            ReqId = reqId;
            Ticks = ticks;
        }
    }
}
