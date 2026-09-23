/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using IBApi;
using IBSampleApp.messages;
using IBSampleApp.util;
using IBSampleApp.types;
using MHA;

namespace IBSampleApp.ui
{
    class MarketDataManager : DataManager
    {

     // public  HashSet<string> uniqueSymbols = new HashSet<string>();
       public Dictionary<string, int> uniquesymbolreqids = new Dictionary<string, int>();


        public const int TICK_ID_BASE = 10000000;

        public const int OPTIONS_ID_BASE = 70000000;
        private const int OPTIONS_DATA_CALL_BASE = OPTIONS_ID_BASE + 100000;
        private const int OPTIONS_DATA_PUT_BASE = OPTIONS_ID_BASE + 200000;
        private const int OPTIONS_EXERCISING_BASE = OPTIONS_ID_BASE + 1000000;

        private const int DESCRIPTION_INDEX = 0;

        private const int MARKET_DATA_TYPE_INDEX = 1;

        private const int BID_PRICE_INDEX = 3;
        private const int ASK_PRICE_INDEX = 6;
        private const int CLOSE_PRICE_INDEX = 11;
        private const int LAST_PRICE_INDEX = 8;
        private const int OPEN_PRICE_INDEX = 12;
        private const int HIGH_PRICE_INDEX = 13;
        private const int LOW_PRICE_INDEX = 14;
        private const int FUTURES_OPEN_INTEREST_INDEX = 15;
        private const int AVG_OPT_VOLUME_INDEX = 16;
        private const int SHORTABLE_SHARES_INDEX = 17;

        private const int BID_SIZE_INDEX = 2;
        private const int ASK_SIZE_INDEX = 7;
        private const int LAST_SIZE_INDEX = 9;
        private const int VOLUME_SIZE_INDEX = 10;
        private const int PRE_OPEN_BID = 4;
        private const int PRE_OPEN_ASK = 5;

        private bool active = false;


        class RequestInfo
        {
            public Contract contract;
            public int requestId;

            public RequestInfo(Contract c,int r)
            {
                contract = c;
                requestId = r;
            }
        }

        private List<RequestInfo> activeRequests = new List<RequestInfo>();

        public MarketDataManager(IBClient client, DataGridView dataGrid)
            : base(client, dataGrid)
        {
        }

        public bool isActive() { return active; }
        public void setActive() { active = true; }
        public void unsetActive() { active = false; }

        public int AddRequestExternal(Contract contract, string genericTickList)
        {
           
           
            int nextReqId = getTickBase(contract) + (useCurrentTicker(contract));
            activeRequests.Add(new RequestInfo(contract, nextReqId));
            checkToAddRow(nextReqId);
            ibClient.ClientSocket.reqMktData(nextReqId, contract, genericTickList, false, false, new List<TagValue>());
            if (uniquesymbolreqids.ContainsKey(ContractDefinition.Tools.uniqueKey(contract)))
            {
                uniquesymbolreqids[ContractDefinition.Tools.uniqueKey(contract)] = nextReqId;
            }
            else
            {
                uniquesymbolreqids.Add(ContractDefinition.Tools.uniqueKey(contract), nextReqId);
               
            }
            return nextReqId;
        }

        public int getTickBase(Contract contract)
        {
            if (contract.Strike > 0 && contract.SecType.Equals("OPT"))
            {
                if (contract.Right.Contains("C"))
                {
                    return OPTIONS_DATA_CALL_BASE;
                }
                else
                {
                    //put
                    return OPTIONS_DATA_PUT_BASE;
                }
            }
            return TICK_ID_BASE;
        }

        public int useCurrentTicker(Contract contract)
        {
            if (contract.Strike > 0)
            {
                if (contract.Right.Contains("C"))
                {
                    return currentTickerc++;
                }
                else
                {
                    //put
                    return currentTickerp++;
                }
            }
            return currentTicker++;
        }

        public int getTickBase(int requestid)
        {
            if (requestid < OPTIONS_ID_BASE) return TICK_ID_BASE;
            if (requestid < OPTIONS_DATA_PUT_BASE) return OPTIONS_DATA_CALL_BASE;
            return OPTIONS_DATA_PUT_BASE;
        }

        public int ForceRequest(Contract contract, string genericTickList,bool snapshot)
        {
            
            int nextReqId = getTickBase(contract) + (useCurrentTicker(contract));

            activeRequests.Add(new RequestInfo(contract, nextReqId));

            checkToAddRow(nextReqId);

            ibClient.ClientSocket.reqMktData(nextReqId, contract, genericTickList, snapshot, false, new List<TagValue>());
            if (uniquesymbolreqids.ContainsKey(ContractDefinition.Tools.uniqueKey(contract)))
            {
                uniquesymbolreqids[ContractDefinition.Tools.uniqueKey(contract)] = nextReqId;
            }
            else
            {
                uniquesymbolreqids.Add(ContractDefinition.Tools.uniqueKey(contract), nextReqId);
    
            }
            if (!uiControl.Visible)
                uiControl.Visible = true;

            return nextReqId;
        }

