using IBApi.messages;
using System;
using System.IO;

namespace MHA
{
  
    public class IBLog
    {
        StreamWriter logger;


        public void init(string filename)
        {
            logger = new StreamWriter(filename, true);

        }

        public void WriteLine(string str)
        {
            logger.WriteLine(str);
        }

        public void Write(string str)
        {

        }

        public void Close()
        {
            logger.Close();
        }
    }
}
