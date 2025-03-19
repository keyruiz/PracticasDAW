namespace objetos2
{
    /// <summary>
    /// Clase que acumula años, meses, días, horas, minutos y segundos a la misma fecha
    /// </summary>
    public class DateAndTime
    {
        private int _year;
        private int _month;
        private int _day;
        private int _hour;
        private int _minutes;
        private int _seconds;

        // clase fechas mutables, horas... private, constructor pa pasarlo todo, el getter add()

        public DateAndTime(int y, int m, int d, int h, int min, int s)
        {
            Add(y ,m ,d ,h ,min ,s);
        }

        public DateAndTime()
        {

        }

        public int GetYear()
        {
            return _year;
        }
        public int GetMonth()
        {
            return _month;
        }

        public int GetDay()
        {
            return _day;
        }

        public int GetHour()
        {
            return _hour;
        }
        public int GetMinutes()
        {
            return _minutes;
        }

        public int GetSeconds()
        {
            return _seconds;
        }        

        /*public int DiasMesMal(int y, int mes)
        {
            if (mes == 2)
            {
                int div = IsBisiesto(y) ? 29 : 28;
                return div;
            }
            if (IsEven(mes) && mes != 8)
                return 30;
            return 31;
        }//esta mal*/

        private int DiasMes(int y, int mes)
        {
            if (mes == 2)
            {
                int div = IsBisiesto(y) ? 29 : 28;
                return div;
            }
            List<int> meses31 = new() { 01, 03, 05, 07, 08, 10, 12 };
            for (int i = 0; i < meses31.Count; i++)
            {
                if (mes == meses31[i])
                    return 31;
            }
            return 30;
        }
        public void Add(int year)
        {
            Reset(ref year);
            /*if (year < 0)
                return;*/    
            _year += year;
        }

        public void Add(int year, int months)
        {
            /*if (year < 0 || months < 0)
                return;*/
            Reset(ref months);
            Add(year);
            int aumentoYear = months / 13;
            _month += months % 13;
            /*if (Month == 0)
                Month++;*/
            if (aumentoYear != 0)
                _year += aumentoYear;
        }
        public void Add(int year, int months, int day)
        {
            /*if (year < 0 || months < 0 || day < 0)
                return;*/
            Reset(ref day);
            int diasMes = DiasMes(_year, _month);
            while (day > diasMes)
            {
                day = day - diasMes;
                Add(0, 1);// añado mes
                diasMes = DiasMes(_year, _month); // dias sigueinte mes
            }
            _day += day;
        }

        public void Add(int year, int months, int day, int hour)
        {
            /*if (year < 0 || months < 0 || day < 0 || hour < 0)
                return;*/
            Reset(ref hour);
            Add(year, months, day);
            int aumentoDias = hour / 24;
            _hour += hour % 24;
            if (aumentoDias != 0)
                Add(0, 0, aumentoDias);
        }
        public void Add(int year, int months, int day, int hour, int minute)
        {
            /*if (year < 0 || months < 0 || day < 0 || hour < 0 || minute < 0)
                return;*/
            Reset(ref minute);
            Add(year, months, day, hour);
            int aumentoHours = minute / 60;
            _minutes += minute % 60;
            if (aumentoHours != 0)
                Add(0, 0, 0, aumentoHours);
            
        }
        public void Add(int year, int months, int day, int hour, int minute, int second)
        {
            /*if (year < 0 || months < 0 || day < 0 || hour < 0 || minute < 0 || second < 0)
                return;*/
            Reset(ref second);
            Add(year, months, day, hour, minute);
            int aumentoMinutes = second / 60;
            _seconds += second % 60;
            if (aumentoMinutes != 0)
                Add(0,0,0,0, aumentoMinutes);
        }
        private bool IsBisiesto(int y)
        {
            if (y % 400 == 0)
                return true;
            return y % 4 == 0 && y % 100 != 0;
        }


        private void Reset(ref int num)
        {
            if (num < 0)
                num = 0;
        }
    }
}
