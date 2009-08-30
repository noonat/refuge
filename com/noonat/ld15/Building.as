package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.*;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	public class Building extends FlxSprite {
		private var _dying:Boolean = false;
		private var _health:int = 3;
		private var _hurtFlag:int=0;
		
		function Building(X:int, Y:int, W:uint=16, H:uint=16):void {
			super(null, X, Y, false, false, W, H, 0xff000000);
			pixels = pixels.clone();
			pixels.lock();
			for (var wy:int=0; wy < 4; ++wy) {
				for (var wx:int=0; wx < 4; ++wx) {
					if (Math.random() < 0.5) {
						var b:uint = 128 + Math.floor(Math.random() * 128);
						b = 0xff000000 | (b << 16) | (b << 8) | b;
						pixels.setPixel32(2+wx*5+0, wy*4+2, b);
						pixels.setPixel32(2+wx*5+1, wy*4+2, b);
						pixels.setPixel32(2+wx*5+0, wy*4+3, b);
						pixels.setPixel32(2+wx*5+1, wy*4+3, b);
					}
				}
			}
			pixels.unlock();
			alpha = alpha; // hack to get _pixels to update
			_health = 3;
		}
		
		override public function hurt(Damage:Number):void {
			if (dead || _dying) return;
			_health -= Damage;
			_hurtFlag = 2;
			if (_health > 0) return;
			kill();
		}
		
		override public function kill():void {
			if (dead || _dying) return;
			_dying = true;
			var oldX:int = x;
			Tweener.addTween(this, {
				y:y+height, time:3.0,
				transition: 'easeInQuad',
				onComplete: function():void {
					_superKill();
				},
				onUpdate: function(t:Number):void {
					if (Math.random() < t*t) x = oldX + Math.floor(Math.random() * 3) - 2;
					else x = oldX;
				}
			});
		}
		
		override public function render():void {
			super.render();
			if (_hurtFlag) {
				--_hurtFlag;
				FlxG.buffer.colorTransform(new Rectangle(x, y, width, height), _hurtTransform);
			}
		}
		
		internal function _superKill():void { super.kill(); }
		
		private static var _hurtTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 32, 0);
	}
}
