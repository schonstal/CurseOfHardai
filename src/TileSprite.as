package
{
  import org.flixel.*;

  public class TileSprite extends FlxSprite
  {
    private var collisionCallbacks:Array = new Array();

    public function TileSprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      makeGraphic(16, 16, 0xff2222cc);
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
