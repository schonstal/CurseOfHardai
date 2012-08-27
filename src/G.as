package
{
    import org.flixel.*;

    public class G
    {
        public var _playedMusic:Boolean;
        public var _paused:Boolean;

        private static var _instance:G = null;

        public function G() {
        }

        private static function get instance():G {
            if(_instance == null) {
                _instance = new G();
                _instance._playedMusic = false;
                _instance._paused = false;
            }

            return _instance;
        }

        public static function get playedMusic():Boolean {
          return instance._playedMusic;
        }

        public static function set playedMusic(value:Boolean):void {
          instance._playedMusic = value;
        }

        public static function get paused():Boolean {
          return instance._paused;
        }

        public static function set paused(value:Boolean):void {
          instance._paused = value;
        }
    }
}
