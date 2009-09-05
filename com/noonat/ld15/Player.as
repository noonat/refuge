package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class Player extends FlxSprite {
		private static const BULLET_COUNT:uint = 1;
		private static const COLOR:uint = 0xff2b2213; // brown
		private static const COLOR_LIGHT:uint = 0xffffff99; // yellow
		private static const SIZE:uint = 24;
		
		private var _aim:Number = 0;
		private var _aimX:Number = 0;
		private var _aimY:Number = 0;
		private var _bullets:FlxArray;
		private var _lights:FlxArray;
		private var _muzzle:FlxSprite;
		
		function Player(layer:FlxLayer, lightsLayer:FlxLayer):void {
			// initialize the player
			super(null, 0, 0, false, false, SIZE, SIZE, COLOR);
			drag.x = 10;
			drag.y = 10;
			angularDrag = 40;
			maxAngular = 80;
			maxVelocity.x = 50;
			maxVelocity.y = 100;
			
			// give him some bullets
			_bullets = new FlxArray();
			for (var i:int=0; i < BULLET_COUNT; ++i) {
				_bullets.add(layer.add(new Bullet(layer, lightsLayer)));
			}
			
			// give him some lights
			_lights = new FlxArray();
			_lights.add(new Light(0, 0, SIZE*2, 0));
			_lights.add(new Light(0, 0, SIZE*4, 0, 0.3));
			_lights.add(new Light(0, 0, SIZE*8, 0, 0.2));
			_lights.add(new Light(0, 0, SIZE*16, 0., 0.1));
			for (i=0; i < _lights.length; ++i) lightsLayer.add(_lights[i]);
			
			// the muzzle is the little sprite attached to the end of the player turret
			_muzzle = new FlxSprite(null, 0, 0, false, false, SIZE/4, SIZE/4, COLOR_LIGHT);
			layer.add(_muzzle);
		}
		
		public function disableBullets():void {
			for (var i:int=0; i < _bullets.length; ++i) {
				if (_bullets[i]) _bullets[i].active = false;
			}
		}
		
		public function enableBullets():void {
			for (var i:int=0; i < _bullets.length; ++i) {
				if (_bullets[i]) _bullets[i].active = true;
			}
		}
		
		protected function _onBulletHitCreature(bullet:Bullet, creature:Creature):void {
			if (!creature.dying) {
				(FlxG.state as PlayState).onEvent(
					PlayState.EVENT_KILL,
					{killed:creature, bullet:bullet});
				creature.kill();
				creature.velocity.x += bullet.velocity.x;
				creature.velocity.y += bullet.velocity.y;
			}
			else {
				creature.velocity.x += bullet.velocity.x * 0.5;
				creature.velocity.y += bullet.velocity.y * 0.5;
			}
			bullet.hurt(1);
		}
		
		protected function _shootBullet():FlxSprite {
			var bullet:Bullet = _bullets.getNonexist() as Bullet;
			if (!bullet) return null; // don't shoot anything if all bullets are in flight
			bullet.shoot(_muzzle.x, _muzzle.y, _aimX, _aimY);
			return bullet;
		}
		
		override public function update():void {
			_aimX = Math.cos(angle * (Math.PI / 180));
			_aimY = Math.sin(angle * (Math.PI / 180));
			
			if (FlxG.kLeft) angle -= FlxG.elapsed * 120;
			if (FlxG.kRight) angle += FlxG.elapsed * 120;
			if (FlxG.justPressed(FlxG.A)) _shootBullet();
			
			super.update();
			
			// move the lights to match the angle
			for (var i:int=0; i < _lights.length; ++i) {
				var s:Number = _lights[i].scale;
				if (i === 0) s /= 2;
				_lights[i].xy(x + width/2 + _aimX*s, y + _aimY*s)
			}
			
			// move the muzzle to match the angle
			_muzzle.angle = angle;
			_muzzle.x = (x + (width * 0.5)) - (_muzzle.width * 0.5);
			_muzzle.y = (y + (height * 0.5)) - (_muzzle.height * 0.5);
			_muzzle.x += SIZE/2 * _aimX;
			_muzzle.y += SIZE/2 * _aimY;
		}
		
		public function updateBullets():void {
			var state:PlayState = FlxG.state as PlayState;
			
			// enable the bullets again so we can update them
			enableBullets();
			
			// tick over the bullets a couple times
			// we have to tick these manually because of collision issues
			for (var bulletIterations:int=0; bulletIterations < 16; ++bulletIterations) {
				for (var i:int=0; i < _bullets.length; ++i) {
					var b:Bullet = _bullets[i];
					if (b && b.exists && b.active) b.update();
				}
				FlxG.collideArrays(state.blocksLayer.blocks, _bullets);
				FlxG.overlapArrays(_bullets, state.creaturesLayer.creatures, _onBulletHitCreature);
			}
		}
	}
}