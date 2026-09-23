using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using Microsoft.SqlServer.Server;

namespace MHA
{ 
    [Serializable]
    public class MarketBeatRatingsDefinition
    {
        public enum ActionType
        {
            TargetRaised,
            Upgraded,
            Reiterated,
            Initiated,
            TargetLowered,
            Downgraded,
            TargetSet

        }


        public enum ImplactOnPriceType
        {
            NA,
            VeryLow,
            Low,
            Neutral,
            Medium,
            High,
            VeryHigh
        }


        public enum RatingType
        {
            Sell,
            SpeculativeSell,
            Underperform,
            Underweight,
            Negative,
            Reduce,
            Neutral,
            EqualWeight,
            Hold,
            Increase,
            Positive,
            Overweight,
            Outperform,
            SectorPerform,
            MarketPerform,
            SpeculativeBuy,
            Buy,
            NotSet
        }


        public void Add(DateTime datetime,string s,string a,string b,string t,string r,string i)
        {
            RatingsAndTargets rt = new RatingsAndTargets();
            rt.dateTime = datetime;
            rt.symbol = s;
            rt.setAction(a);
            rt.brokerage = b;
            rt.setTarget(t);
            rt.setRating(r);
            rt.setImpact(i);

            string rtu = rt.uniqueKey();

            int rtcnt = ratingsAndTargets.Count;
            for (int ii=0;ii<rtcnt;ii++)
            {
                string rtu2 = ratingsAndTargets[ii].uniqueKey();
                if (rtu.Equals(rtu2))
                {
                    return;
                }
            }


            ratingsAndTargets.Add(rt);
        }

        [Serializable]
        public class RatingsAndTargets
        {
            public DateTime dateTime;
            public string symbol;
            protected string action;
            public string brokerage;
            protected string priceTarget;
            protected string rating;
            protected string impactOnPrice;
            public ImplactOnPriceType impactOnPriceType;
            public RatingType ratingTypeFrom;
            public RatingType ratingTypeTo;
            public ActionType actionType;

            public double targetFrom;
            public double targetTo;

            public string other1;
            public string other2;
            public string other3;


            public string toCSV()
            {
                string newLine = string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}",
                    symbol,dateTime.ToString("yyyy-MM-dd"),action,brokerage,priceTarget,rating,impactOnPrice,actionType.ToString(),targetFrom,targetTo,ratingTypeFrom.ToString(),ratingTypeTo.ToString()
                    );
                return newLine;
            }

            public RatingType getRatingType(string r)
            {
                if (r.Equals("Sell")) return RatingType.Sell;
                if (r.Equals("Buy")) return RatingType.Buy;
                if (r.Contains("Underperform ")) return RatingType.Underperform;
                if (r.Contains("Outperform")) return RatingType.Outperform;
                if (r.Contains("Underweight")) return RatingType.Underweight;
                if (r.Contains("Negative")) return RatingType.Negative;
                if (r.Contains("Speculative Sell")) return RatingType.SpeculativeSell;
                if (r.Contains("Speculative Buy")) return RatingType.SpeculativeBuy;
                if (r.Contains("Reduce")) return RatingType.Reduce;
                if (r.Contains("Neutral")) return RatingType.Neutral;
                if (r.Contains("Equal Weight")) return RatingType.EqualWeight;
                if (r.Contains("Hold")) return RatingType.Hold;
                if (r.Contains("Increase")) return RatingType.Increase;
                if (r.Contains("Positive")) return RatingType.Positive;
                if (r.Contains("Overweight")) return RatingType.Overweight;
                if (r.Contains("Market Perform")) return RatingType.SectorPerform;
                if (r.Contains("Sector Perform")) return RatingType.MarketPerform;
                return RatingType.NotSet;
            }

            public void setRating(string r)
            {
                rating=r;

                string[] ratings= r.Split(new char[] { '➝' });

                if (ratings.Count() <=1)
                {
                    ratings = new string[2];
                    ratings[0] = "";
                    ratings[1] = r;
                }
                for (int i = 0; i < 2; i++)
                {
                    //cleanup
                   string temp= ratings[i].Trim(new char[] { ' '});
                    RatingType rt = getRatingType(temp);
                    if (i == 0) ratingTypeFrom = rt;
                    if (i == 1) ratingTypeTo = rt;
                }
            }

