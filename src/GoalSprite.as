package
{
  import org.flixel.*;

  public class GoalSprite extends TileSprite
  {
    public function GoalSprite(X:Number, Y:Number):void {
      super(X,Y);
      loadGraphic(Assets.Teleporter, true, false, 32, 16, false);
      width = 12;
      height = 3;
      offset.x = 10;
      offset.y = -3;
      y += 13;
      x += 10;
      immovable = true;
      addOnCollisionCallback(nextLevel);
    }

    public function nextLevel(player:Player):void {
      (FlxG.state as PlayState).teleportOut();
      G.paused = true;
    }
  }
}
