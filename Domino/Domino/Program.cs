namespace Domino
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Player p1 = new Player("Javi", PlayerType.NOTDOUBLES);
            Player p2 = new Player("Keyra", PlayerType.NOTDOUBLES);
            Player p3 = new Player("Irene", PlayerType.DOUBLES);
            //Player p4 = new Player(PlayerType.NOTDOUBLES);
            //Player p5 = new Player(PlayerType.DOUBLES);
            Tile t1 = new(2, 2);
            Tile t2 = new(3, 2);
            Tile t3 = new(4, 4);
            Tile t4 = new(1, 2);
            /*
            p2.AddFicha(t1);
            p2.AddFicha(t2);
            p2.AddFicha(t3);
            p2.AddFicha(t4);
            */
            Game game = new Game();
            game.AddPlayers(p1);
            game.AddPlayers(p2);
            game.AddPlayers(p3);
            game.Execute();
        }
    }
}
