package
{
  import org.flixel.*;

  public class GunSprite extends TileSprite
  {
    public var bullets:FlxGroup;

    public function GunSprite(X:Number, Y:Number, bulletGroup:FlxGroup):void {
      super(X,Y);
      loadGraphic(Assets.Turret, true, false, 24, 24);

      addAnimation("horizontal", [0, 0], 2, false);
      addAnimation("diagonal", [3, 3], 2, false);

      addAnimation("horizontal fire", [0, 0], 2, false);
      addAnimation("diagonal fire", [3, 3], 2, false);

      addAnimation("horizontal rotate", [1,1,2,3], 15, false);
      addAnimation("diagonal rotate", [4,4,5,0], 15, false);

      width = height = 16;
      offset.x = offset.y = 4;

      bullets = bulletGroup;

      play("horizontal");

      addAnimationCallback(activationSequence);
    }

    public function init(X:Number, Y:Number, bulletGroup:FlxGroup):void {
      play("horizontal", true);
      initTile(X, Y);
      bullets = bulletGroup;
    }

    public function activationSequence(title:String, frameIndex:uint, frame:uint):void {
      var t:Array = title.split(' ');
      if(frameIndex == 1 && (title == "horizontal" || title == "diagonal")) {
        fireBullet();
        play(title + " fire");
      } else if(frameIndex == 1 && (t[1] == "fire")) {
        play(t[0] + " rotate");
      } else if(frameIndex == 3 && t[1] == "rotate") {
        play(t[0] == "horizontal" ? "diagonal" : "horizontal"); 
      }
    }

    public function fireBullet():void {
      var bullet:BulletSprite = bullets.recycle(BulletSprite) as BulletSprite;
      bullet.init(x + (width/2 - bullet.width/2), y);
    }
  }
}
