using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.ApplicationModel;
using Windows.UI.Notifications;
using Windows.UI.Notifications.Management;

namespace MHA
{
    public class BasicUserNotification
    {
        public sealed class UserNotification
        {
            public AppInfo AppInfo { get; }
            public DateTimeOffset CreationTime { get; }
            public uint Id { get; }
            public Notification Notification { get; }
        }

        public UserNotificationListener listener;


        public void Init()
        {
            listener = UserNotificationListener.Current;



        }
    }
}
