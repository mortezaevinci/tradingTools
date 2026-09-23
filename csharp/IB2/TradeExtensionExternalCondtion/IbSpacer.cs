using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace MHA
{
    public static class IbSpacer
    {
        public static Semaphore _pool_space = new Semaphore(1, 1);
        public static int spaceMillis;
        public static DateTime lastDatetime;

        public static void Init(int spacemillis)
        {
            spaceMillis = spacemillis;
            lastDatetime = DateTime.Now;
        }

        public static void WaitForSpace()
        {
            _pool_space.WaitOne();
            try
            {
                while ((DateTime.Now - lastDatetime).TotalMilliseconds < spaceMillis) ;
                lastDatetime = DateTime.Now;
            }
            catch { }
            _pool_space.Release();
        }
    }
}
