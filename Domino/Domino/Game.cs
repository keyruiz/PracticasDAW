namespace Domino
{
    public class Game
    {
        private readonly List<Player> _listPlayer = new();
        private readonly Mazo mazo = new();
        public void AddPlayers(Player player)
        {
            if (player == null)
                return;
            if (Contains(player) || _listPlayer.Count >= 4)
                return;
            _listPlayer.Add(player);
        }
        private int IndexOf(Player player)
        {
            for(int i = 0; i < _listPlayer.Count; i++)
            {
                if (player == _listPlayer[i])
                    return i;
            }
            return -1;
        }

        private bool Contains(Player player)
        {
            return IndexOf(player) >= 0;
        }

        public Player Execute()
        {
            //inicio juego
            while(_listPlayer.Count > 1)
            {
                mazo.Initialize();
                DistributeTiles();
                bool partidaAcabada = false;
                int num1Ficha = 0;
                int num2Ficha = 0; 
                int JugadorInicio = FirstRount(ref num1Ficha, ref num2Ficha) + 1;

                //inicio partida
                while(!partidaAcabada)
                {
                    partidaAcabada = Ronda(JugadorInicio, ref num1Ficha, ref num2Ficha);                
                    if (!partidaAcabada)
                        JugadorInicio = 0;
                }
                DarPuntuaciones();
                RemovePlayers();
                mazo.Clear();
            }            
            if(_listPlayer.Count == 0)
                Console.WriteLine("Nadie ganó");
            return _listPlayer[0];
        }

        public bool Ronda(int inicio, ref int num1, ref int num2)
        {
            int cont = 0;
            for (int i = inicio; i < _listPlayer.Count; i++)
            {
                bool encontroFicha = _listPlayer[i].Play(ref num1, ref num2);              
                while (!encontroFicha && mazo.GetTilesCount() > 0)
                {
                    DarFicha(i);
                    encontroFicha = _listPlayer[i].Play(ref num1, ref num2);
                }

                if (!encontroFicha && mazo.GetTilesCount() == 0)
                    cont++;
                
                if (_listPlayer[i].HasWin())
                    return true;
            }
            if (cont >= _listPlayer.Count)
                return true;
            return false;
        }

        public void DarFicha(int i)
        {
            int index = Utils.GetRandom(mazo.GetTilesCount());
            _listPlayer[i].AddFicha(mazo.GetTileAt(index));
            mazo.RemoveTile(index);
        }
        private void DistributeTiles()
        {
            for (int i = 0; i < Constants.FichasRepartidas; i++)
            {
                for(int j = 0;  j < _listPlayer.Count; j++)
                {
                    DarFicha(j);
                }
            }
        }

        public void DarPuntuaciones()
        {
            foreach(Player player in _listPlayer)
            {
                player.SetPuntuacion();
                player.Clear();
            }
        }       
        public void RemovePlayers()
        {
            for(int i = 0; i < _listPlayer.Count; i++)
            {
                if (_listPlayer[i].GetPuntuation() > Constants.Tope)
                    _listPlayer.RemoveAt(i--);  
            }
        }

        public int FirstRount(ref int n1, ref int n2)
        {
            for(int i = 0; i < _listPlayer.Count; i++)
            {
                Player player = _listPlayer[i];
                for(int j = 0; j < player.GetTileCount(); j++)
                {
                    Tile tile = player.GetTileAt(j);
                    if (tile.IsDouble())
                    {
                        n1 = tile.GetNum1();
                        n2 = tile.GetNum2();
                        player.RemoveTile(tile);
                        return i;
                    }                   
                }
            }
            _listPlayer[0].DarFichaRandom(ref n1, ref n2);
            return 0;
        }
    }
}
