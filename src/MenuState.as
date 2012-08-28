package
{
  import org.flixel.*;

  public class MenuState extends FlxState
  {
    private var glitch:GlitchSprite;

    override public function create():void {
      glitch = new GlitchSprite();
      add(glitch);

      var titleGraphic:FlxSprite = new FlxSprite();
      titleGraphic.loadGraphic(Assets.Title, true, false, 400, 240, false);
      add(titleGraphic);

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
