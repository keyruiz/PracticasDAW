namespace Domino
{
    public enum PlayerType
    {
        DOUBLES,
        NOTDOUBLES
    }
    public class Player
    {
        private readonly List<Tile> _listTile = new();
        public readonly string Name;
        public PlayerType Type;
        private int _puntos;
    
        public Player(string name, PlayerType type)
        {
            if (name == null)
                return;
            Name = name;
            Type = type;       
        }

        public void SetPuntuacion()
        {
            int suma = 0;
            for (int i = 0; i < _listTile.Count; i++)
                suma += _listTile[i].GetPuntuation();
            _puntos += suma;
        }

        public int GetPuntuation()
        {
            return _puntos;
        }

        public void AddFicha(Tile? ficha)
        {
            if (ficha == null)
                return;
            if (ficha.IsDouble())
                _listTile.Insert(0, ficha);
            else
                _listTile.Add(ficha);
        }

        public void RemoveTile(Tile ficha)
        {
            int index = IndexOf(ficha);
            if (index >= 0)
                _listTile.RemoveAt(index);
        }

        public Tile GetTileAt(int index)
        {
            return _listTile[index];
        }       

        public int IndexOf(Tile tile)
        {
            if (tile == null)
                return -1;
            for (int i = 0; i < _listTile.Count; i++)
            {
                if (tile == _listTile[i])
                    return i;
            }
            return -1;
        }
        
        public int GetTileCount()
        {
            return _listTile.Count;
        }

        public bool HasWin()
        {
            return _listTile.Count == 0;
        }
       
        public bool Play(ref int n1, ref int n2)
        {
            for (int i = 0; i < _listTile.Count; i++)
            {
                int index = Type == PlayerType.DOUBLES ? i : _listTile.Count - 1 - i;
                if (GetTile(_listTile[i], ref n1, ref n2))
                    return true;
                _listTile[i].Flip();
                if (GetTile(_listTile[i], ref n1, ref n2))
                    return true;
            }
            return false;
        }

        
        public bool GetTile(Tile tile, ref int num1, ref int num2)
        {
            if (tile.GetNum1() == num1)
            {
                num1 = tile.GetNum2();
                RemoveTile(tile);
                return true;
            }
            if (tile.GetNum1() == num2)
            {
                num2 = tile.GetNum2();
                RemoveTile(tile);
                return true;
            }
            return false;
        }
        
        public void Clear()
        {
            _listTile.Clear();
        }

        public void DarFichaRandom(ref int n1, ref int n2)
        {
            Tile tile = GetTileAt(Utils.GetRandom(_listTile.Count));
            n1 = tile.GetNum1();
            n2 = tile.GetNum2();
        }
    }
}
