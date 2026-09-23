using MHA;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using Windows.ApplicationModel;
using Windows.UI.Notifications;
using Windows.UI.Notifications.Management;
using Windows.UI.Xaml.Media.Imaging;
using Windows.Storage.Streams;
using System.Diagnostics;
using Windows.Foundation.Metadata;
using System.Threading.Tasks;
using Windows.Data.Xml;
using Windows.Data.Xml.Dom;
using System.Threading;


// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace testapp
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        BasicUserNotification basicUserNotification = new BasicUserNotification();
        public MainPage()
        {
            this.InitializeComponent();
            basicUserNotification.Init();

            XmlDocument toastXml = ToastNotificationManager.GetTemplateContent(ToastTemplateType.ToastImageAndText04);

            // Fill in the text elements
            XmlNodeList stringElements = toastXml.GetElementsByTagName("text");
            for (int i = 0; i < stringElements.Length; i++)
            {
                stringElements[i].AppendChild(toastXml.CreateTextNode("Line " + i));
            }

            // Specify the absolute path to an image
            String imagePath = "file:///" + Path.GetFullPath("toastImageAndText.png");
            XmlNodeList imageElements = toastXml.GetElementsByTagName("image");
            imageElements[0].Attributes.GetNamedItem("src").NodeValue = imagePath;

            // Create the toast and attach event listeners
            ToastNotification toast = new ToastNotification(toastXml);
        


            if (ApiInformation.IsTypePresent("Windows.UI.Notifications.Management.UserNotificationListener"))
            {
                Task<int> t=  reqAccess();

                // t.Wait();
                Thread.Sleep(3000);
                ToastNotificationManager.CreateToastNotifier("testapp").Show(toast);

               basicUserNotification.listener.NotificationChanged += Listener_NotificationChanged;

                Task<int> t2 = getToasts();

                t2.Wait();

                foreach(UserNotification notif in notifs)
                    {
                    Debug.WriteLine(notif.ToString());
                }
            }

            else
            {
                Debug.WriteLine("Not Supported");
            }

         
        }
        IReadOnlyList<UserNotification> notifs;
        private async Task<int> getToasts()
        {
            // Get the toast notifications
             notifs = await basicUserNotification.listener.GetNotificationsAsync(NotificationKinds.Toast);
            return 0;
        }

        private async Task<int> reqAccess()
        {
            UserNotificationListenerAccessStatus accessStatus = await basicUserNotification.listener.RequestAccessAsync();

            switch (accessStatus)
            {
                // This means the user has granted access.
                case UserNotificationListenerAccessStatus.Allowed:

                    // Yay! Proceed as normal
                    break;

                // This means the user has denied access.
                // Any further calls to RequestAccessAsync will instantly
                // return Denied. The user must go to the Windows settings
                // and manually allow access.
                case UserNotificationListenerAccessStatus.Denied:

                    // Show UI explaining that listener features will not
                    // work until user allows access.
                    break;

                // This means the user closed the prompt without
                // selecting either allow or deny. Further calls to
                // RequestAccessAsync will show the dialog again.
                case UserNotificationListenerAccessStatus.Unspecified:

                    // Show UI that allows the user to bring up the prompt again
                    break;
            }
            return 0;
        }

        private void Listener_NotificationChanged(UserNotificationListener sender, UserNotificationChangedEventArgs args)
        {
            // Your code for handling the notification
            UserNotification notif= sender.GetNotification(args.UserNotificationId);


            // Get the app's display name
            string appDisplayName = notif.AppInfo.DisplayInfo.DisplayName;

            // Get the app's logo
            BitmapImage appLogo = new BitmapImage();
        
            // Get the toast binding, if present
            NotificationBinding toastBinding = notif.Notification.Visual.GetBinding(KnownNotificationBindings.ToastGeneric);

            if (toastBinding != null)
            {
                // And then get the text elements from the toast binding
                IReadOnlyList<AdaptiveNotificationText> textElements = toastBinding.GetTextElements();

                // Treat the first text element as the title text
                string titleText = textElements.FirstOrDefault()?.Text;

                // We'll treat all subsequent text elements as body text,
                // joining them together via newlines.
                string bodyText = string.Join("\n", textElements.Skip(1).Select(t => t.Text));

                Debug.WriteLine(titleText);
                Debug.WriteLine(bodyText);
            }

            // Remove the notification
            sender.RemoveNotification(args.UserNotificationId);

            // Clear all notifications. Use with caution.
            //sender.ClearNotifications();
        }
        /*
        public void getToast()
        {
            // Get the toast notifications
            IReadOnlyList<BasicUserNotification.UserNotification> notifs = await BasicUserNotification.listener.GetNotificationsAsync(NotificationKinds.Toast);

            // Select the first notification
            BasicUserNotification.UserNotification notif = notifs[0];

            // Get the app's display name
            string appDisplayName = notif.AppInfo.DisplayInfo.DisplayName;

            // Get the app's logo
            BitmapImage appLogo = new BitmapImage();
            RandomAccessStreamReference appLogoStream = notif.AppInfo.DisplayInfo.GetLogo(new Size(16, 16));
            await appLogo.SetSourceAsync(await appLogoStream.OpenReadAsync());

            // Get the toast binding, if present
            NotificationBinding toastBinding = notif.Notification.Visual.GetBinding(KnownNotificationBindings.ToastGeneric);

            if (toastBinding != null)
            {
                // And then get the text elements from the toast binding
                IReadOnlyList<AdaptiveNotificationText> textElements = toastBinding.GetTextElements();

                // Treat the first text element as the title text
                string titleText = textElements.FirstOrDefault()?.Text;

                // We'll treat all subsequent text elements as body text,
                // joining them together via newlines.
                string bodyText = string.Join("\n", textElements.Skip(1).Select(t => t.Text));
            }

            // Remove the notification
            BasicUserNotification.listener.RemoveNotification(notifId);

            // Clear all notifications. Use with caution.
            BasicUserNotification.listener.ClearNotifications();


        }
        */

    }
}
