package com.noonat.refuge.menu {
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxSprite;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SmokeLayer extends FlxLayer {
		protected var _smokeLeft:FlxArray, _smokeRight:FlxArray;
		protected var _smokeEmitterLeft:FlxEmitter, _smokeEmitterRight:FlxEmitter;
		protected var _filter:BlurFilter, _point:Point, _rect:Rectangle;
		
		public function SmokeLayer():void {
			super();
			
			// smoke
			_smokeLeft = _addSmokeParticles(100);
			_smokeRight = _addSmokeParticles(100);
			_smokeEmitterLeft = _addSmokeEmitter(0, FlxG.height-128-16, 216, 16, _smokeLeft);
			_smokeEmitterRight = _addSmokeEmitter(FlxG.width-200, FlxG.height-128-16, 200, 16, _smokeRight);
			
			// for blurring after rendering
			_filter = new BlurFilter(30, 30, 2);
			_point = new Point(0, 0);
			_rect = new Rectangle(0, 0, FlxG.width, FlxG.height);
		}
		
		internal function _addSmokeEmitter(x:int, y:int, width:uint, height:uint, sprites:FlxArray):FlxEmitter {
			var emitter:FlxEmitter;
			emitter = new FlxEmitter(x, y, width, height, sprites,
				0.1, // delay
				-10, 10, // min/max x
				-1, -20, // min/max y
				0, 0, // min/max angle
				5, // gravity
				1 // drag
			);
			add(emitter);
			return emitter;
		}
		
		internal function _addSmokeParticles(count:uint):FlxArray {
			var array:FlxArray = new FlxArray();
			var circle:Shape = new Shape();
			circle.graphics.beginFill(0xff669933);
			circle.graphics.drawCircle(5, 5, 5);
			circle.graphics.endFill();
			var circleBitmap:BitmapData = new BitmapData(10, 10, true, 0);
			circleBitmap.draw(circle);
			for (var i:int=0; i < count; ++i) {
				var sprite:FlxSprite = new FlxSprite(null, 0, 0, false, false, 10, 10, 0);
				sprite.pixels = circleBitmap;
				sprite.alpha = sprite.alpha;
				array.add(add(sprite));
			}
			return array;
		}
		
		public function collideSmoke(blocks:FlxArray):void {
			FlxG.collideArrays(blocks, _smokeLeft);
			FlxG.collideArrays(blocks, _smokeRight);
		}
		
		override public function render():void {
			super.render();
			FlxG.buffer.applyFilter(FlxG.buffer, _rect, _point, _filter);
		}
	}
}