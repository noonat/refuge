package com.noonat.ld15 {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class CreatureBitmaps {
		protected static var _bits:Array = [
			[[1,1,1,1,1],
			 [1,1,1,1,1],
			 [1,1,2,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [1,1,2,1,1],
			 [0,1,1,1,0],
			 [0,1,0,1,0],
			 [1,0,0,0,1]],
			
			[[0,0,1,0,0],
			 [1,1,2,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,0,0,0,0]],
			
			[[1,1,1,1,1],
			 [1,2,1,2,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [0,1,1,1,0],
			 [1,2,1,2,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,1,1,1,0],
			 [0,1,2,1,0],
			 [0,1,1,1,0],
			 [1,1,1,1,1],
			 [1,0,1,0,1]],
		];
		protected static var _bitsIndex:uint=0;
		protected static var _bitmaps:Array = [];
			
		public static function drawNext(pixels:BitmapData, matrix:Matrix):void {
			var i:uint = _bitsIndex++ % _bits.length;
			if (!_bitmaps[i]) {
				_bitmaps[i] = new BitmapData(5, 5, true, 0x00000000);
				for (var y:uint=0; y < 5; ++y) {
					for (var x:uint=0; x < 5; ++x) {
						var color:int = _bits[i][y][x];
						if (color === 1) _bitmaps[i].setPixel32(x, y, 0xffffffff);
					}
				}
			}
			pixels.draw(_bitmaps[i], matrix);
		}
	}
}