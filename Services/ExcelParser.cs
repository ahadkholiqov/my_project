using ClosedXML.Excel;

namespace Login_to_EduHub.Services
{
    public class ScheduleRow
    {
        public string GroupName { get; set; } = "";
        public string SubjectName { get; set; } = "";
        public string TeacherName { get; set; } = "";
        public TimeSpan StartTime { get; set; }
        public string Building { get; set; } = "";
        public string RoomNumber { get; set; } = "";
        public string Shift { get; set; } = "";
        public int CycleNumber { get; set; } = 1;
        public string DaySlots { get; set; } = "";
        public int DeclaredDayCount { get; set; } = 0;
        public int ActualDayCount { get; set; } = 0;
        public bool HasDayCountMismatch { get; set; } = false;
        public string? Warning { get; set; }
    }
    public class ParseResult
    {
        public List<ScheduleRow> Rows { get; set; } = new();
        public List<string> Errors { get; set; } = new();
        public bool HasCriticalError { get; set; } = false;
        public string? CriticalErrorDetail { get; set; }
    }

    public class ExcelParser
    {
        private static bool IsCellFilled(IXLCell cell)
        {
            try
            {
                var val = cell.GetValue<string>().Trim();
                return !string.IsNullOrEmpty(val) && val != "0";
            }
            catch { return false; }
        }
        public ParseResult Parse(Stream fileStream, int cycleNumber = 1)
        {
            var result = new ParseResult();
            string currentGroup = "";

            try
            {
                using var workbook = new XLWorkbook(fileStream);
                var ws = workbook.Worksheet(1);
                int lastRow = ws.LastRowUsed()?.RowNumber() ?? 0;

                if (lastRow == 0)
                {
                    result.HasCriticalError = true;
                    result.CriticalErrorDetail = "Файл пустой или не содержит данных.";
                    return result;
                }

                for (int rowNum = 1; rowNum <= lastRow; rowNum++)
                {
                    try
                    {
                        var row = ws.Row(rowNum);
                        string lessonType = row.Cell(8).GetValue<string>().Trim();
                        if (lessonType != "Дарс") continue;

                        string groupVal = row.Cell(2).GetValue<string>().Trim();
                        string subject = row.Cell(3).GetValue<string>().Trim();
                        string teacher = row.Cell(4).GetValue<string>().Trim();
                        // Корпус и аудитория — последние непустые ячейки в строке (после col28)
                        string building = "";
                        string room = "";
                        var lastCols = new List<string>();
                        for (int c = 29; c <= 35; c++)
                        {
                            var v = row.Cell(c).GetValue<string>().Trim();
                            if (!string.IsNullOrEmpty(v))
                                lastCols.Add(v);
                        }
                        if (lastCols.Count >= 2) { building = lastCols[0]; room = lastCols[1]; }
                        else if (lastCols.Count == 1) { building = lastCols[0]; }

                        if (string.IsNullOrWhiteSpace(subject))
                        {
                            result.Errors.Add($"Строка {rowNum}: тип 'Дарс' но предмет пустой — пропущено.");
                            continue;
                        }

                        if (!string.IsNullOrWhiteSpace(groupVal))
                            currentGroup = groupVal;

                        if (string.IsNullOrWhiteSpace(currentGroup))
                        {
                            result.Errors.Add($"Строка {rowNum}: не удалось определить группу — пропущено.");
                            continue;
                        }
                        TimeSpan startTime = TimeSpan.Zero;
                        var timeCell = row.Cell(9);
                        try
                        {
                            if (timeCell.DataType == XLDataType.TimeSpan)
                                startTime = timeCell.GetTimeSpan();
                            else if (timeCell.DataType == XLDataType.DateTime)
                                startTime = timeCell.GetDateTime().TimeOfDay;
                            else
                            {
                                var str = timeCell.GetValue<string>().Trim().Replace("::", ":");
                                if (TimeSpan.TryParse(str, out var parsed))
                                    startTime = parsed;
                                else
                                    result.Errors.Add($"Строка {rowNum}: не удалось прочитать время '{str}', установлено 00:00.");
                            }
                        }
                        catch
                        {
                            result.Errors.Add($"Строка {rowNum}: ошибка чтения времени, установлено 00:00.");
                        }

                        string shift = startTime.Hours < 12 ? "1" : "2";
                        // Колонки 11-28 = слоты дней 1-18
                        var slots = new char[18];
                        int actualCount = 0;
                        for (int col = 11; col <= 28; col++)
                        {
                            if (IsCellFilled(row.Cell(col)))
                            {
                                slots[col - 11] = '1';
                                actualCount++;
                            }
                            else
                            {
                                slots[col - 11] = '0';
                            }
                        }
                        string daySlots = new string(slots);

                        int declaredCount = 0;
                        try
                        {
                            declaredCount = row.Cell(10).GetValue<int>();
                        }
                        catch { }

                        bool mismatch = declaredCount > 0 && declaredCount != actualCount;
                        string? warning = mismatch
                            ? $"Строка {rowNum} ({subject}, {currentGroup}): Миқдори рӯз={declaredCount}, найдено дней={actualCount}."
                            : null;

                        if (warning != null)
                            result.Errors.Add(warning);
                        result.Rows.Add(new ScheduleRow
                        {
                            GroupName = currentGroup,
                            SubjectName = subject,
                            TeacherName = teacher,
                            StartTime = startTime,
                            Building = building,
                            RoomNumber = room,
                            Shift = shift,
                            CycleNumber = cycleNumber,
                            DaySlots = daySlots,
                            DeclaredDayCount = declaredCount,
                            ActualDayCount = actualCount,
                            HasDayCountMismatch = mismatch,
                            Warning = warning
                        });
                    }
                    catch (Exception rowEx)
                    {
                        result.Errors.Add($"Строка {rowNum}: неожиданная ошибка — {rowEx.Message}");
                    }
                }
            }
            catch (Exception ex)
            {
                result.HasCriticalError = true;
                result.CriticalErrorDetail = $"Не удалось открыть файл: {ex.Message}";
            }

            return result;
        }
    }
}