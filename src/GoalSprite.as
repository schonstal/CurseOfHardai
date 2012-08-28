package
{
  import org.flixel.*;

  public class GoalSprite extends TileSprite
  {
    public function GoalSprite(X:Number, Y:Number):void {
      super(X,Y);
      loadGraphic(Assets.Teleporter, true, false, 32, 16, false);
      addAnimation("idle", [0], 15, false);
      addAnimation("teleport", [1, 2, 3, 4], 15, true);

      width = 12;
      height = 3;

      offset.x = 10;
      offset.y = -3;

      y += 13;
      x += 10;

      immovable = true;
      addOnCollisionCallback(nextLevel);
    }

    public function init(X:Number, Y:Number):void {
      initTile(X,Y);
      y += 13;
      x += 10;
      play("idle");
    }

    public function nextLevel(player:Player):void {
      play("teleport");
      (FlxG.state as PlayState).teleportOut();
      G.paused = true;
    }
  }
}
