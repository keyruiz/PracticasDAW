namespace Domino
{
    public class Utils
    {
        public static readonly Random _randomGenerator = new Random();

        public static int GetRandom(int Max)
        {
            return _randomGenerator.Next(Max);
        }

        /*
         *public static int GetRandom(int min, int max)
         *{
         *  int distance = max -min + 1;
         *  int random = GetRandom();
         *  int n = random % distance;
         *  return min + n;
         *}
         */
    }
}
