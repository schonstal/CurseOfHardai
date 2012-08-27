package
{
  import org.flixel.*;

  public class TeleporterSprite extends FlxSprite
  {
    public function TeleporterSprite(X:Number, Y:Number) {
      super(X,Y);
      loadGraphic(Assets.Teleport, true, true, 20, 240);
      addAnimation("go", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 14], 15, false);
      addAnimation("return", [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0], 15, false);

      //visible = false;
      x -= 5;
      y -= 224;

      play("return", true);

      addAnimationCallback(animationLogic);
    }

    public function animationLogic(title:String, frameIndex:uint, frame:uint):void {
      if(frameIndex == 14) {
        FlxG.state.remove(this);
        var state:PlayState = (FlxG.state as PlayState);
        title == "return" ? state.startLevel() : state.endLevel();
      }
    }

    public function init(X:Number, Y:Number):void {
      FlxG.state.add(this);
      x = X - 5;
      y = Y - 224;
    }

    public override function update():void {
      if(finished) visible = false;
      super.update();
    }
  }
}
