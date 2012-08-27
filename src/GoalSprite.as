package
{
  import org.flixel.*;

  public class GoalSprite extends TileSprite
  {
    public function GoalSprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      makeGraphic(16, 16, 0xff2222cc);
      solid = false;
      addOnCollisionCallback(nextLevel);
    }

    public function nextLevel(player:Player):void {
      (FlxG.state as PlayState).endLevel(true);
    }
  }
}
