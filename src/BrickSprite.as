package
{
  import org.flixel.*;

  public class BrickSprite extends TileSprite
  {
    public function BrickSprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      makeGraphic(16, 16, FlxU.makeColorFromHSB(FlxG.level * 120 % 360, 0.8, 0.8));
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
