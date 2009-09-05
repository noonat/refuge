package com.noonat.refuge {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxCore;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class Light extends FlxCore {
		protected static var _colorTransform:ColorTransform;
		protected static var _defaultShape:Shape;
		
		public var alpha:Number = 1.0;
		public var matrix:Matrix;
		public var shape:Shape;
		protected var _angle:Number;
		protected var _matrix:Matrix;
		protected var _radians:Number;
		protected var _scale:Number;
		
		public function Light(x:Number=0, y:Number=0, scale:Number=1, alpha:Number=1, angle:Number=0, shape:Shape=null) {
			if (_colorTransform === null) {
				_colorTransform = new ColorTransform();
				_defaultShape = new Shape();
				_defaultShape.graphics.beginFill(0x000000, 1.0);
				_defaultShape.graphics.drawCircle(0, 0, 1);
				_defaultShape.graphics.endFill();
			}
			super();
			_matrix = new Matrix();
			this.alpha = alpha;
			this.angle = angle;
			this.scale = scale;
			this.shape = shape || _defaultShape;
			this.xy(x, y);
		}
		
		public function renderInto(alphaPixels:BitmapData, matrix:Matrix):void {
			_matrix.createBox(_scale, _scale, _radians, x, y);
			if (matrix) _matrix.concat(matrix);
			if (alpha != 1.0) {
				_colorTransform.alphaMultiplier = alpha;
				alphaPixels.draw(shape, _matrix, _colorTransform);
			}
			else alphaPixels.draw(shape, _matrix);
		}
		
		override public function spawn():void {
			Tweener.removeTweens(this);
			super.spawn();
			alpha = 1.0;
		}
		
		public function get angle():Number { return _angle; }
		public function set angle(value:Number):void {
			_angle = value;
			_radians = angle * (Math.PI / 180);
		}
		public function get radians():Number { return _radians; }
		public function set radians(value:Number):void {
			_radians = value;
			_angle = _radians * (180 / Math.PI);
		}
		public function get scale():Number { return _scale; }
		public function set scale(value:Number):void { _scale = value; }
		public function xy(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
	}
}
