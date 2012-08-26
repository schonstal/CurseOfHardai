package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    private var levelGroup:LevelGroup;

    override public function create():void {
      player = new Player(16,FlxG.camera.height-32);
      add(player);

      levelGroup = new LevelGroup();
      add(levelGroup);

      //FlxG.visualDebug = true;
    }

    override public function update():void {
      player.resetFlags();

      FlxG.collide(player, levelGroup, function(player:Player, tile:TileSprite):void {
        tile.onCollide(player);
      });
      super.update();
    }

    public function endLevel(success:Boolean=false):void {
      FlxG.level++;
      FlxG.log("butts");
    }
  }
}
