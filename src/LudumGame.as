package
{
  import org.flixel.*;
  [SWF(width="640", height="480", backgroundColor="#000000")]
  [Frame(factoryClass="Preloader")]

  public class LudumGame extends FlxGame
  {
    [Embed(source = '../data/adore64.ttf', fontFamily="adore", embedAsCFF="false")] public var AckFont:String;
    public function LudumGame() {
      super(320,240,PlayState,2);
    }
  }
}
