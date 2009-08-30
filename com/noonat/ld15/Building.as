package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	
	public class Building extends FlxSprite {
		function Building(X:int, Y:int, W:uint=16, H:uint=16):void {
			super(null, X, Y, false, false, W, H, 0xff000000);
			acceleration.y = 20;
		}
		
		override public function kill():void {
			super.kill();
		}
	}
}

