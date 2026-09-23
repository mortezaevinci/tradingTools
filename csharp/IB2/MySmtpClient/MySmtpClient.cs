using System;
using System.Net;
using System.Net.Mail;

namespace MHA
{
    public class MySmtpClient
    {
        MailAddress _from;
        SmtpClient smtp;
        public MySmtpClient(MailAddress from, string password)
        {
            _from = from;

            smtp = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(from.Address, password),
                Timeout = 20000


            };
        }

        public void Send(MailAddress to, string subject, string body)
        {
            using (var message = new MailMessage(_from, to)
            {
                Subject = subject,
                Body = body
            })
            {
                try
                {
                    smtp.Send(message);
                }
                catch (SmtpException ex)
                {
                    try
                    {
                        Console.WriteLine(ex.Message);
                        smtp.Send(message);
                    }
                    catch { }
                }

            }
        }
    }
}
