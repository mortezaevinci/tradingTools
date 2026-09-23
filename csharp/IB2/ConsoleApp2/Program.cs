using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp2
{
    class Program
    {
        static void Main(string[] args)
        {
			System.Globalization.CultureInfo newYork = new System.Globalization.CultureInfo("en-US-NY");


			DateTimeOffset _dateo = DateTimeOffset.ParseExact("20200610", "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);

			TimeZoneInfo tz0 = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
			TimeZoneInfo tz1 = TimeZoneInfo.Local;


			TimeSpan tso0 = tz0.GetUtcOffset(_dateo);
			TimeSpan tso1 = tz1.GetUtcOffset(_dateo);
			Console.WriteLine(-tso0.Hours+tso1.Hours);

			_dateo = _dateo.AddHours(-tso0.Hours + tso1.Hours);

			Console.WriteLine(_dateo.ToUnixTimeSeconds());
			Console.ReadKey();
		}
    }
}
