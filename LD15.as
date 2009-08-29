package {
	import com.adamatomic.flixel.FlxGame;
	import com.noonat.ld15.PlayState;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class LD15 extends FlxGame
	{
		private const FLIXEL_BACKGROUND:uint = 0xffff0000;
		private const FLIXEL_FOREGROUND:uint = 0xff00ff00;
		
		public function LD15():void
		{
			super(320, 240, PlayState, 2, FLIXEL_BACKGROUND, true, FLIXEL_FOREGROUND);
			help("Jump", "Shoot", "Nothing");
		}
	}
}
