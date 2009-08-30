package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	import flash.display.*;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	
	public class LightLayer extends FlxLayer {
		public const ALPHA:uint = 0xcc;
		public static var SCALE:Number = 1/3;
		
		public var alpha:Number = 1.0;
		private var _lights:FlxArray;
		private var _m:Matrix, _p:Point, _r:Rectangle;
		private var _mask:BitmapData;
		private var _pixels:BitmapData;
		
		function LightLayer():void {
			_m = new Matrix();
			_m.scale(Math.floor(1/SCALE), Math.floor(1/SCALE));
			_p = new Point(0, 0);
			_r = new Rectangle(0, 0, Math.floor(FlxG.width*SCALE), Math.floor(FlxG.height*SCALE));
			_mask = new BitmapData(_r.width, _r.height);
			_pixels = new BitmapData(_r.width, _r.height, true, 0xffffffff);
		}
		
		override public function render():void {
			// draw masks for all the lights
			var colorTransform:ColorTransform = new ColorTransform();
			_mask.fillRect(_r, 0xff000000 + (Math.floor(ALPHA * alpha) & 0xff));
			for (var i:uint=0, l:uint=_children.length; i < l; ++i) {
				var light:Light = _children[i] as Light;
				if (light.exists) light.renderInto(_mask, colorTransform);
			}
			
			// blur them
			_mask.applyFilter(_mask, _r, _p, new BlurFilter(8, 8));
			
			// copy it to the alpha channel
			_pixels.fillRect(_r, 0x00000000);
			_pixels.copyChannel(_mask, _r, _p, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
			FlxG.buffer.draw(_pixels, _m);
		}
	}
}