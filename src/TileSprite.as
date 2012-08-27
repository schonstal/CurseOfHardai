package
{
  import org.flixel.*;

  public class TileSprite extends FlxSprite
  {
    public static const WIDTH:Number = 16;

    public var tileX:Number = 0;
    public var tileY:Number = 0;

    private var collisionCallbacks:Array = new Array();

    public function TileSprite(X:Number, Y:Number):void {
      tileX = X;
      tileY = Y;
      super(X*WIDTH,Y*WIDTH);
      immovable = true;
    }

    public function addOnCollisionCallback(callback:Function):void {
      collisionCallbacks.push(callback);
    }

    public function onCollide(player:Player):void {
      for each(var callback:Function in collisionCallbacks) {
        callback(player);
      }
    }
  }
}
