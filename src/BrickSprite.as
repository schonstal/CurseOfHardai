package
{
  import org.flixel.*;

  public class BrickSprite extends TileSprite
  {
    public function BrickSprite(X:Number, Y:Number, colorIndex:int):void {
      super(X,Y);
      immovable = true;
      loadGraphic(Assets.TileSet, true, false, 16, 16, false);
      addOnCollisionCallback(setPlayerFlags);
      frame = (Math.random() < 0.5 ? 0 : 1) + 8*colorIndex;
    }

    public function setPlayerFlags(player:Player):void {
      if(touching & FlxObject.RIGHT) {
        player.setCollidesWith(Player.WALL_RIGHT);
      } else if(touching & FlxObject.LEFT) {
        player.setCollidesWith(Player.WALL_LEFT);
      }
      if(touching & FlxObject.UP) {
        player.setCollidesWith(Player.WALL_UP);
      }
    }
  }
}
