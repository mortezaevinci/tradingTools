using IBApi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using System.IO;
using MHA;


namespace MHA
{
    [Serializable]
    public class IBControlDefinition
    {
     
        public int id;
        public int port;
        public string host;
        public int ClientId;
        public string systemStartTime = "";
        public string systemEndTime = "";

        [NonSerialized, XmlIgnore]
        public Dictionary<int, ContractDefinition> mapReqIdToCd = new Dictionary<int, ContractDefinition>();
        [NonSerialized, XmlIgnore]
        public Dictionary<string, int> mapContractKeyToReqId = new Dictionary<string, int>();
        [NonSerialized, XmlIgnore]
        public Dictionary<string, HashSet<OrderWatchlist>> mapContractKeyToWl = new Dictionary<string, HashSet<OrderWatchlist>>();
        [NonSerialized, XmlIgnore]
        public int cycleremainder = 0;

        private int assignMaps(int uid, ExternalCondition ec,OrderWatchlist ow)
        {
            //add a unique id
            //this is suppoased to be unique. IF ERROR, FIND THE BUG, DO NOT TRY
            string ukey = ContractDefinition.Tools.uniqueKey(ec.contractDefinition.contract);

            //map to watchlist
            if (mapContractKeyToWl.ContainsKey(ukey))
            {
                mapContractKeyToWl[ukey].Add(ow);
            }
            else
            {
                HashSet<OrderWatchlist> ows = new HashSet<OrderWatchlist>();
                ows.Add(ow);
                mapContractKeyToWl.Add(ukey, ows);
            }

            if (mapContractKeyToReqId.ContainsKey(ukey))
            {
                ec.contractDefinition.reservedRequestId = mapContractKeyToReqId[ukey];
            }
            else
            {
                mapReqIdToCd.Add(uid, ec.contractDefinition);
                //
                mapContractKeyToReqId.Add(ukey, uid);
                ec.contractDefinition.reservedRequestId = uid;
                uid++;
            }

            return uid;

        }

 

        public int generateUniqueIdsForExternalConditions()
        {
            mapContractKeyToWl.Clear();
            mapContractKeyToReqId.Clear();
            mapReqIdToCd.Clear();
            int uid = 1;
            foreach (OrderWatchlist ow in orderWatchlists)
            {
                foreach (OrderDefinition od in ow.orderDefinitions)
                {
                    foreach (ExternalCondition ec in od.externalConditions)
                    {
                        if (ec.contractDefinition != null)
                        {
                            uid = assignMaps(uid, ec, ow);
                        }
                    }

                    foreach (OrderDefinition cod in od.childOrderDefinitions)
                    {
                        foreach (ExternalCondition ec in cod.externalConditions)
                        {
                            if (ec.contractDefinition != null)
                            {

                                uid = assignMaps(uid, ec, ow);

                            }
                        }

                    }
                }

            }
            cycleremainder = mapReqIdToCd.Keys.Max() + 1; //the +1 is not necessary if we gaurantee reqid relative starts from 1. Just for the sake of not introducing a bug for now
            cycleremainder = (int)(Math.Ceiling((float)(cycleremainder) / 100.0)*100);
            return cycleremainder;
        }


        [Serializable]
        public class AuxAccountInfo
        {
            public int qty = 1;
            public double accountRisk = 1000;
            public double tradeRisk = 20;
            public string accountName = "";
        }
        public AuxAccountInfo auxAccountInfo=new AuxAccountInfo();

        public List<OrderWatchlist> orderWatchlists=new List<OrderWatchlist>();
      

        public void saveXML(string filename)
        {
            XmlSerializer ser = new XmlSerializer(typeof(IBControlDefinition));

            TextWriter writer = new StreamWriter(filename);
            ser.Serialize(writer, this);
            writer.Close();
        }

        public void loadXML(string filename)
        {
            XmlSerializer ser = new XmlSerializer(typeof(IBControlDefinition));
            TextReader reader = new StreamReader(filename);
            try
            {
                IBControlDefinition od = (IBControlDefinition)ser.Deserialize(reader);
                reader.Close();
                this.ClientId = od.ClientId;
                this.host = od.host;
                this.port = od.port;
                this.auxAccountInfo = od.auxAccountInfo;
                this.id = od.id;
                this.orderWatchlists = od.orderWatchlists;

                this.generateUniqueIdsForExternalConditions();
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            reader.Close();
            
        }

        /*
        public void regenerateExternalConditionRequestIdDictionary()
        {
            foreach (OrderWatchlist ow in this.orderWatchlists)
            {
                ow.regenerateExternalConditionRequestIdDictionary();
            }
        }
        */



        public class OrderWatchlist
        {
            public int id;
            public string name;
            public string notificationEmail = "";
            public ContractDefinition defaultContractDefinition;
            public List<ContractDefinition> contractDefinitions = new List<ContractDefinition>();
            public List<OrderDefinition> orderDefinitions = new List<OrderDefinition>();

            /*
            private Dictionary<int, List<OrderDefinition>> externalConditionLinks = new Dictionary<int, List<OrderDefinition>>();
            public void regenerateExternalConditionRequestIdDictionary()
            {
                externalConditionLinks.Clear();
                foreach (OrderDefinition od in orderDefinitions)
                {
                    foreach (ExternalCondition ec in od.externalConditions)
                    {
                        if (ec.contractDefinition!=null)
                        {
                            int rid = ec.contractDefinition.reservedRequestId;
                            if (rid>0)
                            {
                                if (!externalConditionLinks.ContainsKey(rid))
                                {
                                    List<OrderDefinition> lod = new List<OrderDefinition>();
                                    lod.Add(od);
                                    externalConditionLinks.Add(rid, lod);
                                }
                                else
                                {
                                    externalConditionLinks[rid].Add(od);
                                }
                            }
                        }
                    }

                    foreach (OrderDefinition cod in od.childOrderDefinitions)
                    {
                        foreach (ExternalCondition ec in cod.externalConditions)
                        {
                            if (ec.contractDefinition != null)
                            {
                                int rid = ec.contractDefinition.reservedRequestId;
                                if (rid > 0)
                                {
                                    if (!externalConditionLinks.ContainsKey(rid))
                                    {
                                        List<OrderDefinition> lod = new List<OrderDefinition>();
                                        lod.Add(cod);
                                        externalConditionLinks.Add(rid, lod);
                                    }
                                    else
                                    {
                                        externalConditionLinks[rid].Add(cod);
                                    }
                                }
                            }
                        }


                    }
                }
            }
            */



            public int findContractIndex(Contract c)
            {
                
                for (int i=0;i<contractDefinitions.Count();i++)
                {
                    try
                    {
                        Contract ci = contractDefinitions[i].contract;
                        if (c.SecType == "OPT")
                        {
                            if ((c.Symbol.Equals(ci.Symbol) && c.Right.Equals(ci.Right) && c.LastTradeDateOrContractMonth.Equals(ci.LastTradeDateOrContractMonth) && c.SecType.Equals(ci.SecType) && c.Strike.Equals(ci.Strike)) || (c.LocalSymbol.Equals(ci.LocalSymbol)) || (c.LocalSymbol.Equals(contractDefinitions[i].generatedLocalSysmbol)))
                            {
                                return i;

                            }
                        }
                        else
                        {
                            if ((c.Symbol.Equals(ci.Symbol) || c.LocalSymbol.Equals(ci.LocalSymbol)) && c.SecType.Equals(ci.SecType))
                            {
                                return i;
                            }
                        }

                    }
                    catch (Exception ex) { }
                    }
                return -1;
            }
            
                
        }
    }

   

  

}
