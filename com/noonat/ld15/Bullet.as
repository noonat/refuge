package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxSprite;
	import flash.media.Sound;
	
	public class Bullet extends FlxSprite {
		[Embed(source="../../../data/bullet_explode.mp3")] private var SndExplode:Class;
		[Embed(source="../../../data/bullet_shoot.mp3")] private var SndShoot:Class;
		
		public static const COLOR:uint = 0xffffff00;
		public static const ELASTICITY:Number = 0.4;
		public static const SPEED:Number = 25;
		public static const SIZE:uint = 6;
		public var bounces:int = 0;
		protected var _explosion:FlxEmitter;
		protected var _light:Light;
		protected var _sndExplode:Sound;
		protected var _sndShoot:Sound;
		protected var _spawnTime:Number;
		
		public function Bullet(layer:FlxLayer, lightsLayer:FlxLayer):void {
			super(null, 0, 0, false, false, SIZE, SIZE, COLOR);
			acceleration.y = 0.5;
			dead = true;
			exists = false;
			finished = false;
			_explosion = new BulletExplosion(layer);
			_light = new Light(0, 0, SIZE*4, 0);
			_light.kill();
			lightsLayer.add(_light);
			_sndExplode = new SndExplode();
			_sndShoot = new SndShoot();
		}
		
		override public function hitWall(movingRight:Boolean):Boolean {
			++bounces;
			hurt(1);
			if (!dead) velocity.x = -velocity.x * ELASTICITY;
			return true;
		}
		
		override public function hitFloor():Boolean {
			hurt(1);
			if (!dead) velocity.y = -velocity.y * ELASTICITY;
			return true;
		}
		
		override public function hitCeiling():Boolean {
			hurt(1);
			if (!dead) velocity.y = -velocity.y * ELASTICITY;
			return true;
		}
		
		override public function hurt(Damage:Number):void {
			if (dead) return;
			FlxG.play(_sndExplode, 0.7);
			if (--health > 0) return;
			kill();
			velocity.x = 0;
			velocity.y = 0;
			_explosion.x = x + width / 2;
			_explosion.y = y + height / 2;
			_explosion.reset();
		}
		
		override public function kill():void {
			super.kill();
			Tweener.addTween(_light, {
				scale:1, time:1, transition:'linear',
				onComplete: function():void {
					_light.kill();
				},
				onUpdate: function(t:Number):void {
					_light.alpha = Math.random();
				}
			});
		}
		
		public function get lifeTime():Number {
			return FlxG.time - _spawnTime;
		}
		
		public function shoot(X:Number, Y:Number, DirX:Number, DirY:Number):void {
			FlxG.play(_sndShoot, 0.2);
			spawn();
			bounces = 0;
			health = 2;
			velocity.x = DirX * SPEED;
			velocity.y = DirY * SPEED;
			x = X;
			y = Y;
			_light.scale = SIZE * 4;
			_light.xy(this.x, this.y);
			_spawnTime = FlxG.time;
		}
		
		override public function spawn():void { super.spawn(); _light.spawn(); }
		
		override public function update():void {
			_light.xy(this.x + this.width/2, this.y + this.height/2);
			if (dead && !exists) return;
			else if (!onScreen()) kill();
			else super.update();
		}
	}
}