package com.noonat.refuge {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxSprite;
	import flash.media.Sound;
	import flash.utils.setTimeout;
	
	public class Player extends FlxSprite {
		protected static const BULLET_COUNT:uint = 1;
		protected static const COLOR:uint = 0xff2b2213; // brown
		protected static const COLOR_LIGHT:uint = 0xffffff99; // yellow
		protected static const SIZE:uint = 24;
		
		protected var _aim:Number = 0;
		protected var _aimX:Number = 0;
		protected var _aimY:Number = 0;
		protected var _bullets:FlxArray;
		protected var _lights:FlxArray;
		protected var _muzzle:FlxSprite;
		protected var _sndExplode:Sound;
		
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
			_lights.add(new Light(0, 0, SIZE*2));
			_lights.add(new Light(0, 0, SIZE*4, 0.3));
			_lights.add(new Light(0, 0, SIZE*8, 0.2));
			_lights.add(new Light(0, 0, SIZE*16, 0.1));
			for (i=0; i < _lights.length; ++i) lightsLayer.add(_lights[i]);
			
			// the muzzle is the little sprite attached to the end of the player turret
			_muzzle = new FlxSprite(null, 0, 0, false, false, SIZE/4, SIZE/4, COLOR_LIGHT);
			layer.add(_muzzle);
			
			_sndExplode = new Building.SndExplode();
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
		
		public function onGameOver():void {
			var _this:Player=this, oldX:Number=x;
			
			setTimeout(function():void { FlxG.play(_sndExplode, 0.7) }, 200);
			setTimeout(function():void { FlxG.play(_sndExplode, 0.7) }, 1000);
			setTimeout(function():void { FlxG.play(_sndExplode, 0.7) }, 2400);
			
			// sink into the ground
			Tweener.addTween(_this, {
				y:y+height*1.5, time:5, transition:'easeInQuad',
				onUpdate: function(t:Number):void {
					if (Math.random() < t*t) x = oldX + Math.floor(Math.random() * 3) - 2;
					else x = oldX;
				}
			});
			
			// rotate back to the top
			Tweener.addTween(_this, {angle:270, time:2, transition:'linear'});
			
			// fade out the lights
			function fadeOutLight(light:Light):void {
				var baseAlpha:Number = light.alpha;
				Tweener.addTween(light, {
					x:light.x, time:5, transition:'easeInQuad',
					onComplete: function():void { light.alpha = 0.0; light.kill(); },
					onUpdate: function(t:Number):void { light.alpha = baseAlpha - (t + Math.random()*0.3) * baseAlpha; }
				});
			}
			fadeOutLight(_lights[0]);
			setTimeout(function():void { fadeOutLight(_lights[1]); }, 1000);
			setTimeout(function():void { fadeOutLight(_lights[2]); }, 2000);
			//setTimeout(function():void { fadeOutLight(_lights[3]); }, 3000);
		}
		
		override public function update():void {
			var state:PlayState = (FlxG.state as PlayState);
			
			if (!state.gameOver) {
				if (FlxG.kLeft) angle = (angle - FlxG.elapsed * 120) % 360;
				if (FlxG.kRight) angle = (angle + FlxG.elapsed * 120) % 360;
			}
			_aimX = Math.cos(angle * (Math.PI / 180));
			_aimY = Math.sin(angle * (Math.PI / 180));
			if (!state.gameOver && (FlxG.justPressed(FlxG.A) || FlxG.justPressed(FlxG.B))) {
				_shootBullet();
			}
			
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