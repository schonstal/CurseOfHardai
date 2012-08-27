package
{
  import org.flixel.*;

  public class GunSprite extends TileSprite
  {
    public function GunSprite(X:Number, Y:Number):void {
      super(X,Y);
      loadGraphic(Assets.Turret, true, false, 24, 24);
      width = height = 16;
      offset.x = offset.y = 4;
    }
  }
}
