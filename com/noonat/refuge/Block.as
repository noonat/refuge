package com.noonat.refuge {
	import com.adamatomic.flixel.FlxCore;
	import com.adamatomic.flixel.FlxG;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class Block extends FlxCore {
		public var pixels:BitmapData;
		protected var _alpha:Boolean;
		protected var _p:Point;
		
		function Block(X:Number, Y:Number, Width:Number, Height:Number, Color:uint, Alpha:Boolean=false):void {
			super();
			x = X;
			y = Y;
			width = Width;
			height = Height;
			pixels = new BitmapData(width, height);
			pixels.fillRect(pixels.rect, Color);
			_alpha = Alpha;
			_p = new Point(0, 0);
		}
		
		override public function render():void {
			if (!onScreen()) return;
			getScreenXY(_p);
			FlxG.buffer.copyPixels(pixels, pixels.rect, _p, null, null, _alpha);
		}
	}
}