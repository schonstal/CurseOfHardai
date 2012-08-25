package
{
  import org.flixel.*;

  public class LevelGroup extends FlxGroup 
  {
    public static const TILESETS:Object = {
      1: [BrickSprite],
      2: [BrickSprite],
      3: [BrickSprite]
    };

    var tiles:Array;

    public function LevelGroup() {
      var brick:BrickSprite;
      brick = new BrickSprite(0, FlxG.camera.height - 16);
      brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT; //don't allow up collision on tiles in the middle
      add(brick);

      brick = new BrickSprite(0, FlxG.camera.height - 32);
      brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT | FlxObject.UP;
      add(brick);

      for(var i:int = 1; i <= 50; i++) {
        brick = new BrickSprite(16 * i, FlxG.camera.height - 16);
        brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT | FlxObject.UP;
        add(brick);
      }

      brick = new BrickSprite(160, FlxG.camera.height - 32);
      brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT; //don't allow up collision on tiles in the middle
      add(brick);

      brick = new BrickSprite(160, FlxG.camera.height - 48);
      brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT | FlxObject.UP;
      add(brick);

      brick = new BrickSprite(176, FlxG.camera.height - 32);
      brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT; //don't allow up collision on tiles in the middle
      add(brick);

      brick = new BrickSprite(176, FlxG.camera.height - 48);
      brick.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT | FlxObject.UP;
      add(brick);
    }
  }
}
