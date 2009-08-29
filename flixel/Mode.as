package {
	import com.adamatomic.flixel.FlxGame;
	import com.adamatomic.Mode.MenuState;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Mode extends FlxGame
	{
		public function Mode():void
		{
			super(320,240,MenuState,2,0xff131c1b,true,0xff729954);
			help("Jump", "Shoot", "Nothing");
		}
	}
}
