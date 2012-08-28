package
{
  import org.flixel.*;

  public class MenuState extends FlxState
  {
    private var glitch:GlitchSprite;

    override public function create():void {
      glitch = new GlitchSprite();
      add(glitch);

      FlxG.playMusic(Assets.TitleMusic);
    }

    override public function update():void {
      if(FlxG.mouse.justPressed()) {
        FlxG.switchState(new PlayState());
      }
      super.update();
    }
  }
}
