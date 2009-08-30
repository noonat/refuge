package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class Light extends FlxCore {
		public var alpha:Number=1.0;
		public var matrix:Matrix;
		public var radians:Number=0;
		public var shape:Shape;
		private var _angle:Number=0;
		private var _scale:Number=1;
		private var _fading:Boolean=false;
		private var _fadeA:Number, _fadeB:Number;
		private var _fadeAt:Number, _fadeBt:Number;
		
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
			matrix.createBox(_scale, _scale, radians, x, y);
		}
		
		public function fadeOut(duration:Number=1.0):void {
			_fading = true;
			_fadeA = alpha;
			_fadeAt = FlxG.time;
			_fadeB = 0.0;
			_fadeBt = _fadeAt + 1.0;
		}
		
		override public function kill():void { super.kill(); _fading = false; }
		
		public function get scale():Number { return _scale; }
		public function set scale(Scale:Number):void {
			_scale = Scale * LightLayer.SCALE;
			matrix.createBox(_scale, _scale, radians, x, y);
		}
		
		override public function spawn():void {
			super.spawn();
			alpha = 1.0;
			_fading = false;
		}
		
		override public function update():void {
			if (_fading) {
				if (FlxG.time >= _fadeBt) { alpha = _fadeB; kill(); }
				else alpha = _fadeA + (_fadeB - _fadeA) * ((FlxG.time - _fadeAt) / (_fadeBt - _fadeAt));
			}
		}
		
		public function xy(X:Number, Y:Number):void {
			x = X * LightLayer.SCALE;
			y = Y * LightLayer.SCALE;
			matrix.createBox(_scale, _scale, radians, x, y);
		}
	}
}
