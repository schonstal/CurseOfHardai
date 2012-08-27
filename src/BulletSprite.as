package
{
  import org.flixel.*;

  public class BulletSprite extends FlxSprite
  {
    public static const SPEED:Number = 100;
    public var dead:Boolean = false;

    public function BulletSprite():void {
      super(0,0);
      loadGraphic(Assets.Bullet, true, false, 16, 16);
      addAnimation("pulse", [0,1], 10, true);
      addAnimation("die", [2,3,4,5,6], 15, true);

      width = height = 6;
      offset.x = offset.y = 5;
      play("pulse");
    }

    public function onCollision():void {
      play("die");
      velocity.x = velocity.y = 0;
      dead = true;
    }

    public function init(X:Number, Y:Number):void {
      x = X;
      y = Y;
      exists = true;
      dead = false;
      play("pulse");
    }

    public override function update():void {
      if(dead && finished) exists = false;
    }
  }
}
