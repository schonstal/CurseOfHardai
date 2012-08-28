package
{
  import org.flixel.*;

  public class GlitchSprite extends FlxSprite
  {
    public var frameTimer:Number = 0;
    public var frameThreshold:Number = 0.05;

    public function GlitchSprite():void {
      super(0,0);
      loadGraphic(Assets.Glitch, true, false, 400, 240, false);
    }

    public override function update():void {
      frameTimer += FlxG.elapsed;
      if(frameTimer >= frameThreshold) {
        frameTimer = 0;
        frame = Math.floor(Math.random() * 15);
        frameThreshold = Math.random()/10.0;
      }
      super.update();
    }
  }
}
