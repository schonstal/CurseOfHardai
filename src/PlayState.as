package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    private var levelGroup:LevelGroup;

    override public function create():void {
      levelGroup = new LevelGroup();
      add(levelGroup);

      if(!G.playedMusic) {
        FlxG.playMusic(Assets.GameMusic);
        G.playedMusic = true;
      }

      player = new Player(16,FlxG.camera.height-120);
      add(player);

      //FlxG.visualDebug = true;
    }

    override public function update():void {
      super.update();
      player.resetFlags();

      FlxG.collide(player, levelGroup, function(player:Player, tile:TileSprite):void {
        tile.onCollide(player);
      });
    }

    public function endLevel(success:Boolean=false):void {
      FlxG.level++;
      FlxG.log("butts");
      FlxG.switchState(new PlayState());
    }
  }
}
