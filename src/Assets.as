package
{
  import org.flixel.*;

  public class Assets
  {
    [Embed(source = "../data/tileSet.png")] public static var TileSet:Class;
    [Embed(source = "../data/player.png")] public static var Player:Class;
    [Embed(source = "../data/laser.png")] public static var Laser:Class;
    [Embed(source = "../data/turret.png")] public static var Turret:Class;
    [Embed(source = "../data/bullet.png")] public static var Bullet:Class;
    [Embed(source = "../data/teleport.png")] public static var Teleport:Class;

    [Embed(source = "../data/music/game.mp3")] public static var GameMusic:Class;
    [Embed(source = "../data/jump.mp3")] public static var JumpSound:Class;
    [Embed(source = "../data/laser.mp3")] public static var LaserSound:Class;
  }
}
