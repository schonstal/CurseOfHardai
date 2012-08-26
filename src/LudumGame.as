package
{
  import org.flixel.*;
  [SWF(width="800", height="480", backgroundColor="#000000")]
  [Frame(factoryClass="Preloader")]

  public class LudumGame extends FlxGame
  {
    [Embed(source = '../data/adore64.ttf', fontFamily="adore", embedAsCFF="false")] public var AckFont:String;
    public function LudumGame() {
      FlxG.level = 0;
      super(400,240,PlayState,2);

      forceDebugger = true;
      FlxG.debug = true;
    }
  }
}
