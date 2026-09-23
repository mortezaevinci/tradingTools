using System;
using MHA;
using System.IO;

namespace convertto2
{
    class Program
    {
        static void Main(string[] args)
        {


            string searchdir = @"Q:\My files\Project Trading\traderdata\book\";

            string[] files =     Directory.GetFiles(searchdir, "*.bin", SearchOption.AllDirectories);

            foreach (string file in files)
            {
                try
                {

                    string desfile = String.Concat(file.Substring(0, file.Length - 3), "bn2");

                    string inputfilename = String.Concat(file);
                    string filename = String.Concat(desfile);

                    MarketDataDefinition mdd = new MarketDataDefinition();

                    FileStream inputstream = new System.IO.FileStream(inputfilename, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read);
                    FileStream stream = new System.IO.FileStream(filename, System.IO.FileMode.OpenOrCreate, System.IO.FileAccess.Write, System.IO.FileShare.Write); ;// File.Open("t1.bn2", FileMode.Append);

                    //mdd.convertTo2(inputstream, stream);

                    System.Runtime.Serialization.Formatters.Binary.BinaryFormatter bf = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
                    while (inputstream.Length != inputstream.Position)
                    {
                        try
                        {
                            mdd = (MarketDataDefinition)bf.Deserialize(inputstream);

                            mdd.writeSimpleBinary(stream);
                        }
                        catch
                        {
                            break;
                        }
                    }

                    inputstream.Close();
                    stream.Close();
                }
                catch { }
            }
        }
    }
}
