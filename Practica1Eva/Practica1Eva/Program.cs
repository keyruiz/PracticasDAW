namespace Practica1Eva
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(Funciones.IsDNI("487998630"));
            Console.WriteLine(Funciones.GetLong("12345"));
            Console.WriteLine(Funciones.HashDJB2("hello"));
            Console.WriteLine(Funciones.HashDJB2("hella"));
            //Funciones.Split("Hola.nume.eio.rpe.st",'.');

            //Console.WriteLine(Funciones.IsEmail("@mail.co"));
            //Console.WriteLine(Funciones.GetDate("2012/02/29-24:00:00"));

            string a = "jajaJAJAJAJA";
            Funciones.MayusMinus(ref a, true);
            Console.WriteLine(Funciones.GetDateString(1899,11,16,23,00,07));
        }

    }
}
