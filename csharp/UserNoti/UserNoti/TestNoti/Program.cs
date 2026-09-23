using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestNoti
{
    class Program
    {
        static void Main(string[] args)
        {
            
            // Subscribe to foreground event
            listener.NotificationChanged += Listener_NotificationChanged;

            private void Listener_NotificationChanged(UserNotificationListener sender, UserNotificationChangedEventArgs args)
            {
                // Your code for handling the notification
            }
        }
    }
}
