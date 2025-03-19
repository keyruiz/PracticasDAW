namespace Domino
{
    public class Mazo
    {
        private readonly List<Tile> _listTile = new();
       
        public Mazo()
        {
            
        }

        //Creo todas las fichas sin duplicados
        public void Initialize()
        {
            for (int i = 0; i <= 6; i++)
            {
                for (int j = i; j <= 6; j++)
                {
                    _listTile.Add(new Tile(i, j));
                }
            }
        }

        public Tile? GetTileAt(int index)
        {
            if (index > _listTile.Count || index < 0)
                return null;
            return _listTile[index];
        }
        
        public int GetTilesCount()
        {
            return _listTile.Count;
        }

        public void RemoveTile(int index)
        {
            _listTile.RemoveAt(index);
        }

        public void Clear()
        {
            _listTile.Clear();
        }
    }
}
