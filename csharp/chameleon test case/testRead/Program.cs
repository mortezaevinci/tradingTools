using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using MHA;

namespace testRead
{
    class Program
    {
        static void Main(string[] args)
        {
            ChameleonOptionsTable cot;

        string    dumpfilename = String.Concat(Directory.GetCurrentDirectory(), @"\", "temp ", DateTime.Now.ToString("yyyy-MM-dd"), " .bin");
            FileStream fs = new FileStream(dumpfilename, FileMode.Open);
            try
            {
                BinaryFormatter formatter = new BinaryFormatter();

                // Deserialize the hashtable from the file and
                // assign the reference to the local variable.
                 cot = (ChameleonOptionsTable)formatter.Deserialize(fs);
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

            for (int i = 0; i < cot.optionsTables.Count(); i++)
            {
                Console.WriteLine(cot.optionsTables[i].BasicInfo());
            }


            Console.ReadKey();
        }
    }
}
