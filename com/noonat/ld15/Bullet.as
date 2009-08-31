package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.*;
	
	public class Bullet extends FlxSprite {
		[Embed(source="../../../data/bullet_explode.mp3")] private var SndExplode:Class;
		[Embed(source="../../../data/bullet_shoot.mp3")] private var SndShoot:Class;
		
		public const COLOR:uint = 0xffffff00;
		public const ELASTICITY:Number = 0.4;
		public const GRAVITY:Number = 120;
		public const SPEED:Number = 25;
		public const SIZE:uint = 6;
		public var bounces:int = 0;
		private var _explosion:FlxEmitter;
		private var _explosionSprites:FlxArray;
		private var _life:int;
		private var _light:Light;
		private var _spawnTime:Number;
		
		public function Bullet():void {
			super(null, 0, 0, false, false, SIZE, SIZE, COLOR);
			acceleration.y = 0.5;
			dead = true;
			exists = false;
			finished = false;
			_explosionSprites = new FlxArray();
			var sizes:Array = [1, 1, 2, 2, 3, 3];
			for (var i:int=0; i < sizes.length; ++i) {
				_explosionSprites.add(FlxG.state.add(new FlxSprite(
					null, 0, 0, false, false, sizes[i], sizes[i], COLOR
				)) as FlxSprite);
			}
			_explosion = FlxG.state.add(new FlxEmitter(
				0, 0, // x, y
				SIZE*2, SIZE*2, // w, h
				_explosionSprites, // sprites
				-1.5, // delay
				-20, 20, // min vx, max vx
				-100, 0, // min vy, max vy
				-720, 720, // min max rot
				400, // gravity,
				0, // drag
				null, 0, false // sheet, quantity, multiple
			)) as FlxEmitter;
			_light = new Light(0, 0, SIZE*4, 0);
			_light.kill();
			(FlxG.state as PlayState).lights.add(_light);
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
		
		override public function hurt(damage:Number):void {
			if (dead) return;
			FlxG.play(SndExplode, 0.7);
			if (--_life > 0) return;
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
				scale:1, time:1,
				transition:'linear',
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
		
		public function shoot(x:Number, y:Number, nx:Number, ny:Number):void {
			FlxG.play(SndShoot, 0.2);
			spawn();
			this.bounces = 0;
			this.x = x;
			this.y = y;
			velocity.x = nx * SPEED;
			velocity.y = ny * SPEED;
			_life = 2;
			_light.scale = SIZE*4;
			_light.xy(this.x, this.y);
			_spawnTime = FlxG.time;
		}
		
		override public function spawn():void { super.spawn(); _light.spawn(); }
		
		override public function update():void {
			_light.xy(this.x+this.width/2, this.y+this.height/2);
			if (dead && !exists) return;
			else if (!onScreen()) kill();
			else super.update();
		}
	}
}