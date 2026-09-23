using System;
using MHA;
using System.IO;

namespace testDeserialize
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");

            FileStream inputstream = new System.IO.FileStream(@"Q:\My files\Project Trading\matlab\traderdata\book\AAL_book_history.bin", System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read);


            System.Runtime.Serialization.Formatters.Binary.BinaryFormatter bf = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
             while(inputstream.Length != inputstream.Position)
                {
                try
                {
                    MHA.MarketDataDefinition mdd = (MHA.MarketDataDefinition)bf.Deserialize(inputstream);
                    Console.WriteLine(mdd.dateTime);
                }
                catch
                {
                 break;
                }
            }
        }
    }
}
