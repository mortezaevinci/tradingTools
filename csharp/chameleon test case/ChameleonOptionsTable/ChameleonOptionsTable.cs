using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MHA
{
    [Serializable]
    public class ChameleonOptionsTable
    {

      

        [Serializable]
        public class OptionsTable
        {
            [Serializable]
            public class OpenDetails
            {
                int res = 0;
            }
            public string chameleonRow;
            public OpenDetails Details;
            public string Time;
            public string Symbol;
            public string OptionExpiration;
            public string Type;
            public double Strike;
            public double SpotPrice;
            public int OpenInterest;  //remove commas from text
            public int TradeQty;
            public double TradePrice;
            public double Bid;
            public double Ask;
            public double TradeNotional; // needs to get converted
            public string Side;
            public double TradeIV;
            public double IVChg;
            public double IVRank;
            public string Exch;
            public string Condition;
            public string Execution;
            public double Delta;
            public double BidAskSpread;
            public double TradeEdge;
            public double HistVol20Day;
            public double IVvsHV20day; //remove %
            public double HistVol1Yr;
            public double IVvsHV1Yr; //remove %
            public double QtyPercentAvgVolume; //remove %
            public int DaysToExp;
            public string Event;

            public string BasicInfo()
            {
                return String.Format("{0},{1},{2}{3}{4},{5},{6}",Time,Symbol,OptionExpiration,Type,Strike.ToString(),TradeNotional.ToString(),Side);
            }
        }

        public List<OptionsTable> optionsTables;

        public ChameleonOptionsTable()
        {
            optionsTables = new List<OptionsTable>();
        }

    }
}
