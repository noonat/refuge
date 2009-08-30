package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	
	public class Creature extends FlxSprite {
		public function Creature() {
			var b:uint = 75 + Math.floor(Math.random() * (255 - 75));
			var argb:uint = 0xff000000 | (b << 16) | (b << 8) | b;
			super(null, 0, 0, false, false, 5, 5, 0x00000000);
			pixels = pixels.clone();
			pixels.lock();
			var i:uint = _next++;
			if (_next >= _bits.length) _next = 0;
			for (var y:uint=0; y < 5; ++y) {
				for (var x:uint=0; x < 5; ++x) {
					if (_bits[i][y][x]) pixels.setPixel32(x, y, argb);
				}
			}
			pixels.unlock();
			scale.x = 4;
			scale.y = 4;
			alpha = 1.0;
		}

		private static var _bits:Array = [
			[[1,1,1,1,1],
			 [1,1,1,1,1],
			 [1,1,0,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [1,1,0,1,1],
			 [0,1,1,1,0],
			 [0,1,0,1,0],
			 [1,0,0,0,1]],
			
			[[0,0,1,0,0],
			 [1,1,0,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,0,0,0,0]],
			
			[[1,1,1,1,1],
			 [1,0,1,0,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [0,1,1,1,0],
			 [1,0,1,0,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,1,1,1,0],
			 [0,1,0,1,0],
			 [0,1,1,1,0],
			 [1,1,1,1,1],
			 [1,0,1,0,1]],

			/*
			[[],
			 [],
			 [],
			 [],
			 []],
			
			*/
		];
		private static var _next:uint=0;
	}
}
