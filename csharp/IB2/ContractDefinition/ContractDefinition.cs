using IBApi;
using System;
using System.Collections.Generic;
using System.Xml.Serialization;
using MHA;

namespace MHA
{
    [XmlInclude(typeof(VolumeCondition))]
    [XmlInclude(typeof(PercentChangeCondition))]
    [XmlInclude(typeof(TimeCondition))]
    [XmlInclude(typeof(PriceCondition))]
    [XmlInclude(typeof(MarginCondition))]
    [XmlInclude(typeof(ExecutionCondition))]
    [XmlInclude(typeof(PercentChangeCondition))]
    [XmlInclude(typeof(ContractCondition))]
    public class ContractDefinition
    {
        public static class Tools
        {
            public static Contract getGenericContract(string symbol,string secType="",string exchange="SMART",string primaryExch="",string currency="USD",double strike=0,string contractMonth="", string right="None",string Multiplier="")
            {

                Contract genericEquityContract = new Contract();

                genericEquityContract.LastTradeDateOrContractMonth = contractMonth;
                genericEquityContract.PrimaryExch = primaryExch;
                genericEquityContract.IncludeExpired = false;
                genericEquityContract.Right = right;

                genericEquityContract.Strike = strike;
                genericEquityContract.Multiplier = Multiplier;

                genericEquityContract.ConId = 0;
                genericEquityContract.Currency = currency;
                genericEquityContract.Exchange = exchange;

                if (String.IsNullOrEmpty(secType))
                {
                    if (symbol.Length < 6)
                        genericEquityContract.SecType = "STK";
                    else
                        genericEquityContract.SecType = "OPT";
                }
                else
                {
                    genericEquityContract.SecType = secType;
                }

                genericEquityContract.Symbol = symbol;

                genericEquityContract.LocalSymbol = getLocalSymbol(genericEquityContract);
                return genericEquityContract;
            }

            public static string getText(Contract contract)
            {
                return String.Format("{0} {1} {2} {3}", contract.Symbol, contract.Strike, contract.Right, contract.LastTradeDateOrContractMonth);
            }

            public static string getLocalSymbol(Contract contract)
            {
                if (contract == null) return "";
                if (String.IsNullOrEmpty(contract.Symbol)) return "";

                if (contract.SecType.Equals("CASH")) return "";

                if (String.IsNullOrEmpty(contract.Right)) return contract.Symbol;
                if (String.IsNullOrEmpty(contract.LastTradeDateOrContractMonth)) return contract.Symbol;
                if (contract.Strike == 0) return contract.Symbol;

                string exp = contract.LastTradeDateOrContractMonth;
                if (exp.Length == 8)
                {
                    exp = exp.Substring(2, 6);
                }

                return String.Format("{0,-6}{1}{2}{3:D8}", contract.Symbol, exp, contract.Right[0], (int)(contract.Strike * 1000));

            }

            public static string uniqueKey(Contract contract)
            {
                string r = String.IsNullOrEmpty(contract.Right) ? "" : (contract.Right);
                if (!r.Equals("Call") && !r.Equals("Put") && !r.Equals("C") && !r.Equals("P")) r = "";
                string d = String.IsNullOrEmpty(contract.LastTradeDateOrContractMonth) ? "" : (contract.LastTradeDateOrContractMonth);
                
                string data = ContractDefinition.Tools.getLocalSymbol(contract) + contract.Symbol + contract.Currency + r+d;
                
                return data;
            }

        }
        public class AuxOrderInfo
        {
            public double brackerStop = 0;
            public double bracketTarget = 0;
            public double parentLmt = 0;
            public double parentAux = 0;
            public double parentTrailAmt = 0;
            public double stopTrailAmt = 0;
            public double targetTrailAmt = 0;
            public double bracketStopLmt = 0;
            public double bracketTargetAux = 0;
            public int qty = 0;
            public bool applyConditions = true;

        }

        public bool marked; // to comply with legacy method
        public int reservedRequestId;  // OR BETTER just include marked ones, and give ibWrapper the expected reuqest id (Which is probably not needed, because c# handles it)
        public int id;
        public string name = "";
        public Contract contract;
        public Contract underlying; //kept for legacy, avoid not to have some weird situations
        public ContractDefinition underlyingContractDefinition;
        public List<OperatorCondition> conditions = new List<OperatorCondition>();
        public AuxOrderInfo auxOrderInfo;
        public TickDefinition.TickInfo tickInfo = new TickDefinition.TickInfo();
        public string genericTicks = "";

        public string Text
        {
            get
            {
                // return String.Format("{0} {1} {2} {3}", contract.Symbol, contract.Strike, contract.Right, contract.LastTradeDateOrContractMonth);
                return Tools.getText(contract);
            }
        }
        public static ContractDefinition genDefaultContractDefinition(string symbol, string sectype, string expiry)
        {
            ContractDefinition cd = new ContractDefinition();
            cd.contract.Symbol = symbol;
            cd.contract.Currency = "USD";
            cd.contract.SecType = sectype;
            cd.contract.LastTradeDateOrContractMonth = expiry;

            cd.contract.Exchange = "SMART";
            cd.contract.Right = "Call";
            PriceCondition pc = new PriceCondition();
            pc.IsMore = true;
            pc.Type = OrderConditionType.Price;
            pc.IsConjunctionConnection = true;
            pc.Price = 1;
            pc.ConId = 0;
            pc.TriggerMethod = IBApi.TriggerMethod.Default;

            cd.conditions.Add(pc);

            DateTime dtnow = DateTime.Now;

            string dnew = dtnow.ToString("yyyyMMdd");

            TimeCondition tc = new TimeCondition();
            tc.Type = OrderConditionType.Time;
            tc.IsMore = true;
            tc.IsConjunctionConnection = true;
            tc.Time = String.Concat(dnew, " 09:30:00 EST");
            cd.conditions.Add(tc);

            tc = new TimeCondition();
            tc.Type = OrderConditionType.Time;
            tc.IsMore = false;
            tc.IsConjunctionConnection = true;
            tc.Time = String.Concat(dnew, " 11:00:00 EST");
            cd.conditions.Add(tc);

            return cd;
        }

        public string generatedLocalSysmbol
        {
            get
            {
                return Tools.getLocalSymbol(contract);
            }
        }


        public ContractDefinition()
        {
            contract = new Contract();
            underlying = new Contract();
            auxOrderInfo = new AuxOrderInfo();

        }
    }

}
