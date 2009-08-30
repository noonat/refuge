package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.*;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class Creature extends FlxSprite {
		private var _explosionSprites:FlxArray = new FlxArray();
		private var _explosion:FlxEmitter;
		private var _dying:Boolean = false;
		private var _light:Light;
		
		public function Creature() {
			var i:uint, b:uint, argb:uint;
			
			// draw the 5x5 sprite
			i = _next++;
			if (_next >= _bits.length) _next = 0;
			_pxls.fillRect(_pxlsr, 0x00000000);
			b = 75 + Math.floor(Math.random() * (255 - 75));
			argb = 0xff000000 | (b << 16) | (b << 8) | b;
			for (var y:uint=0; y < 5; ++y) {
				for (var x:uint=0; x < 5; ++x) {
					if (_bits[i][y][x]) _pxls.setPixel32(x, y, argb);
				}
			}
			
			// blit it into the bigger one
			super(null, 0, 0, false, false, 20, 20, 0x00000000);
			pixels = pixels.clone();
			pixels.draw(_pxls, _pxlsm);
			
			alpha = 1.0;
			
			var g:Number=0xff669933;
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,6,6,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,6,6,argb));
			for (i=0; i < _explosionSprites.length; ++i) FlxG.state.add(_explosionSprites[i]);
			_explosion = FlxG.state.add(new FlxEmitter(
				0, 0, // x, y
				width, height, // w, h
				_explosionSprites, // sprites
				-0.5, // delay
				-20, 20, // min vx, max vx
				0, 50, // min vy, max vy
				-720, 720, // min max rot
				20, // gravity,
				0, // drag
				null, 0, false // sheet, quantity, multiple
			)) as FlxEmitter;
			
			_light = new Light(0, 0, 1, 0);
			_light.kill();
			(FlxG.state as PlayState).lights.add(_light);
		}
		
		override public function hitFloor():Boolean {
			if (_dying) {
				super.kill();
				_explode();
				_flash(40);
			}
			return true;
		}
		
		internal function _explode():void {
			_explosion.x = x;
			_explosion.y = y;
			_explosion.reset();
		}
		
		internal function _flash(radius:Number):void {
			_light.spawn();
			_light.scale = radius;
			Tweener.addTween(_light, {
				scale:1, time:2,
				transition: 'linear',
				onComplete: function():void {
					_light.kill();
				}
			});
		}
		
		override public function kill():void {
			acceleration.y = 80;
			_dying = true;
			_flash(40);
		}
		
		override public function update():void {
			super.update();
			if (_light.x != x || _light.y != y) _light.xy(x+width/2, y+height/2);
		}

		private static var _bits:Array = [
			[[1,1,1,1,1],
			 [1,1,1,1,1],
			 [1,1,0,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [1,1,0,1,1],
			 [0,1,1,1,0],
			 [0,1,0,1,0],
			 [1,0,0,0,1]],
			
			[[0,0,1,0,0],
			 [1,1,0,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,0,0,0,0]],
			
			[[1,1,1,1,1],
			 [1,0,1,0,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [0,1,1,1,0],
			 [1,0,1,0,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,1,1,1,0],
			 [0,1,0,1,0],
			 [0,1,1,1,0],
			 [1,1,1,1,1],
			 [1,0,1,0,1]],

			/*
			[[],
			 [],
			 [],
			 [],
			 []],
			
			*/
		];
		private static var _next:uint=0;
		private static var _pxls:BitmapData = new BitmapData(5, 5, true, 0x00000000);
		private static var _pxlsm:Matrix = new Matrix(4, 0, 0, 4);
		private static var _pxlsr:Rectangle = new Rectangle(0, 0, 5, 5);
	}
}