            public void setTarget(string t)
            {
                priceTarget = t;

                string[] targets = t.Split(new char[] { '➝' });

                if (targets.Count()<=1)
                {
                    targets = new string[2];
                    targets[0] = "";
                    targets[1] = t;
                }
                for (int i=0;i<2;i++)
                {
                    try
                    {
                        //cleanup
                        string temp = targets[i].Trim(new char[] { ' ', '$', '€' ,'C','G','B','X',','});
                        if (temp.Equals("")) continue;
                        double parsed = Double.Parse(temp);
                        if (i == 0) targetFrom = parsed;
                        if (i == 1) targetTo = parsed;
                    }
                    catch
                    {
                        Console.WriteLine(t);
                    }
                }



            }

            public void setAction(string a)
            {
                action = a;
                if (a.Contains("Target Raised")) actionType = ActionType.TargetRaised;
                if (a.Contains("Upgraded")) actionType = ActionType.Upgraded;
                if (a.Contains("Downgraded")) actionType = ActionType.Downgraded;
                if (a.Contains("Initiated")) actionType = ActionType.Initiated;
                if (a.Contains("Lowered")) actionType = ActionType.TargetLowered;
                if (a.Contains("Reiterated")) actionType = ActionType.Reiterated;
                if (a.Contains("Set")) actionType = ActionType.TargetSet;
            }

            public void setImpact(string i)
            {
                impactOnPrice = i;
                if (i.Contains("N/A")) impactOnPriceType = ImplactOnPriceType.NA;
                if (i.Contains("Low")) impactOnPriceType = ImplactOnPriceType.Low;
                if (i.Contains("Medium")) impactOnPriceType = ImplactOnPriceType.Medium;
                if (i.Contains("High")) impactOnPriceType = ImplactOnPriceType.High;
                
            }

        
            public string uniqueKey()
            {
                return String.Concat(dateTime.ToString("yyyyMMdd"),symbol, action, brokerage, priceTarget, rating);
            }
        }

        public List<RatingsAndTargets> ratingsAndTargets;

        public MarketBeatRatingsDefinition()
        {
            ratingsAndTargets = new List<RatingsAndTargets>();
        }

        public void saveCSV(string filename)
        {
            //before your loop
            StringBuilder csv = new StringBuilder();

            //in your loop
            int rcnt = ratingsAndTargets.Count;
            for (int i = 0; i < rcnt; i++)
            {
                RatingsAndTargets rt = ratingsAndTargets[i];
             
                csv.AppendLine(rt.toCSV());
            }
            //after your loop
            File.WriteAllText(filename, csv.ToString());
        }

        public void save(string filename)
        {
            FileStream fs = new FileStream(filename,FileMode.Create);
            BinaryFormatter formatter = new BinaryFormatter();
            try
            {
                int datacount = ratingsAndTargets.Count;
                /*
                formatter.Serialize(fs, datacount);
                for (int i = 0; i < datacount; i++)
                {
                    formatter.Serialize(fs, ratingsAndTargets[i]);
                }
                */
                formatter.Serialize(fs, ratingsAndTargets);
            }
            catch (SerializationException e)
            {
                Console.WriteLine("Failed to serialize. Reason: " + e.Message);
                throw;
            }
            finally
            {
                fs.Close();
            }
        }

        public void open(string filename)
        {
            FileStream fs = new FileStream(filename, FileMode.Open);

            try
            {
                BinaryFormatter formatter = new BinaryFormatter();
                ratingsAndTargets = (List<RatingsAndTargets>)formatter.Deserialize(fs);
               
            }
            catch (SerializationException e)
            {
                Console.WriteLine("Failed to deserialize. Reason: " + e.Message);
                throw;
            }
            finally
            {
                fs.Close();
            }
        }

    }
}
