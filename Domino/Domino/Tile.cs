 namespace Domino
{
    public class Tile
    {
        private int Num1;
        private int Num2;
        private int _puntuation;

        public int GetNum1()
        {
            return Num1;
        }

        public int GetNum2()
        {
            return Num2;
        }
        public Tile(int num1, int num2)
        {
            if (num1 < 0 || num1 > 6)
                return;
            if (num2 < 0 || num2 > 6)
                return;
            Num1 = num1;
            Num2 = num2;
            _puntuation = num1 + num2;
        }

        public void Flip()
        {
            int aux = Num2;
            Num2 = Num1;
            Num1 = aux;
        }
        public int GetPuntuation()
        {
            if (IsDouble())
                _puntuation = _puntuation * 2;
            return _puntuation;
        }

        public bool IsDouble()
        {
            return Num1 == Num2;
        }

       
    }
}
