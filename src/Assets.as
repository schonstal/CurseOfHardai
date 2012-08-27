package
{
  import org.flixel.*;

  public class Assets
  {
    [Embed(source = "../data/tileSet.png")] public static var TileSet:Class;
    [Embed(source = "../data/player.png")] public static var Player:Class;
    [Embed(source = "../data/laser.png")] public static var Laser:Class;

    [Embed(source = "../data/music/game.mp3")] public static var GameMusic:Class;
  }
}
