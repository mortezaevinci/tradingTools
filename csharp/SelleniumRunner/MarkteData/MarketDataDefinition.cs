using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace MHA
{
    [Serializable]
    public class MarketDataDefinition
    {
        public DateTime dateTime;
        public String dateTimeString;
        public float[,] components = new float[8, 120];

        public DateTime datetime()
        {
            return dateTime;
        }

        public string dtstring()
        {
            return dateTimeString;
        }
        public float[,] c()
        {
            return components;
        }


        public void writeSimpleBinary(Stream stream)
        {
            BinaryWriter binWriter = new BinaryWriter(stream);

          
            uint posixDatetime = (UInt32)(dateTime.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;

            binWriter.Write(posixDatetime);

            byte[] dd = new byte[28];
            binWriter.Write(dd);
          
                for (int i = 0; i < 8; i++)
                {
                for (int j = 0; j < 120; j++)
                {
                    binWriter.Write(components[i, j]);
                }
            }
        }

       

    }
}
