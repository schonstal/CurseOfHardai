package
{
  import org.flixel.*;

  public class BulletSprite extends FlxSprite
  {
    public static const SPEED:Number = 100;

    public function BulletSprite():void {
      super(0,0);
      loadGraphic(Assets.Bullet, true, false, 16, 16);
      addAnimation("pulse", [0,1], 10, true);
      addAnimation("die", [2,3,4,5,6,6], 15, true);

      width = height = 6;
      offset.x = offset.y = 5;
      play("pulse");

      addAnimationCallback(animationLogic);
    }

    public function animationLogic(title:String, frameIndex:uint, frame:uint):void {
      if(title == "die" && frameIndex == 5) exists = false;
    }

    public function onCollide():void {
      play("die");
      solid = false;
      velocity.x = velocity.y = 0;
    }

    public function init(X:Number, Y:Number):void {
      x = X;
      y = Y;
      solid = true;
      exists = true;
      play("pulse");
    }
  }
}
