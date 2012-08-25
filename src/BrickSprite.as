package
{
  import org.flixel.*;

  public class BrickSprite extends TileSprite
  {
    public function BrickSprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      makeGraphic(16, 16, 0xff2222cc);
      addOnCollisionCallback(setPlayerFlags);
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
