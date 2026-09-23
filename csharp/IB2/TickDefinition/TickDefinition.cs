using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Threading;
using System.Windows;

namespace MHA
{
    public class TickDefinition
    {
        public class TickInfo
        {

            public TickInfo()
            {
               
            }

            public class BufferData
            {
                public BufferData(double v,DateTime dt)
                {
                    value = v;
                    dateTime = dt;
                }
                public double value;
                public DateTime dateTime;
            }

            Semaphore _pool_buffer = new Semaphore(1, 1);
            private List<BufferData> bufferData = new List<BufferData>();
            private const int buffersize = 32;
            public enum GatheringType
            {
                First,
                Last,
                Min,
                Max,
            }

            public enum ValueType
            {
                Volume,
                Price
            }


            public ValueType valueType;
            public double value;
            public DateTime date;
            public string dateMsgString;
            public bool filled = false;
            public GatheringType gatheringType = GatheringType.First;

            public double valueRate(double minutes)
            {
                if (gatheringType== GatheringType.Last)
                {
                    int cnt = bufferData.Count;
                    if (cnt < 2) return 0;

                    double totalminutes;
                    for (int i=cnt-2;i>=0;i--)
                    {
                         totalminutes = (bufferData[cnt - 1].dateTime - bufferData[i].dateTime).TotalMinutes;
                        if (totalminutes>=minutes)
                        {
                            return ((bufferData[cnt-1].value-bufferData[i].value) / totalminutes);
                        }
                    }

                     totalminutes = (bufferData[cnt - 1].dateTime - bufferData[0].dateTime).TotalMinutes;

                    return ((bufferData[cnt - 1].value - bufferData[0].value) / totalminutes);


                }


                return 0;
            }

            /*
            public void processTickInfo(long _volume)
            {
            if (_volume<0) return;
                switch (gatheringType)
                {
                    case GatheringType.First:
                        if (filled==false && _volume>0)
                        {
                            volume = _volume;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    case GatheringType.Last:
                        volume = _volume;
                        date = DateTime.Now;
                        dateMsgString = "";
                        filled = true;
                        break;
                    case GatheringType.Max:
                        if (filled == false || volume<_volume)
                        {
                            volume = _volume;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    case GatheringType.Min:
                        if (filled == false || volume > _volume)
                        {
                            volume = _volume;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    default:
                        break;
                }
            }

            public void processTickInfo(double _price)
            {
                if (_price < 0) return;
                switch (gatheringType)
                {
                    case GatheringType.First:
                        if (filled == false )
                        {
                            price = _price;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    case GatheringType.Last:

                        {
                            price = _price;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                            break;
                        }
                    case GatheringType.Max:
                        if (filled == false || price < _price)
                        {
                            price = _price;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    case GatheringType.Min:
                        if (filled == false || price > _price)
                        {
                            price = _price;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    default:
                        break;
                }
            }
             */

                private void fillBuffer(double v,DateTime d)
            {
                _pool_buffer.WaitOne();
                try
                {
                    bufferData.Add(new BufferData(v, d));
                    if (bufferData.Count > buffersize)
                    {
                        bufferData.RemoveAt(0);
                    }
                }
                catch { }
                _pool_buffer.Release();
            }

            public void processTickInfo(double _value)
            {
                if (_value <= 0) return;
                switch (gatheringType)
                {
                    case GatheringType.First:
                        if (filled == false)
                        {
                            value = _value;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;

                        }
                        break;
                    case GatheringType.Last:

                        {
                            value = _value;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                            fillBuffer(value, date);
                            break;
                        }
                    case GatheringType.Max:
                        if (filled == false || value < _value)
                        {
                            value = _value;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    case GatheringType.Min:
                        if (filled == false || value > _value)
                        {
                            value = _value;
                            date = DateTime.Now;
                            dateMsgString = "";
                            filled = true;
                        }
                        break;
                    default:
                        break;
                }
            }
        }


        TickInfo tickInfo;
        
    }
}
