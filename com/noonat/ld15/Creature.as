package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.*;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class Creature extends FlxSprite {
		public var dying:Boolean = false;
		private var _explosionSprites:FlxArray = new FlxArray();
		private var _explosion:FlxEmitter;
		private var _light:Light;
		private var _downSpeed:Number;
		private var _b:uint, _argb:uint;
		
		public function Creature() {
			super(null, 0, 0, false, false, 20, 20, 0x00000000);
			pixels = pixels.clone();
			spawn();
			
			alpha = 1.0;
			acceleration.y = 80;
			maxVelocity.y = 5;
			velocity.x = Math.random() * 60 - 30;
			
			_downSpeed = 5 + Math.random() * 20;
			
			var g:Number=0xff669933;
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,6,6,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,_argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,_argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,_argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,6,6,_argb));
			for (var i:uint=0; i < _explosionSprites.length; ++i) FlxG.state.add(_explosionSprites[i]);
			_explosion = FlxG.state.add(new FlxEmitter(
				0, 0, // x, y
				width/2, height/2, // w, h
				_explosionSprites, // sprites
				0.2, // delay
				-10, 10, // min vx, max vx
				0, 50, // min vy, max vy
				-720, 720, // min max rot
				20, // gravity,
				0, // drag
				null, 0, false // sheet, quantity, multiple
			)) as FlxEmitter;
			_explosion.kill();
			
			_light = new Light(0, 0, 1, 0);
			_light.kill();
			(FlxG.state as PlayState).lights.add(_light);
		}
		
		internal function _explode(delay:Number=0.2):void {
			_explosion._delay = delay;
			_explosion.reset();
		}
		
		internal function _flash(radius:Number):void {
			_light.spawn();
			_light.xy(x, y);
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
			maxVelocity.y = 80;
			dying = true;
			_explode(0.6);
			_flash(40);
			pixels.colorTransform(_r, _ct);
			alpha = alpha;
		}
		
		override public function hitFloor():Boolean {
			if (dying) {
				super.kill();
				_explode(-1.5);
				_flash(60);
			}
			return true;
		}
		
		override public function hitWall(movingRight:Boolean):Boolean {
			velocity.x *= -1;
			return true;
		}
		
		public function redraw():void {
			// draw the 5x5 sprite
			var i:uint = _next++;
			if (_next >= _bits.length) _next = 0;
			_pxls.fillRect(_pxlsr, 0x00000000);
			_b = 75 + Math.floor(Math.random() * (255 - 75));
			_argb = 0xff000000 | (_b << 16) | (_b << 8) | _b;
			for (var y:uint=0; y < 5; ++y) {
				for (var x:uint=0; x < 5; ++x) {
					if (_bits[i][y][x]) _pxls.setPixel32(x, y, _argb);
				}
			}
			
			// blit it into the bigger one
			pixels.draw(_pxls, _pxlsm);
		}
		
		override public function spawn():void {
			super.spawn();
			redraw();
		}
		
		override public function update():void {
			_explosion.x = x;
			_explosion.y = y;
			if (dying) maxVelocity.y = 80;
			else if (y > 64) maxVelocity.y = _downSpeed;
			else maxVelocity.y = _downSpeed + Math.min(((64-y)/64)*(80-_downSpeed), (80-_downSpeed));
			super.update();
			if (_light.exists && (_light.x != x || _light.y != y))
				_light.xy(x+width/2, y+height/2);
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
		private static var _r:Rectangle = new Rectangle(0, 0, 20, 20);
		private static var _ct:ColorTransform = new ColorTransform(0.4, 0.6, 0.2, 1.0, 50, 50, 50);
	}
}
