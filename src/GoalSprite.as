package
{
  import org.flixel.*;

  public class GoalSprite extends TileSprite
  {
    public function GoalSprite(X:Number, Y:Number):void {
      super(X,Y);
      y += 13;
      immovable = true;
      makeGraphic(32, 3, 0xff2222cc);
      addOnCollisionCallback(nextLevel);
    }

    public function nextLevel(player:Player):void {
      (FlxG.state as PlayState).teleportOut();
      G.paused = true;
    }
  }
}
