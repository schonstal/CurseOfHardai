package
{
  import org.flixel.*;

  public class LaserSprite extends TileSprite
  {
    public function LaserSprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      loadGraphic(Assets.Laser, true, false, 16, 240, false);
    }
  }
}
