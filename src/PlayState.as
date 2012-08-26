package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    public var levelGroup:LevelGroup;

    override public function create():void {
      player = new Player(15,15);
      add(player);

      levelGroup = new LevelGroup();
      add(levelGroup);

      FlxG.visualDebug = true;
    }

    override public function update():void {
      player.resetFlags();

      FlxG.collide(player, levelGroup, function(player:Player, tile:TileSprite):void {
        tile.onCollide(player);
      });
      super.update();
    }
  }
}
