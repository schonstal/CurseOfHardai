package
{
  import org.flixel.*;

  public class Player extends FlxSprite
  {
    private var _speed:FlxPoint;
    private var _gravity:Number = 800; 

    private var _jumpPressed:Boolean = false;
    private var _grounded:Boolean = false;

    private var _groundedTimer:Number = 0;
    private var _groundedThreshold:Number = 0.07;
    
    private var currentRed:uint = 0;
    private var currentBlue:uint = 255;
    private var currentYellow:uint = 0;

    private var collisionFlags:uint = 0;

    private var jumpTimer:Number = 0;
    private var jumpThreshold:Number = 0.1;


    public static const WALL_LEFT:uint = 1 << 1;
    public static const WALL_RIGHT:uint = 1 << 2;
    public static const WALL_UP:uint = 1 << 3;
    public static var WALL:uint = WALL_LEFT|WALL_RIGHT|WALL_UP;

    public var lockedToFlags:uint = 0;

    public var jumpAmount:Number = 300;

    public function Player(X:Number,Y:Number):void {
      super(X,Y);
      //loadGraphic(ImgPlayer, true, true, 16, 20);
      makeGraphic(16,16,0xffcd7823);

      width = 16;
      height = 16;

      _speed = new FlxPoint();
      _speed.y = 250;
      _speed.x = 1000;

      acceleration.y = _gravity;

      maxVelocity.y = 400;
      maxVelocity.x = 300;
    }

    override public function update():void {
      //Check for jump input, allow for early timing
      jumpTimer += FlxG.elapsed;
      if(FlxG.keys.justPressed("W") || FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("UP")) {
        _jumpPressed = true;
        jumpTimer = 0;
      }
      if(jumpTimer > jumpThreshold) {
        _jumpPressed = false;
      }

      if(collidesWith(WALL_UP)) {
        maxVelocity.x = 200;
        _grounded = true;
        _groundedTimer = 0;
      } else {
        _groundedTimer += FlxG.elapsed;
        if(_groundedTimer >= _groundedThreshold) {
          _grounded = false;
        }
      }


      if(FlxG.keys.A) {
        acceleration.x = -_speed.x * (velocity.x > 0 ? 4 : 1);
      } else if(FlxG.keys.D) {
        acceleration.x = _speed.x * (velocity.x < 0 ? 4 : 1);
      } else if (Math.abs(velocity.x) < 50) {
        velocity.x = 0;
        acceleration.x = 0;
      } else {
        var drag:Number = 3;
        if (velocity.x > 0) {
          acceleration.x = -_speed.x * drag;
        } else if (velocity.x < 0) {
          acceleration.x = _speed.x * drag;
        }
      }

      if(_jumpPressed) {
          if(_grounded) {
            velocity.y = -_speed.y;
            _jumpPressed = false;
          }
      }

      if(FlxG.keys.LEFT) {
        jumpAmount--;
      }
      if(FlxG.keys.RIGHT) {
        jumpAmount++;
      }
          
      if(!(FlxG.keys.W || FlxG.keys.SPACE || FlxG.keys.UP) && velocity.y < 0)
        acceleration.y = _gravity * 3;
      else
        acceleration.y = _gravity;

      super.update();
    }

    public function resetFlags():void {
      collisionFlags = 0;
    }

    public function setCollidesWith(bits:uint):void {
      collisionFlags |= bits;
    }

    public function collidesWith(bits:uint):Boolean {
      return (collisionFlags & bits) > 0;
    }
  }
}
