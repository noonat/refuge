package com.noonat.refuge {
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class LightsLayer extends FlxLayer {
		public static const SCALE:Number = 1/3;
		
		public var alpha:Number;
		protected var _filter:BlurFilter;
		protected var _matrix:Matrix, _inverseMatrix:Matrix;
		protected var _point:Point, _rect:Rectangle;
		protected var _pixels:BitmapData, _alphaPixels:BitmapData;
		protected var _gradient:Shape;
		protected var _gradientMatrix:Matrix;
		
		function LightsLayer(scale:Number=1, alpha:Number=1.0, blurX:Number=8, blurY:Number=8):void {
			this.alpha = alpha;
			_filter = new BlurFilter(blurX, blurY);
			_matrix = new Matrix();
			_matrix.scale(Math.floor(1/scale), Math.floor(1/scale));
			_inverseMatrix = new Matrix();
			_inverseMatrix.scale(scale, scale);
			_point = new Point(0, 0);
			_rect = new Rectangle(0, 0, Math.floor(FlxG.width*scale), Math.floor(FlxG.height*scale)+1);
			_pixels = new BitmapData(_rect.width, _rect.height, true);
			_alphaPixels = new BitmapData(_rect.width, _rect.height);
			
			// vignette gradient overlay
			_gradientMatrix = new Matrix();
			_gradientMatrix.createGradientBox(_rect.height * 2, _rect.height * 2, 270 * (Math.PI/180), (_rect.height*2 - _rect.width)*-0.5);
			_gradient = new Shape();
			_gradient.graphics.beginGradientFill(GradientType.RADIAL,
				[0x000000 + Math.floor(0xff * alpha), 0x0000ff], [1, 1], [240, 255], _gradientMatrix);
			_gradient.graphics.drawRect(0, 0, _rect.width, _rect.height);
			_gradient.graphics.endFill();
			_gradient.cacheAsBitmap = true;
		}
		
		override public function render():void {
			// draw masks for all the lights
			_alphaPixels.fillRect(_rect, Math.floor(0xff * alpha) | 0xff000000);
			if (!(FlxG.state as PlayState).gameOver) _alphaPixels.draw(_gradient);
			for (var i:uint=0; i < _children.length; ++i) {
				var light:Light = _children[i] as Light;
				if (light.exists) light.renderInto(_alphaPixels, _inverseMatrix);
			}
			
			// blur them
			_alphaPixels.applyFilter(_alphaPixels, _rect, _point, _filter);
			
			// copy it to the alpha channel
			_pixels.fillRect(_rect, 0x00000000);
			_pixels.copyChannel(_alphaPixels, _rect, _point, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
			FlxG.buffer.draw(_pixels, _matrix);
		}
	}
}
