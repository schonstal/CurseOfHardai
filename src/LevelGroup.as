package
{
  import org.flixel.*;

  public class LevelGroup extends FlxGroup 
  {
    public static const TILESETS:Object = {
      0: [BrickSprite],
      1: [BrickSprite],
      2: [BrickSprite]
    };

    private var tiles:Array;

    //genetic information
    public var laserTiles:Array;
    public var gunTiles:Array;
    public var brickTiles:Object;
    public var bgTiles:Object;
    public var pits:Array;
    

    public var bg:FlxGroup;
    public var lasers:FlxGroup;
    public var guns:FlxGroup;
    public var bullets:FlxGroup;
    public var bricks:FlxGroup;

    public var goal:GoalSprite;

    public static const FEATURES:Object = {
      WALL:   0,
      SQUARE: 1,
      PIT:    2,
      GUN:    3,
      LASER:  4
    }

    public static const TILE_SIZE:Number = 16;

    public function LevelGroup(roomType:Number=0, shell:Boolean = false) {
      clearGroups();
      if(!shell) init(roomType);

      lasers.add(new LaserSprite(5,5));
    }

    public function clearGroups():void {
      if(bg) {
        remove(bg);
        remove(lasers);
        remove(guns);
        remove(bullets);
        remove(bricks);
      }

      bg = new FlxGroup();
      lasers = new FlxGroup();
      guns = new FlxGroup();
      bullets = new FlxGroup();
      bricks = new FlxGroup();

      add(bg);
      add(lasers);
      add(guns);
      add(bullets);
      add(bricks);

      laserTiles = new Array();
      gunTiles = new Array();
      pits = new Array();

      brickTiles = {};
      bgTiles = {};
    }

    public function reproduce(mother:LevelGroup, father:LevelGroup):LevelGroup {
      clearGroups();

      //remember to weight near tiles (+0.1 parent / -0.1 other parent for each near tile)

      //when copying tiles copy tiles from near the copied thing

      var x:int;
      var y:int;
      var level:LevelGroup;
      for(y = 0; y < 15; y++) {
        for(x = 0; x < 25; x++) {
          level = Math.random() > 0.5 ? mother : father;
          if(level.brickTiles[cacheKey(x,y)] != null) {
            add(level.brickTiles[cacheKey(x,y)]);
          } else {
            add(level.bgTiles[cacheKey(x,y)]);
          }
        }
      }

      return this;
    }

    public function cacheKey(X:Number, Y:Number):String {
      return "" + X + ":" + Y;
    }

    public function emptyRoom():Array {
      var newRoom:Array = [];
      var roomWidth:Number = 25;
      var roomHeight:Number = 15;
      var x:int = 0;
      var y:int = 0;

      //Make sure it's always surrounded by wall
      for(y = 0; y < roomHeight; y++) {
        newRoom[y] = new Array();
        for(x = 0; x < roomWidth; x++) {
          if(x == 0 || y == 0 || x == roomWidth-1) newRoom[y][x] = 0;
          else newRoom[y][x] = -1;
        }
      }

      return newRoom;
    }

    public function init(roomType:Number):void {
      tiles = emptyRoom();

      if(roomType == 0) {
        initializePits();
      } 

      //Lay down bricks for empty area
      var topThickness:Number = 3;
      var bottomThickness:Number = 4;
      var y:int = 1; //Fuck AS3

      for(var x:int = 0; x < tiles[0].length; x++) {
        for(y = 1; y < topThickness; y++) {
          if(tiles[y][x] != -1) break;
          tiles[y][x] = FEATURES.WALL;
        }
        if(Math.random() <= 0.2) {
          if(topThickness >= 4) topThickness--;
          else if(topThickness <= 2) topThickness++;
          else if(Math.random() <= 0.5) topThickness--;
          else topThickness++;
        }
      }

      for(x = 0; x < tiles[0].length; x++) {
        for(y = tiles.length-1; y >= tiles.length - bottomThickness; y--) {
          if(tiles[y][x] != -1) break;
          tiles[y][x] = FEATURES.WALL;
        }
        if(Math.random() <= 0.2 && x < tiles[0].length - 4) {
          if(bottomThickness >= 5) bottomThickness--;
          else if(bottomThickness <= 3) bottomThickness++;
          else if(Math.random() <= 0.5) bottomThickness--;
          else bottomThickness++;
        }
      }
      
      if(roomType == 2) initializeGuns();
      if(roomType == 1) initializeLasers();

      for(y = 0; y < tiles.length; y++) {
        for(x = 0; x < tiles[0].length; x++) {
          //LAY THOSE BRICKS DOWN
          if(tiles[y][x] == FEATURES.WALL) {
            brickTiles[cacheKey(x,y)] = new BrickSprite(x, y, roomType);
            brickTiles[cacheKey(x,y)].allowCollisions = FlxObject.LEFT | FlxObject.RIGHT | FlxObject.UP; //TODO
            if(y > 0 && tiles[y-1][x] != 0) brickTiles[cacheKey(x,y)].allowCollisions |= FlxObject.UP;
            bricks.add(brickTiles[cacheKey(x,y)]);
          } else {
            bgTiles[cacheKey(x,y)] = (bg.recycle(WallSprite) as WallSprite).init(x, y, roomType);
          }
        }
      }

      //Add the goal
      for (var n:Number = tiles.length - 1; n > 1; n--) {
        if(tiles[n][tiles[n].length-3] == -1) {
          var goal:GoalSprite = new GoalSprite(22, n);
          add(goal);
          break;
        }
      }

      //lol eyes
      //var s:FlxSprite = new FlxSprite(336, 16*5);
      //s.makeGraphic(16,16,0xff33cccc);
      //add(s);
      //s = new FlxSprite(368, 16*5);
      //s.makeGraphic(16,16,0xff33cccc);
      //add(s);
    }

    public function initializeLasers():void {
    }

    public function initializeGuns():void {
    }

    public function initializePits():void {
      var tileIndex:Number = 7;
      var digLength:Number = 0;
      var digMax:Number = 7;
      var y:int;

      for(var x:int = 3; x < tiles[tileIndex].length - 3; x++) {
        if(digLength <= digMax && Math.random() <= 0.3 && !(digLength == 0 && x >= tiles[0].length - 4)) {
          digLength++;
          for(y = tileIndex; y < tiles.length; y++) { tiles[y][x] = FEATURES.PIT; }
        } else {
          if(digLength > 0 && digLength < 3) {
            digLength++;
            for(y = tileIndex; y < tiles.length; y++) { tiles[y][x] = FEATURES.PIT; }
          } else {
            digLength = 0;
          }
        }
      }
    }

  }
}
