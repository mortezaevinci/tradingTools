using IBApi;
using System;
using System.Collections.Generic;
using System.Xml.Serialization;
using MHA;
using System.IO;

namespace MHA
{
    public class TradeExtension
    {
        [Serializable]
        public class Config
        {
            public string LogFilename = "ibmanageorders.log";
            public string IBCDOrdersFilename = @"C:\temp\_results\tradingtools\files\auto swing order lmt template 4 export pre-explosivevol.xml";
            public string host = "";
            public int port = 4002;
            public int clientid = 2022;
            public string ConfigFilename = "config_manage_orders.xml";
            public string DumpDirectory = @"C:\temp\_results\tradingtools\files\";
            public bool simulateOrderAll = false;
            public bool collectTickInfoOnly = false;
            public bool cancelOrdersWithoutPosition = false;
            public bool autoShutdown = false;
            public string autoShutdownTime = "09:30:00";
            public string ToString()
            {
                return String.Format("{0}\n{1}\n{2}\n{3}\n{4}\n{5}\n", LogFilename, IBCDOrdersFilename, host, port, clientid, ConfigFilename);
            }

            public void saveXML(string filename)
            {
                XmlSerializer ser = new XmlSerializer(typeof(Config));

                TextWriter writer = new StreamWriter(filename);
                ser.Serialize(writer, this);
                writer.Close();
            }

            public void loadXML(string filename)
            {
                XmlSerializer ser = new XmlSerializer(typeof(Config));
                TextReader reader = new StreamReader(filename);
                try
                {
                    Config od = (Config)ser.Deserialize(reader);
                    reader.Close();
                    this.clientid = od.clientid;
                    this.host = od.host;
                    this.port = od.port;
                    this.LogFilename = od.LogFilename;
                    this.IBCDOrdersFilename = od.IBCDOrdersFilename;
                    this.ConfigFilename = od.ConfigFilename;
                    this.DumpDirectory = od.DumpDirectory;
                    this.autoShutdown = od.autoShutdown;
                    this.autoShutdownTime = od.autoShutdownTime;
                    this.cancelOrdersWithoutPosition = od.cancelOrdersWithoutPosition;
                    this.collectTickInfoOnly = od.collectTickInfoOnly;
                   
                }
                catch (Exception ex)
                {
                    Console.WriteLine("program loadxml:{0}", ex.Message);
                }
                reader.Close();

            }
        }

        public static long getActualSize(ContractDefinition contractDefinition, IBApi.messages.TickSizeMessage msg)
        {
            if (msg.Field == TickType.VOLUME || msg.Field == TickType.BID_SIZE
                || msg.Field == TickType.ASK_SIZE || msg.Field == TickType.LAST_SIZE
                || msg.Field == TickType.DELAYED_ASK_SIZE || msg.Field == TickType.DELAYED_VOLUME
                || msg.Field == TickType.DELAYED_BID_SIZE || msg.Field == TickType.DELAYED_LAST_SIZE)
            {
                if (contractDefinition.contract.SecType.Equals("STK"))
                {
                    return (long)msg.Size * (long)100;
                }
            }
            return msg.Size;
        }


        public static class Conditions
        {
            public static string PriceConditionText(PriceCondition pc)
            {
                string conditiontext;
                String symbol = "";



                string dirs = pc.IsMore ? ">=" : "<=";
                conditiontext = String.Concat(symbol, " ", pc.ConId, dirs, "+", pc.Price);
                return conditiontext;
            }

            public static string TimeConditionText(TimeCondition pc)
            {
                string conditiontext;
                String symbol = "";



                string dirs = pc.IsMore ? ">=" : "<=";
                conditiontext = String.Concat("Time", " ", dirs , pc.Time);
                return conditiontext;
            }

            public static string MarginConditionText(MarginCondition pc)
            {
                string conditiontext;

                string dirs = pc.IsMore ? ">=" : "<=";
                conditiontext = String.Concat("margin", " ", dirs, "+", pc.Percent);
                return conditiontext;
            }

            public static string VolumeConditionText(VolumeCondition pc)
            {
                string conditiontext;
                String symbol = "";



                string dirs = pc.IsMore ? ">=" : "<=";
                conditiontext = String.Concat(symbol, " ", pc.ConId, dirs, "+", pc.Volume);
                return conditiontext;
            }
        }
    }
}
