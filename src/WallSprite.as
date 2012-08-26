package
{
  import org.flixel.*;

  public class WallSprite extends TileSprite
  {
    public function WallSprite():void {
      super(0,0);
      solid = false;
    }

    public function init(X:Number, Y:Number, colorIndex:int):WallSprite {
      frame = (Math.random() < 0.33 ? 7 : 6) + 7*colorIndex;
      x = X;
      y = Y;

      return this;
    }
  }
}
