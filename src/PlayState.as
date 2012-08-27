package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;
    public var teleporter:TeleporterSprite;

    private var levelGroup:LevelGroup;

    private var currentGeneration:Array;
    private var nextGeneration:Array;
    private var tempGeneration:Array;

    override public function create():void {
      currentGeneration = new Array();
      nextGeneration = new Array();

      /*var motherGroup:LevelGroup = new LevelGroup(2);
      var fatherGroup:LevelGroup = new LevelGroup(0);
      levelGroup = new LevelGroup(0, true);
      levelGroup.reproduce(motherGroup, fatherGroup);
      if(FlxG.level == 0) levelGroup = motherGroup;
      else if(FlxG.level == 1) levelGroup = fatherGroup;*/

      for(var i:int = 0; i < 9; i++) {
        levelGroup = new LevelGroup(i%3);
        currentGeneration.push(levelGroup);

        levelGroup = new LevelGroup(-1, false);
        nextGeneration.push(levelGroup);
      }
      levelGroup = currentGeneration[0]
      add(levelGroup);

      if(!G.playedMusic) {
        FlxG.playMusic(Assets.GameMusic);
        G.playedMusic = true;
      }

      player = new Player(18,160);

      teleporter = new TeleporterSprite(18, player.y);
      add(teleporter);

      G.paused = true;

      //FlxG.visualDebug = true;
    }

    override public function update():void {
      if(FlxG.keys.justPressed("SPACE")) endLevel();//FlxG.switchState(new PlayState());
      super.update();
      if(!G.paused) {
        player.resetFlags();

        FlxG.collide(player, levelGroup.bricks, function(player:Player, tile:TileSprite):void {
          tile.onCollide(player);
        });

        FlxG.overlap(player, levelGroup.lasers, function(player:Player, tile:TileSprite):void {
          tile.onCollide(player);
        });

        FlxG.overlap(player, levelGroup.goal, function(player:Player, tile:TileSprite):void {
          tile.onCollide(player);
        });

        FlxG.overlap(player, levelGroup.bullets, function(player:Player, bullet:BulletSprite):void {
          die();
          bullet.onCollide();
        });

        FlxG.overlap(levelGroup.bricks, levelGroup.bullets,
            function(brick:BrickSprite, bullet:BulletSprite):void {
              bullet.onCollide();
            });
      }
    }

    public function mateLevels():void {
      var mother:LevelGroup = null;
      var father:LevelGroup = null;
      var baby:LevelGroup = null;

      tempGeneration = new Array();

      //currentGeneration.sortOn("fitness", Array.DESCENDING);
      
      for each(var level:LevelGroup in nextGeneration) {
        /*while(mother == null) {
          for(var i:int = 0; i < 9; i++) {
            if(Math.random() < 0.2) {
              mother = currentGeneration[i];
              break;
            }
          }
        }

        while(father == null || mother == father) {
          for(var j:int = 0; j < 9; j++) {
            if(Math.random() < 0.2) {
              father = currentGeneration[i];
              break;
            }
          }
        }*/

        mother = currentGeneration[0];
        father = currentGeneration[1];

        FlxG.log(mother == father);

        level.reproduce(mother, father);
      }
      
      tempGeneration = nextGeneration;
      nextGeneration = currentGeneration;
      currentGeneration = tempGeneration;
    }

    public function die():void {
      G.paused = true;
      teleportIn();
      levelGroup.rebase();
    }

    public function teleportOut():void {
      remove(player);
      teleporter.init(player.x, player.y);
      teleporter.play("go", true);
    }
    
    public function teleportIn():void {
      remove(player);
      teleporter.init(Player.START_X, Player.START_Y);
      teleporter.play("return", true);
    }

    public function startLevel():void {
      FlxG.log("starting " + FlxG.level);
      player = new Player(Player.START_X, Player.START_Y);
      add(player);
      G.paused = false;
      levelGroup.rebase();
    }

    public function endLevel():void {
      FlxG.log("ending " + FlxG.level)
      FlxG.level++;
      if(FlxG.level <= 8) {
        remove(levelGroup);
        levelGroup = currentGeneration[FlxG.level];
        add(levelGroup);
        teleportIn();
      } else {
        remove(levelGroup);
        FlxG.level = 0;
        mateLevels();
        levelGroup = currentGeneration[FlxG.level];
        add(levelGroup);
        teleportIn();
      }
    }
  }
}
