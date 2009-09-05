package {
	import com.adamatomic.flixel.FlxGame;
	import com.noonat.ld15.PlayState;
	
	[SWF(width="480", height="640", backgroundColor="#111111")]
	[Frame(factoryClass="Preloader")]

	public class Refuge extends FlxGame
	{
		private const FLIXEL_BACKGROUND:uint = 0xff111111;
		private const FLIXEL_FOREGROUND:uint = 0xffcccccc;
		
		public function Refuge():void
		{
			super(480, 640, PlayState, 1, FLIXEL_BACKGROUND, true, FLIXEL_FOREGROUND);
			help("Jump", "Shoot", "Nothing");
		}
	}
}