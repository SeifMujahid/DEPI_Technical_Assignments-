using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdvancedC_
{
    public static class DateTimeExtensions
    {
        public static DateTime StartOfWeek(this DateTime dt) =>
        dt.AddDays(-(int)dt.DayOfWeek);

        public static DateTime EndOfWeek(this DateTime dt) =>
            dt.StartOfWeek().AddDays(6);

        public static DateTime StartOfMonth(this DateTime dt) =>
            new DateTime(dt.Year, dt.Month, 1);

        public static DateTime EndOfMonth(this DateTime dt) =>
            dt.StartOfMonth().AddMonths(1).AddDays(-1);

        public static DateTime StartOfYear(this DateTime dt) =>
            new DateTime(dt.Year, 1, 1);

        public static DateTime EndOfYear(this DateTime dt) =>
            new DateTime(dt.Year, 12, 31);

        public static int Age(this DateTime birthDate) =>
            (int)((DateTime.Now - birthDate).TotalDays / 365.25);

        public static bool IsBusinessDay(this DateTime dt) =>
            dt.DayOfWeek != DayOfWeek.Saturday && dt.DayOfWeek != DayOfWeek.Friday;

    }
}
