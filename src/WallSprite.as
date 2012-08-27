package
{
  import org.flixel.*;

  public class WallSprite extends TileSprite
  {
    public function WallSprite():void {
      super(0,0);
      loadGraphic(Assets.TileSet, true, false, 16, 16, false);
      solid = false;
    }

    public function init(X:Number, Y:Number, colorIndex:int):WallSprite {
      frame = (Math.random() < 0.33 ? 7 : 6) + 8*colorIndex;
      x = X;
      y = Y;

      return this;
    }
  }
}
