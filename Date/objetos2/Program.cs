namespace objetos2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            DateAndTime date = new DateAndTime(0,0,0,0,0,0);
            /*date.Add(2005, 30, 60, 40, 100, 12);*/
            date.Add(2023, -5);
            int d = 100 % 60;
            int c =100 /60;

            Console.WriteLine(d);
            Console.WriteLine(c);


            //para cosas iterables, osea recorrer todo algo, evitas for,
            //* Desventajas
            /*foreach (var d in dateList)
            {
                
            }*/
        }
    }
}
