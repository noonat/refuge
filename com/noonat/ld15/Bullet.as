package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	
	public class Bullet extends FlxSprite {
		public const COLOR:uint = 0xffffff00;
		public const ELASTICITY:Number = 0.4;
		public const GRAVITY:Number = 120;
		public const SPEED:Number = 120;
		public const SIZE:uint = 6;
		private var _explosion:FlxEmitter;
		private var _explosionSprites:FlxArray;
		private var _life:int;
		private var _light:Light;
		
		public function Bullet():void {
			super(null, 0, 0, false, false, SIZE, SIZE, COLOR);
			acceleration.y = 120;
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
			(FlxG.state as PlayState).lights.add(_light);
		}
		
		override public function hitWall(movingRight:Boolean):Boolean {
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
			if (--_life > 0) return;
			kill();
			velocity.x = 0;
			velocity.y = 0;
			_explosion.x = x + width / 2;
			_explosion.y = y + height / 2;
			_explosion.reset();
		}
		
		override public function kill():void { super.kill(); _light.fadeOut(); }
		
		public function shoot(x:Number, y:Number, nx:Number, ny:Number):void {
			spawn();
			this.x = x;
			this.y = y;
			velocity.x = nx * SPEED;
			velocity.y = ny * SPEED;
			_life = 1;
			_light.xy(this.x, this.y);
		}
		
		override public function spawn():void { super.spawn(); _light.spawn(); }
		
		override public function update():void {
			_light.xy(this.x+this.width/2, this.y+this.height/2);
			if (dead && !exists) return;
			else super.update();
		}
	}
}