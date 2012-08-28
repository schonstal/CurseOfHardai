package
{
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    public var player:Player;
    public var teleporter:TeleporterSprite;

    public var goal:GoalSprite;

    private var levelGroup:LevelGroup;

    private var currentGeneration:Array;
    private var nextGeneration:Array;
    private var tempGeneration:Array;

    override public function create():void {
      currentGeneration = new Array();
      nextGeneration = new Array();

      goal = new GoalSprite(22, 15);

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
      levelGroup.updateGoal();
      add(goal);

      //FlxG.visualDebug = true;
    }

    override public function update():void {
      super.update();
      if(!G.paused) {
        player.resetFlags();

        FlxG.collide(player, levelGroup.bricks, function(player:Player, tile:TileSprite):void {
          tile.onCollide(player);
        });

        FlxG.overlap(player, levelGroup.lasers, function(player:Player, tile:TileSprite):void {
          tile.onCollide(player);
        });

        FlxG.overlap(player, goal, function(player:Player, tile:TileSprite):void {
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
      var chance:Number = 0.3;

      tempGeneration = new Array();

      G.generation++;

      currentGeneration.sortOn("fitness", Array.DESCENDING);
      
      for each(var level:LevelGroup in nextGeneration) {
        mother = currentGeneration[0];
        for(var i:int = 0; i < 8; i++) {
          if(Math.random() < chance) {
            mother = currentGeneration[i];
            chance -= 0.03;
          }
        }

        chance = 0.3;
        
        father = currentGeneration[1];
        for(var j:int = 0; j < 8; j++) {
          if(Math.random() < chance) {
            father = currentGeneration[i];
            chance -= 0.03;
          }
        }

        if(father == null || mother == null) trace("PENIS");

        level.reproduce(mother, father);
      }
      
      tempGeneration = nextGeneration;
      nextGeneration = currentGeneration;
      currentGeneration = tempGeneration;
    }

    public function die():void {
      G.paused = true;
      remove(player);
      add(new DeatherSprite(player.x, player.y));
      levelGroup.fitness += 15;
    }

    public function teleportOut():void {
      remove(player);
      teleporter.init(player.x, player.y);
      teleporter.play("go", true);
    }
    
    public function teleportIn():void {
      remove(player);
      levelGroup.updateGoal();
      teleporter.init(Player.START_X, Player.START_Y);
      teleporter.play("return", true);
    }

    public function startLevel():void {
      player = new Player(Player.START_X, Player.START_Y);
      add(player);
      G.paused = false;
    }

    public function endLevel(increment:Boolean = true):void {
      if(increment) FlxG.level++;
      if(FlxG.level <= 8) {
        remove(levelGroup);
        remove(goal);
        levelGroup = currentGeneration[FlxG.level];
        levelGroup.rebase();
        add(levelGroup);
        add(goal);
        teleportIn();
      } else {
        remove(levelGroup);
        remove(goal);
        FlxG.level = 0;
        mateLevels();
        levelGroup = currentGeneration[FlxG.level];
        levelGroup.rebase();
        add(levelGroup);
        add(goal);
        teleportIn();
      }
    }
  }
}
