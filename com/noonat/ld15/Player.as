package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class Player extends FlxSprite {
		private const COLOR:uint = 0xff661100;
		private const COLOR_LIGHT:uint = 0xffffff99;
		private const DEBOUNCE:Number = 0.8;
		private const SIZE:uint = 24;
		
		private var _aim:Number = 0;
		private var _aimX:Number = 0;
		private var _aimY:Number = 0;
		private var _bullets:FlxArray;
		private var _dirX:Number = 0;
		private var _dirY:Number = 0;
		private var _lights:FlxArray;
		private var _muzzle:FlxSprite;
		private var _speed:Number;
		
		function Player(Bullets:FlxArray):void {
			super(null, 0, 0, false, false, SIZE, SIZE, COLOR);
			drag.x = 10;
			drag.y = 10;
			angularDrag = 40;
			maxAngular = 80;
			maxVelocity.x = 50;
			maxVelocity.y = 100;
			
			_bullets = Bullets;
			for (var i:int=0; i < 1; ++i) {
				_bullets.add(FlxG.state.add(new Bullet()));
			}
			_lights = new FlxArray();
			_lights.add(new Light(0, 0, SIZE*2, 0));
			_lights.add(new Light(0, 0, SIZE*4, 0, 0.3));
			_lights.add(new Light(0, 0, SIZE*8, 0, 0.2));
			_lights.add(new Light(0, 0, SIZE*16, 0., 0.1));
			for (i=0; i < _lights.length; ++i) (FlxG.state as PlayState).lights.add(_lights[i]);
			_muzzle = new FlxSprite(null, 0, 0, false, false, SIZE/4, SIZE/4, COLOR_LIGHT);
			FlxG.state.add(_muzzle);
		}
		
		private var _hitWall:Boolean = false, _touchingWall:Boolean = false;
		private var _hitFloor:Boolean = false, _touchingFloor:Boolean = false;
		override public function hitWall(movingRight:Boolean):Boolean {
			_hitWall = true;
			if (_touchingWall) {
				if (movingRight) velocity.x = Math.min(velocity.x, 0);
				else velocity.x = Math.max(velocity.x, 0);
			}
			else velocity.x *= -DEBOUNCE;
			_touchingWall = true;
			return true;
		}
		override public function hitFloor():Boolean {
			_hitFloor = true;
			if (_touchingFloor) velocity.y = Math.min(velocity.y, 0);
			else velocity.y = (velocity.y + 40) * -DEBOUNCE;
			_touchingFloor = true;
			return true;
		}
		override public function hitCeiling():Boolean {
			if (velocity.y < 0) velocity.y = 0;
			return true;
		}
		public function postCollide():void {
			if (_touchingWall && !_hitWall) _touchingWall = false;
			if (_touchingFloor && !_hitFloor) _touchingFloor = false;
		}
		
		public function shootBullet():FlxSprite {
			var bullet:Bullet = _bullets.getNonexist() as Bullet;
			if (!bullet) return null;//bullet = _bullets.add(FlxG.state.add(new Bullet())) as Bullet;
			bullet.shoot(_muzzle.x, _muzzle.y, _aimX, _aimY);
			return bullet;
		}
		
		override public function update():void {
			_aimX = Math.cos(angle * (Math.PI / 180));
			_aimY = Math.sin(angle * (Math.PI / 180));
			
			if (FlxG.kLeft) angle -= FlxG.elapsed * 120;
			if (FlxG.kRight) angle += FlxG.elapsed * 120;
			
			//var thrust:Number = 0;
			//if (FlxG.kUp) thrust += 50;
			//if (FlxG.kDown) thrust -= 50;
			//velocity.x += _aimX * thrust * FlxG.elapsed;
			//velocity.y += _aimY * thrust * FlxG.elapsed;
			
			if (FlxG.justPressed(FlxG.A)) shootBullet();
			
			super.update();
			//y += 40 * FlxG.elapsed;
			
			for (var i:int=0; i < _lights.length; ++i) {
				var s:Number = _lights[i].scale;
				if (i === 0) s /= 2;
				_lights[i].xy(x + width/2 + _aimX*s, y + _aimY*s)
			}
			
			_muzzle.angle = angle;
			_muzzle.x = (x + (width * 0.5)) - (_muzzle.width * 0.5);
			_muzzle.y = (y + (height * 0.5)) - (_muzzle.height * 0.5);
			_muzzle.x += SIZE/2 * _aimX;
			_muzzle.y += SIZE/2 * _aimY;
		}
	}
}