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
        fireBullets(title == "horizontal");
        play(title + " fire");
      } else if(frameIndex == 1 && (t[1] == "fire")) {
        play(t[0] + " rotate");
      } else if(frameIndex == 3 && t[1] == "rotate") {
        play(t[0] == "horizontal" ? "diagonal" : "horizontal"); 
      }
    }

    public function fireBullets(horizontal:Boolean):void {
      var bullet:BulletSprite;
      if(horizontal) {
        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x + (width/2 - bullet.width/2), y - 10);
        bullet.velocity.y = -BulletSprite.SPEED;

        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x + (width/2 - bullet.width/2), y + 20);
        bullet.velocity.y = BulletSprite.SPEED;

        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x - 10, y + (height/2 - bullet.height/2));
        bullet.velocity.x = -BulletSprite.SPEED;

        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x + 20, y + (height/2 - bullet.height/2));
        bullet.velocity.x = BulletSprite.SPEED;
      } else {
        var speed:Number = BulletSprite.SPEED * 0.7;
        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x-7, y-7);
        bullet.velocity.y = -speed;
        bullet.velocity.x = -speed;

        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x-7, y+17);
        bullet.velocity.y = speed;
        bullet.velocity.x = -speed;

        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x+17, y-7);
        bullet.velocity.y = -speed;
        bullet.velocity.x = speed;

        bullet = bullets.recycle(BulletSprite) as BulletSprite;
        bullet.init(x+17, y+17);
        bullet.velocity.y = speed;
        bullet.velocity.x = speed;
      }
    }
  }
}
