package
{
  import org.flixel.*;

  public class DeatherSprite extends FlxSprite
  {
    public function DeatherSprite(X:Number, Y:Number) {
      super(X,Y);
      loadGraphic(Assets.Death, true, true, 20, 24);
      addAnimation("die", [0,1,2,3,4,5,6,7,8,9,9,10,11,12,13], 15, false);

      offset.x = 5;
      offset.y = 8;

      play("die", true);

      addAnimationCallback(animationLogic);
    }

    public function animationLogic(title:String, frameIndex:uint, frame:uint):void {
      if(frameIndex == 14) {
        FlxG.state.remove(this);
        var state:PlayState = (FlxG.state as PlayState);
        state.endLevel(false);
      }
    }

    public function init(X:Number, Y:Number):void {
      FlxG.state.add(this);
    }

    public override function update():void {
      if(finished) visible = false;
      super.update();
    }
  }
}
