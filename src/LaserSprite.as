package
{
  import org.flixel.*;

  public class LaserSprite extends TileSprite
  {
    private var _active:Boolean = false;
    private var _idle:Boolean = true;

    public function LaserSprite(X:Number, Y:Number):void {
      super(X,Y);
      immovable = true;
      loadGraphic(Assets.Laser, true, false, 16, 240, false);

      addAnimation("idle", [1], 15, false);
      addAnimation("tripped", [0, 1, 0, 1, 0, 0], 20, false);
      addAnimation("on", [2, 3, 2, 3, 2, 3, 2, 3], 15, false);
      addAnimation("cool down", [4, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 10, false);

      addOnCollisionCallback(trigger);
      addAnimationCallback(activationSequence);

      width = 2;
      offset.x = 7;
      x += offset.x;

      play("idle");
    }

    public function activationSequence(title:String, frameIndex:uint, frame:uint):void {
      if(title == "tripped" && frameIndex == 5) {
        play("on");
        FlxG.play(Assets.LaserSound);
      } else if(title == "on") {
        _active = true;
        if(frameIndex == 7) {
          play("cool down");
          _active = false;
        }
      } else if(title == "cool down" && frameIndex == 11) {
        _idle = true;
        play("idle");
      }
    }

    public function trigger(player:Player):void {
      if(_idle) {
        play("tripped");
        _idle = false;
      } else if(_active) {
        (FlxG.state as PlayState).endLevel();
      }
    }
  }
}
