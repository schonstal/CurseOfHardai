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
    private var background:FlxGroup;

    public static const FEATURES:Object = {
      WALL:   0,
      SQUARE: 1,
      PIT:    2,
      BOX_1:  3,
      BOX_2:  4,
      BOX_3:  5,
      BOX_4:  6
    }

    public static const TILE_SIZE:Number = 16;

    public function LevelGroup(roomType:Number=0) {
      background = new FlxGroup();
      FlxG.state.add(background);
      init(roomType);
    }

    public function reporoduce(mother:Array, father:Array):void {
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
      FlxG.log(roomType);
      tiles = emptyRoom();

      if(roomType == 0) {
        initializePits();
      } else if(roomType == 1) {
      } else {
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

      var brick:BrickSprite;
      for(y = 0; y < tiles.length; y++) {
        for(x = 0; x < tiles[0].length; x++) {
          //LAY THOSE BRICKS DOWN
          if(tiles[y][x] == FEATURES.WALL) {
            brick = new BrickSprite(x, y, roomType);
            brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT;
            if(y > 0 && tiles[y-1][x] != 0) brick.allowCollisions |= FlxObject.UP;
            add(brick);
          } else {
            background.add((recycle(WallSprite) as WallSprite).init(x*TILE_SIZE, y*TILE_SIZE, roomType));
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

    public function initializePits():void {
      var tileIndex:Number = 7;
      var digLength:Number = 0;
      var digMax:Number = 7;

      for(var x:int = 3; x < tiles[tileIndex].length - 3; x++) {
        if(digLength <= digMax && Math.random() <= 0.3 && !(digLength == 0 && x >= tiles[0].length - 4)) {
          digLength++;
          for(var y:int = tileIndex; y < tiles.length; y++) { tiles[y][x] = FEATURES.PIT; }
        } else {
          if(digLength > 0 && digLength < 3) {
            digLength++;
            for(var y:int = tileIndex; y < tiles.length; y++) { tiles[y][x] = FEATURES.PIT; }
          } else {
            digLength = 0;
          }
        }
      }
    }

  }
}
