package
{
  import org.flixel.*;

  public class GunSprite extends TileSprite
  {
    public function GunSprite(X:Number, Y:Number):void {
      super(X,Y);
      makeGraphic(24, 24, 0xffcc22cc);
      width = height = 16;
      offset.x = offset.y = 4;
    }
  }
}
