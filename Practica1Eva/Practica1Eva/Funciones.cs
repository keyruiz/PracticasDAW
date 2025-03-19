namespace Practica1Eva
{
    public class Funciones
    {
        private static char GetLettter(int num)
        {
            string letrasDNI = "TRWAGMYFPDXBNJZSQVHLCKE";
            int let = num % 23;
            return letrasDNI[let];
        }

        private static char UpperLower(char a, bool MayMin, char c, char c2)  
        {
            if (a >= '0' && a <= '9')
                return a;
            if (a >= c && a <= c2)
                return a;
            if(MayMin)
                return (char)(a - ('a'- 'A'));
            return (char)(a + ('a' - 'A'));
        }
        

        /// <summary>
        /// Valida numero de indentificacion en España (DNI) 
        /// </summary>
        /// <param name="text">el DNI en una cadena de texto</param>
        /// <remarks>
        /// La función sigue los siguientes pasos:
        /// - Comprueba si lo que se le pasa es null o la longitud de la cadena no es 9
        /// - Transforma la letra a mayuscula por si el usuario introduce en minuscula y así siga siendo valido.
        /// - Comprueba si los caracteres de la cadena hasta la posicion 7 son numeros y los va concatenando a una variable <c>numeros</c>
        /// - Tranforma <c>numeros</c> que es un string al número correspondiente con la función 'GetLong' 
        /// - Compruba si la letra es correcta utilizando la función GetLetter, a partir del numero del DNI
        /// </remarks>
        /// <returns>True si el DNI es valido;+
        ///         false en caso contrario.</returns>
        public static bool IsDNI(string text)
        {
            if (text == null || text.Length != 9)
                return false;
            char letra = UpperLower(text[8], true, 'A', 'Z');
            string numeros = "";
            for (int i = 0; i <= 7; i++)
            {
                char c = text[i];
                if (c < '0' && c > '9')
                    return false;
                numeros += c;
            }
            int numDNI = (int)GetLong(numeros);
            return letra == GetLettter(numDNI);
        }

        /*Hacer una función que se le pase un string que contiene un número y devuelva un entero(long).
         * Si el string no contiene un número, debe lanzar una excepción. */

        /// <summary>
        /// Transforma una cadena de texto que contiene un número a long.
        /// </summary>
        /// <remarks>
        /// La función consiste en:
        /// Transformar cada caracter de la cadena según su valor en ascii y concatenandolo a una variable nueva tipo long
        /// </remarks>
        /// <param name="numero">Cadena de texto que contiene un numero</param>
        /// <returns>El número que contiene el string en formato long</returns>
        /// <exception cref="Exception">
        /// En el caso que el usurio no pasa un número, se lanza la excepción.
        /// </exception>
        public static long GetLong(string numero)
        {
            long num = 0;
            for (int i = 0; i < numero.Length; i++)
            {
                char c = numero[i];
                if (c < '0' || c > '9')
                    throw new Exception("Tiene que ser un numero");
                long n = c - '0';
                num = (num + n) * 10;
            }
            return num / 10;
        }

        /// <summary>
        /// Implementa el algoritmo DJB2 para calcular un valor hash a partir de una cadena de texto.
        /// </summary>
        /// <param name="text">La cadena de texto para la cual se calculará el hash.</param>
        /// <returns>Un valor hash de tipo long generado a partir de la cadena de entrada.</returns>
        public static long HashDJB2(string text)
        {
            long hash = 5381; // se empieza con una constante, este es el que se suele poner
            for (int i = 0; i < text.Length; i++)
            {
                // se multiplica por 33 y luego se le suma el valor  y luego se le suma el valor del caracter en ascii
                hash = hash * 33 + text[i]; 
            }                           
            return hash;
        }

        /// <summary>
        /// Modifica una cadena para que sus caracteres sean convertidos a mayúsculas o minúsculas
        /// según el valor especificado.
        /// </summary>
        /// <param name="text">
        /// Referencia a la cadena que será modificada. El contenido será convertido a mayúsculas 
        /// o minúsculas dependiendo del valor de <paramref name="isMay"/>.
        /// </param>
        /// <param name="isMay">
        /// Indica el tipo de conversión:
        /// - `true` para convertir los caracteres a mayúsculas.
        /// - `false` para convertir los caracteres a minúsculas.
        /// </param>
        /// <remarks>
        /// La función realiza los siguientes pasos:
        /// - Determina si debe trabajar con el rango de mayúsculas (`A` a `Z`) o minúsculas (`a` a `z`).
        /// - Itera por cada carácter de la cadena desde el final hacia el inicio.
        /// - Convierte cada carácter usando una función auxiliar `UpperLower` y concatena el resultado.
        /// - Elimina duplicados después de completar la transformación.
        /// </remarks>
        public static void MayusMinus(ref string text, bool isMay)
        {
            char c = isMay ? 'A' : 'a';
            char c2 = isMay ? 'Z' : 'z';
            int len = text.Length - 1;
            for (int i = len; i >= 0; i--)
            {
                text = UpperLower(text[len], isMay, c, c2) + text; //voy añadiendo el caracter cambiado a el string
            }
            len++; 
            text = text.Remove(len, len); //aqui he borrado la palabra original que me pasa
        }
        // Hacer funcion que me haga .spit(); si la hago puedo usar substring(empiezo, long)
        //Trim borra espacio que puede tener por los lados

        public static List<string> Split(string text, char c)
        {
            if (text == null)
                return null;
            text = text.Trim(' ');
            List<string> strings = new List<string>();
            int inicio = 0;
            int len = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (c == text[i])
                {
                    len = i - inicio;
                    strings.Add(text.Substring(inicio, len));
                    inicio = i + 1;
                }
            }
            len = text.Length - inicio;
            if (len > 0)
                strings.Add(text.Substring(inicio, len));
            return strings;
        }

        /*Hacer una función que, dado un string que representa una fecha, devuelva de una sola vez
          el año, el mes, el día, la hora, los minutos y los segundos.
          */

        //compruebo si es una letra o un número
        public static bool HaveLetterAndNumber(char c)
        {
            if (c >= '0' && c <= '9')
                return true;
            char letter = UpperLower(c, false, 'a', 'z'); //aqui lo cambio todo a minusculas ya que el correo no tiene sensibilidad a esp
            if (letter >= 'a' && letter <= 'z')
                return true;
            return false;
        }


        //comprobar si hay caracteres especiales excepto ( _ , - , . ), la barra baja solo si es el nombre
        private static bool HaveCaracterEspecial(char c, bool isDomine)
        {
            if (c == '_' && isDomine == true)
                return false;
            if (c == '_' && isDomine == false)
                return true;
            if (c == '.' || c == '-')
                return true;
            return false;
        }
        /// <summary>
        /// Valida si una cadena de texto tiene el formato de un correo electrónico válido.
        /// </summary>
        /// <param name="correo">Cadena de texto que representa el correo electrónico a validar.</param>
        /// <returns>
        /// true si la cadena cumple con el formato válido de un correo electrónico; 
        /// false en caso contrario.
        /// </returns>
        /// <remarks>
        /// La validación considera:
        /// - La presencia de exactamente un carácter '@'.
        /// - Un formato válido para la parte antes y después del '@'.
        /// - La parte después del '@' (el dominio) debe tener al menos un '.' con segmentos de 2 o más caracteres.
        /// </remarks>
        public static bool IsEmail(string correo)
        {
            var partesCorreo = Split(correo, '@');
            if (partesCorreo.Count != 2)
                return false;
            if (ComprobarFormato(partesCorreo[0], false) == false)
                return false;
            if (ComprobarFormato(partesCorreo[1], true) == false)
                return false;

            //divido el dominio y si no hay min dos partes no e valido ya que tiene que haber un '.'
            var puntos = Split(partesCorreo[1], '.');
            if (puntos.Count < 2)
                return false;
            // despues de un '.' tiene q haber min 2 caracteres
            for (int i = 0; i < puntos.Count; i++)
            {
                if (puntos[i].Length < 2)
                    return false;
            }
            return true;
        }

        //aqui como tiene la misma estructura compruebo si hay caracteres valido en las dos partes
        public static bool ComprobarFormato(string palabra, bool isDomine)
        {
   //       if (HaveCaracterEspecial(palabra[0], isDomine) || HaveCaracterEspecial(palabra[palabra.Length], isDomine))
                //return false; -- en clase me corregiste algo asi, pero no me acorde bien de como era, asi que lo deje como estaba que tampoco estaba mal :)
            for (int i = 0; i < palabra.Length; i++)
            {
                if (HaveCaracterEspecial(palabra[i], isDomine))
                {
                    if (HaveCaracterEspecial(palabra[i + 1], isDomine)) //si hay un caractér especial, el siguiente no puede serlo
                        return false;
                    continue;
                }
                if (HaveLetterAndNumber(palabra[i]) == false)
                    return false; 
            }
            return true;
        }

        /// <summary>
        /// Obtiene una fecha y hora desglosada en sus componentes individuales (día, mes, año, hora, minuto, segundo)
        /// a partir de una cadena con formato específico.
        /// </summary>
        /// <param name="fecha">
        /// Cadena que representa la fecha y hora. Debe tener el formato "YYYY/MM/DD-HH:mm:ss",
        /// </param>
        /// <returns>
        /// Una tupla de 6 elementos que contiene los componentes de la fecha y hora:
        /// - (año, mes, día, hora, minuto, segundo) si la cadena es válida.
        /// - (0, 0, 0, 0, 0, 0) si los valores del string son invalidos
        /// </returns>
        /// <remarks>
        /// La función realiza los siguientes pasos:
        /// 1. Divide la cadena de entrada en dos partes: fecha (`YYYY/MM/DD`) y hora (`HH:mm:ss`).
        /// 2. Extrae y convierte cada componente de la fecha y hora a valores numéricos.
        /// 3. Valida la fecha mediante la función `ComprobarDate`.
        /// 4. Valida la hora mediante la función `ComprobarTime`.
        /// 5. Si alguno de los valores es inválido, devuelve `(0, 0, 0, 0, 0, 0)`.
        /// </remarks>
        public static (int dia, int mes, int año, int hora, int min, int seg) GetDate(string fecha)
        {
            var dateHour = Split(fecha, '-');
            var date = Split(dateHour[0], '/');
            var time = Split(dateHour[1], ':');
            int year = (int)GetLong(date[0]);
            int month = (int)GetLong(date[1]);
            int day = (int)GetLong(date[2]);
            if (!ComprobarDate(month, day, year))
                return (0,0,0,0,0,0);
            int hour = (int)GetLong(time[0]);
            int min = (int)GetLong(time[1]);
            int seg = (int)GetLong(time[2]);
            if (!ComprobarTime(hour, min, seg))
                return (0, 0, 0, 0, 0, 0);
            return (year, month, day, hour, min, seg);
        }

        /// <summary>
        /// Obtiene la fecha en formato string apartir de sus componentes individuales
        /// </summary>
        /// <param name="year">El año en el siguiente formato númerico: YYYY</param>
        /// <param name="month">El mes en el siguiente formato númerico: MM</param>
        /// <param name="day">El día en el siguiente formato númerico: DD</param>
        /// <param name="hour">La hora en el siguiente formato númerico: HH</param>
        /// <param name="min">Los minutos en el siguiente formato númerico: mm</param>
        /// <param name="seg">Los segundos en el siguiente formato númerico: ss</param>
        /// <remarks>
        /// La función realiza los siguientes pasos:
        /// - Crea una variable tipo string, es la que devuelve la función.
        /// - Valida los datos introducidos que corresponden a la fecha con la función externa 'ComprobarTime'
        /// - Valida los datos introducidos que corresponden a la hora con la función externa 'ComprobarDate'
        /// - Si los datos no son validos devuelve un string con el mensaje "Fecha no válida";
        /// </remarks>
        /// <returns>La fecha en una cadena de texto: "YYYY/MM/DD-HH:mm:ss"</returns>
        public static string GetDateString(int year, int month, int day, int hour, int min, int seg)
        {
            string date = "";
            if (!ComprobarTime(hour, min, seg) || !ComprobarDate(month, day, year))
                return "Fecha no válida";
            date = year + "/" + month + "/" + day + "-" + hour + ":" + min + ":" + seg;
            return date;
        }

        public static bool IsBisiesto(int y)
        {
            if (y % 400 == 0)
                return true;
            return y % 4 == 0 && y % 100 != 0;
        }

        public static bool ComprobarTime(int h, int m, int s)
        {
            if (h > 23 || h < 0)
                return false;
            if (m > 59 || m < 0)
                return false;
            if (s > 59 || s < 0)
                return false;
            return true;
        }
        public static bool ComprobarDate(int m, int d, int y)
        {
            if (m > 12 || m < 0)
                return false;
            if (d > 31 || d < 0)
                return false;
            if (m == 2)
            {
                if (d == 29)
                    return IsBisiesto(y);
                if (d > 29)
                    return false;
            }
            if (d == 31)
            {
                List<int> meses31 = new() { 01, 03, 05, 07, 08, 10, 12 };
                for (int i = 0; i < meses31.Count; i++)
                {
                    if (m == meses31[i])
                        return true;
                }
                return false;
            }
            return true;
        }

        
        
        




    }
}
