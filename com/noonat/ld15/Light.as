package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class Light extends FlxCore {
		public var alpha:Number=1.0;
		public var matrix:Matrix;
		public var radians:Number=0;
		public var shape:Shape;
		private var _angle:Number=0;
		private var _transform:Boolean=false;
		private var _scale:Number=1;
		
		public function Light(X:Number=0, Y:Number=0, Scale:Number=1, Angle:Number=0) {
			super();
			shape = new Shape();
			shape.graphics.beginFill(0x000000, 1.0);
			shape.graphics.drawCircle(0, 0, 1);
			shape.graphics.endFill();
			matrix = new Matrix();
			xy(X, Y);
			angle = Angle;
			scale = Scale;
			visible = false;
		}
		
		public function get angle():Number { return _angle; }
		public function set angle(Angle:Number):void {
			radians = Angle * (Math.PI / 180) * LightLayer.SCALE;
			_transform = true;
		}
		
		override public function kill():void { super.kill(); }
		
		public function renderInto(mask:BitmapData, colorTransform:ColorTransform):void {
			if (_transform) matrix.createBox(_scale, _scale, radians, x, y);
			if (alpha != 1.0) {
				colorTransform.alphaMultiplier = alpha;
				mask.draw(shape, matrix, colorTransform);
			}
			else mask.draw(shape, matrix);
		}
		
		public function get scale():Number { return _scale; }
		public function set scale(Scale:Number):void {
			_scale = Scale * LightLayer.SCALE;
			_transform = true;
		}
		
		override public function spawn():void {
			Tweener.removeTweens(this);
			super.spawn();
			alpha = 1.0;
		}
		
		public function xy(X:Number, Y:Number):void {
			x = X * LightLayer.SCALE;
			y = Y * LightLayer.SCALE;
			_transform = true;
		}
	}
}