        public int AddRequest(Contract contract, string genericTickList)
        {
            /*
            activeRequests.Add(contract);
            int nextReqId = TICK_ID_BASE + (currentTicker++);
            checkToAddRow(nextReqId);
            
            ibClient.ClientSocket.reqMktData(nextReqId, contract, genericTickList, false, false, new List<TagValue>());
            if (uniquesymbolreqids.ContainsKey(contract.Symbol))
            {
                uniquesymbolreqids[contract.Symbol] = nextReqId;
            }
            else
            {
                uniquesymbolreqids.Add(contract.Symbol, nextReqId);
                uniqueSymbols.Add(contract.Symbol);
            }
            if (!uiControl.Visible)
                uiControl.Visible = true;

            return nextReqId;
            */
            int nextReqId = -1;
               if (uniquesymbolreqids.ContainsKey(ContractDefinition.Tools.uniqueKey(contract)))
            {
                //uniquesymbolreqids[contract.Symbol] = nextReqId;
                nextReqId = uniquesymbolreqids[ContractDefinition.Tools.uniqueKey(contract)];
            }
            else
            {
               
                nextReqId = getTickBase(contract) + (useCurrentTicker(contract));
                activeRequests.Add(new RequestInfo(contract, nextReqId));
                checkToAddRow(nextReqId);

                ibClient.ClientSocket.reqMktData(nextReqId, contract, genericTickList, false, false, new List<TagValue>());

                uniquesymbolreqids.Add(ContractDefinition.Tools.uniqueKey(contract), nextReqId);
    
            }
            if (!uiControl.Visible)
                uiControl.Visible = true;

            return nextReqId;
        }

        public void RequestMarketDataType(int marketDataType)
        {
            ibClient.ClientSocket.reqMarketDataType(marketDataType);
        }

        public override void NotifyError(int requestId)
        {
            //activeRequests.RemoveAt(GetIndex(requestId));
            //currentTicker-=1;
        }

        public override void Clear()
        {
            ((DataGridView)uiControl).Rows.Clear();
            activeRequests.Clear();
            uiControl.Visible = false;
            currentTicker = 0;
            currentTickerc = 0;
            currentTickerp = 0;
            uniquesymbolreqids.Clear();
           
        }

        public void RestartRequest(Contract contract, string genericTickList,int reqid)
        {
            ibClient.ClientSocket.reqMktData(reqid, contract, genericTickList, false, false, new List<TagValue>());

        }

        public void StopActiveRequest(int reqid)
        {
            try
            {
                ibClient.ClientSocket.cancelMktData(reqid);



            }
            catch
            {

            }
        }


        public void StopActiveRequests(bool clearTable)
        {
            for (int i = 1; i < activeRequests.Count; i++)
            {
                
                ibClient.ClientSocket.cancelMktData(activeRequests[i].requestId);
            }

            activeRequests.Clear();

            if (clearTable)
            {
                Clear();
            }
        }

        private void checkToAddRow(int requestId)
        {
            DataGridView grid = (DataGridView)uiControl;

            while (grid.Rows.Count < (1+requestId - getTickBase(requestId)))
            {
                grid.Rows.Add(GetIndex(requestId), 0);
                int fillindex = grid.Rows.Count - 1;                                                                                                                                                                
                grid[DESCRIPTION_INDEX, fillindex].Value = Utils.ContractToString(activeRequests[fillindex].contract);
                grid[MARKET_DATA_TYPE_INDEX, fillindex].Value = MarketDataType.Real_Time.Name; // default
            }
        }

        private int GetIndex(int requestId)
        {
            return requestId - getTickBase(requestId);
        }

