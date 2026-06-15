namespace Login_to_EduHub.Services;

public class SemesterCalendarService
{
    private static readonly List<string> Topics = new()
    {
        "1", "2", "3", "4", "5", "6", "7",
        "ЧР1/8", "ЧР1/9",
        "10", "11", "12", "13", "14", "15", "16",
        "ЧР2/17", "ЧР2/18",
        "ЧС", "КИН", "ИН", "ИН"
    };

    public Dictionary<DateTime, (string DayType, int? Cycle, bool IsHoliday)> Generate(
    DateTime startDate,
    DateTime endDate,
    List<DateTime> holidays)
    {
        var calendar = new Dictionary<DateTime, (string DayType, int? Cycle, bool IsHoliday)>();

        for (DateTime d = startDate; d <= endDate; d = d.AddDays(1))
        {
            if (d.DayOfWeek == DayOfWeek.Sunday)
                calendar[d] = ("В", null, false);
            else if (holidays.Contains(d.Date))
                calendar[d] = ("П", null, true);
            else
                calendar[d] = ("", null, false);
        }

        var dates = calendar.Keys.OrderBy(d => d).ToList();

        // Заполняем Циклы 1-4 по будним дням (пн-пт)
        int currentIndex = 0;
        DateTime cycle4EndDate = DateTime.MinValue;

        for (int cycle = 1; cycle <= 4; cycle++)
        {
            int topicIndex = 0;
            while (topicIndex < Topics.Count && currentIndex < dates.Count)
            {
                DateTime current = dates[currentIndex];
                var (dayType, _, _) = calendar[current];

                if (dayType == "" && current.DayOfWeek != DayOfWeek.Saturday)
                {
                    calendar[current] = (Topics[topicIndex], cycle, false);
                    topicIndex++;
                    if (cycle == 4)
                        cycle4EndDate = current;
                }
                currentIndex++;
            }
        }

        // Заполняем Цикл 5
        // Фаза 1 — субботы пока идут Циклы 1-4
        int cycle5TopicIndex = 0;

        var saturdays = dates
            .Where(d => d.DayOfWeek == DayOfWeek.Saturday
                     && calendar[d].DayType == ""
                     && (cycle4EndDate == DateTime.MinValue || d <= cycle4EndDate))
            .OrderBy(d => d)
            .ToList();

        foreach (var sat in saturdays)
        {
            if (cycle5TopicIndex < Topics.Count)
            {
                calendar[sat] = (Topics[cycle5TopicIndex] + " (Суб)", 5, false);
                cycle5TopicIndex++;
            }
        }

        // Фаза 2 — остаток Цикла 5 по будням после окончания Цикла 4
        var remainingDays = dates
            .Where(d => calendar[d].DayType == ""
                     && d.DayOfWeek != DayOfWeek.Sunday
                     && d > cycle4EndDate)
            .OrderBy(d => d)
            .ToList();

        foreach (var day in remainingDays)
        {
            if (cycle5TopicIndex < Topics.Count)
            {
                calendar[day] = (Topics[cycle5TopicIndex], 5, false);
                cycle5TopicIndex++;
            }
        }

        return calendar;
    }
}