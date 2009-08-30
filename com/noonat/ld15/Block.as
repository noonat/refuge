package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Block extends FlxCore {
		public var _pixels:BitmapData;
		public var _alpha:Boolean;
		public var _rect:Rectangle;
		public var _p:Point = new Point(0, 0);
		
		function Block(X:Number, Y:Number, Width:Number, Height:Number, Color:uint, Alpha:Boolean=false):void {
			super();
			x = X;
			y = Y;
			width = Width;
			height = Height;
			_rect = new Rectangle(0, 0, width, height);
			_pixels = new BitmapData(width, height);
			_pixels.fillRect(_rect, Color);
			_alpha = Alpha;
		}
		
		override public function render():void {
			_p.x = x;
			_p.y = y;
			FlxG.buffer.copyPixels(_pixels, _rect, _p, null, null, _alpha);
		}
	}
}