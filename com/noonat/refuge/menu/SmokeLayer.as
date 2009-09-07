package com.noonat.refuge.menu {
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SmokeLayer extends FlxLayer {
		protected var _pixels:BitmapData;
		protected var _point:Point, _rect:Rectangle;
		
		public function SmokeLayer():void {
			super();
			
			_pixels = new BitmapData(FlxG.width, FlxG.height, true, 0x00000000);
			_point = new Point(0, 0);
			_rect = new Rectangle(0, 0, _pixels.width, _pixels.height);
			
			// draw a green gradient against the background
			var m:Matrix = new Matrix();
			m.createGradientBox(FlxG.width, FlxG.height, 90*(Math.PI/180), 0, 0);
			var gradient:Shape = new Shape();
			gradient.graphics.beginGradientFill(GradientType.LINEAR,
				[0x669933, 0x000000], [0.0, 0.5], [0, 255], m);
			gradient.graphics.drawRect(0, 0, FlxG.width, FlxG.height);
			gradient.graphics.endFill();
			_pixels.draw(gradient);
			
			// draw some smokey green blobs on top of it
			var circle:Shape = new Shape();
			circle.graphics.beginFill(0xff669933);
			circle.graphics.drawCircle(5, 5, 5);
			circle.graphics.endFill();
			
			m.identity();
			function randomCircles(x:Number, y:Number, w:Number):void {
				for (var i:int=0; i < 100; ++i) {
					m.tx = x + Math.random()*w;
					var r:Number = Math.random();
					if (r < 0.7) m.ty = Math.random()*8;
					else if (r < 0.9) m.ty = 16 + Math.random()*8;
					else m.ty = 32 + Math.random()*16;
					m.ty = (y+32) - m.ty;
					m.a = m.d = Math.random();
					_pixels.draw(circle, m);
				}
			}
			randomCircles(0, FlxG.height-128-32, 216);
			randomCircles(FlxG.width-180, FlxG.height-128-32, 200);
			
			// blur it all a bunch
			_pixels.applyFilter(_pixels, _rect, _point, new BlurFilter(30, 30, 3));
		}
		
		override public function render():void {
			FlxG.buffer.copyPixels(_pixels, _rect, _point);
		}
	}
}