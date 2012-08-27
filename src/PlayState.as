package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;

    private var levelGroup:LevelGroup;

    private var currentGeneration:Array;
    private var nextGeneration:Array;

    override public function create():void {
      currentGeneration = new Array();
      nextGeneration = new Array();

      /*var motherGroup:LevelGroup = new LevelGroup(2);
      var fatherGroup:LevelGroup = new LevelGroup(0);
      levelGroup = new LevelGroup(0, true);
      levelGroup.reproduce(motherGroup, fatherGroup);
      if(FlxG.level == 0) levelGroup = motherGroup;
      else if(FlxG.level == 1) levelGroup = fatherGroup;*/

      levelGroup = new LevelGroup(Math.floor(Math.random()*2.99));
      add(levelGroup);

      if(!G.playedMusic) {
        FlxG.playMusic(Assets.GameMusic);
        G.playedMusic = true;
      }

      player = new Player(18,FlxG.camera.height-120);
      add(player);

      //FlxG.visualDebug = true;
    }

    override public function update():void {
      super.update();
      player.resetFlags();

      FlxG.collide(player, levelGroup.bricks, function(player:Player, tile:TileSprite):void {
        tile.onCollide(player);
      });

      FlxG.overlap(player, levelGroup.lasers, function(player:Player, tile:TileSprite):void {
        tile.onCollide(player);
      });

      FlxG.overlap(player, levelGroup.bullets, function(player:Player, bullet:BulletSprite):void {
        endLevel();
        bullet.onCollide();
      });

      FlxG.overlap(levelGroup.bricks, levelGroup.bullets,
          function(brick:BrickSprite, bullet:BulletSprite):void {
            bullet.onCollide();
          });
    }

    public function endLevel(success:Boolean=false):void {
      if(success) FlxG.level++;
      FlxG.log("butts");
      FlxG.switchState(new PlayState());
    }
  }
}
