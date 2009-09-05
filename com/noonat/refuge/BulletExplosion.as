package com.noonat.refuge {
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxSprite;
	
	public class BulletExplosion extends FlxEmitter {
		protected var _sprites:FlxArray;
		
		function BulletExplosion(layer:FlxLayer):void {
			_sprites = new FlxArray();
			var sizes:Array = [1, 1, 2, 2, 3, 3];
			for (var i:int=0; i < sizes.length; ++i) {
				_sprites.add(new FlxSprite(null, 0, 0, false, false, sizes[i], sizes[i], Bullet.COLOR));
				layer.add(_sprites[i]);
			}
			super(
				0, 0, // x, y
				Bullet.SIZE*2, Bullet.SIZE*2, // w, h
				_sprites, // sprites
				-1.5, // delay
				-20, 20, // min vx, max vx
				-100, 0, // min vy, max vy
				-720, 720, // min max rot
				400, // gravity,
				0, // drag
				null, 0, false // sheet, quantity, multiple
			);
			layer.add(this);
		}
	}
}