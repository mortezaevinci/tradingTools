using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Threading;

namespace MHA
{
    public class BasicLogger
    {
        private static StreamWriter logger=null;
        private static Semaphore _pool_logger = new Semaphore(1, 1);
        private static Thread workerLogger;
        private static bool workerRun = true;
        private static Queue<string> ss=new Queue<string>();
        public BasicLogger()
        {

        }
            public BasicLogger(string filename)
        {
            if (logger!=null)
            {
                try
                {
                    logger.Close();
                    logger = null;

                }
                catch { }
            }
            logger = new StreamWriter(filename, true);
            logger.WriteLine(">>>{0}", DateTime.Now);

            workerLogger = new Thread(() => threadWrite());
            workerLogger.Start();
        }

        public void WriteLine(string s)
        {
            if (logger == null) return;

            try
            {
                Write(String.Format("{0}:\t{1}\n",DateTime.Now.ToString("HH:mm:ss"), s));
                
            }
            catch { }
          
        }

        private void threadWrite()
        {
            while(workerRun)
            {
                while(ss.Count>0)
                {
                    _pool_logger.WaitOne();
                    try
                    {
                        string s = ss.Dequeue();
                        logger.Write(s);
                    }
                    catch { }
                    _pool_logger.Release();
                }
            }
        }

            public void Write(string s)
        {
            if (logger == null) return;
            _pool_logger.WaitOne();
            try { 
            ss.Enqueue(s);
            }
            catch { }
            _pool_logger.Release();
        }

        /*
            public void Write(string s)
        {
            if (logger == null) return;
            _pool_logger.WaitOne();
            try
            {
                logger.Write(s);
            }
            catch { }
            _pool_logger.Release();
        }
        */

        public void Flush()
        {
            if (logger == null) return;
            _pool_logger.WaitOne();
            logger.Flush();
            _pool_logger.Release();
        }

        public void Close()
        {
            if (logger == null) return;
            workerRun = false;
            workerLogger.Join(5000);
            logger.Close();
        }
    }
}