        public void HandleMarketDataTypeMessage(MarketDataTypeMessage dataMessage)
        {
            try
            {
                DataGridView grid = (DataGridView)uiControl;

                grid[MARKET_DATA_TYPE_INDEX, GetIndex(dataMessage.RequestId)].Value = MarketDataType.get(dataMessage.MarketDataType).Name;
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        public bool IsUIUpdateRequired(MarketDataMessage dataMessage)
        {
            DataGridView grid = (DataGridView)uiControl;

            return grid.Rows.Count >= dataMessage.RequestId - getTickBase(dataMessage.RequestId);
        }

        public void UpdateUI(TickPriceMessage dataMessage)
        {
            try
            {
                DataGridView grid = (DataGridView)uiControl;

                if ((grid[MARKET_DATA_TYPE_INDEX, GetIndex(dataMessage.RequestId)].Value.Equals(MarketDataType.Real_Time.Name)) &&
                    (dataMessage.Field == TickType.DELAYED_BID ||
                    dataMessage.Field == TickType.DELAYED_ASK ||
                    dataMessage.Field == TickType.DELAYED_CLOSE ||
                    dataMessage.Field == TickType.DELAYED_OPEN ||
                    dataMessage.Field == TickType.DELAYED_LAST ||
                    dataMessage.Field == TickType.DELAYED_HIGH ||
                    dataMessage.Field == TickType.DELAYED_LOW))
                {
                    grid[MARKET_DATA_TYPE_INDEX, GetIndex(dataMessage.RequestId)].Value = MarketDataType.Delayed.Name;
                }

                switch (dataMessage.Field)
                {

                    case TickType.BID:
                    case TickType.DELAYED_BID:
                        {
                            //BID, DELAYED_BID
                            grid[BID_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                            grid[PRE_OPEN_BID, GetIndex(dataMessage.RequestId)].Value = dataMessage.Attribs.PreOpen;
                            break;
                        }
                    case TickType.ASK:
                    case TickType.DELAYED_ASK:
                        {
                            //ASK, DELAYED_ASK
                            grid[ASK_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                            grid[PRE_OPEN_ASK, GetIndex(dataMessage.RequestId)].Value = dataMessage.Attribs.PreOpen;
                            break;
                        }
                    case TickType.CLOSE:
                    case TickType.DELAYED_CLOSE:
                        {
                            //CLOSE, DELAYED_CLOSE
                            grid[CLOSE_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                            break;
                        }
                    case TickType.OPEN:
                    case TickType.DELAYED_OPEN:
                        {
                            //OPEN, DELAYED_OPEN
                            grid[OPEN_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                            break;
                        }
                    case TickType.LAST:
                    case TickType.DELAYED_LAST:
                        {
                            //LAST, DELAYED_LAST
                            grid[LAST_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                            break;
                        }
                    case TickType.HIGH:
                    case TickType.DELAYED_HIGH:
                        {
                            //HIGH, DELAYED_HIGH
                            grid[HIGH_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                            break;
                        }
                    case TickType.LOW:
                    case TickType.DELAYED_LOW:
                        {
                            //LOW, DELAYED_LOW
                            grid[LOW_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                            break;
                        }
                    default:
                        
                        Console.WriteLine("{0}:{1}={2}", dataMessage.RequestId, TickType.getField( dataMessage.Field), dataMessage.Price);
                        break;
                }
            }
            catch(Exception ex)
            {
                Console.WriteLine("grid error");
            }
        }

        public void UpdateUI(TickSizeMessage dataMessage)
        {
            try
            { 
            DataGridView marketDataGrid = (DataGridView)uiControl;

            if ((marketDataGrid[MARKET_DATA_TYPE_INDEX, GetIndex(dataMessage.RequestId)].Value.Equals(MarketDataType.Real_Time.Name)) &&
                (dataMessage.Field == TickType.DELAYED_BID_SIZE ||
                dataMessage.Field == TickType.DELAYED_ASK_SIZE ||
                dataMessage.Field == TickType.DELAYED_LAST_SIZE ||
                dataMessage.Field == TickType.DELAYED_VOLUME))
            {
                marketDataGrid[MARKET_DATA_TYPE_INDEX, GetIndex(dataMessage.RequestId)].Value = MarketDataType.Delayed.Name;
            }
            switch (dataMessage.Field)
            {
                case TickType.BID_SIZE:
                case TickType.DELAYED_BID_SIZE:
                    {
                        //BID SIZE, DELAYED_BID_SIZE
                        marketDataGrid[BID_SIZE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Size;
                        break;
                    }
                case TickType.ASK_SIZE:
                case TickType.DELAYED_ASK_SIZE:
                    {
                        //ASK SIZE, DELAYED_ASK_SIZE
                        marketDataGrid[ASK_SIZE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Size;
                        break;
                    }
                case TickType.LAST_SIZE:
                case TickType.DELAYED_LAST_SIZE:
                    {
                        //LAST_SIZE, DELAYED_LAST_SIZE
                        marketDataGrid[LAST_SIZE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Size;
                        break;
                    }
                case TickType.VOLUME:
                case TickType.DELAYED_VOLUME:
                    {
                        //VOLUME, DELAYED_VOLUME
                        marketDataGrid[VOLUME_SIZE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Size;
                        break;
                    }
                case TickType.FUTURES_OPEN_INTEREST:
                    {
                        //FUTURES_OPEN_INTEREST
                        marketDataGrid[FUTURES_OPEN_INTEREST_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Size;
                        break;
                    }
                case TickType.AVG_OPT_VOLUME:
                    {
                        //AVG_OPT_VOLUME
                        marketDataGrid[AVG_OPT_VOLUME_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Size;
                        break;
                    }
                case TickType.SHORTABLE_SHARES:
                    {
                        //SHORTABLE_SHARES
                        marketDataGrid[SHORTABLE_SHARES_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Size;
                        break;
                    }
                    default:

                        Console.WriteLine("{0}:{1}={2}", dataMessage.RequestId, TickType.getField(dataMessage.Field), dataMessage.Size);
                        break;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("grid error");
            }
        }

    }

}


