using System;
using System.IO;
using MHA;

namespace testSerialize
{
    class Program
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            MarketDataDefinition mdd2 = new MarketDataDefinition();

            mdd2.dateTime = DateTime.Now;
           

            for (int i = 0; i < 8; i++)
            {
                for (int j = 0; j < 120; j++)
                {
                    mdd2.components[i, j] = j;
                }
            }

            using (Stream stream = File.Open("t1.bn2", FileMode.Append))
            {
                mdd2.writeSimpleBinary(stream);
                
            }
        }
    }
}
