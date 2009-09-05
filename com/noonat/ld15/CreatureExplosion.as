package com.noonat.ld15 {
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxSprite;
	
	public class CreatureExplosion extends FlxEmitter {
		public static const COLOR:uint = 0xff669933;
		protected var _sprites:FlxArray;
		
		function CreatureExplosion(brightness:Number, layer:FlxLayer):void {
			var b:uint = Math.floor(255 * brightness);
			var argb:uint = 0xff000000 | (b << 16) | (b << 8) | b;
			_sprites = new FlxArray();
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 3, 3, COLOR));
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 3, 3, COLOR));
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 4, 4, COLOR));
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 6, 6, COLOR));
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 3, 3, argb));
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 4, 4, argb));
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 4, 4, argb));
			_sprites.add(new FlxSprite(null, 0, 0, false, false, 6, 6, argb));
			for (var i:uint=0; i < _sprites.length; ++i) layer.add(_sprites[i]);
			super(
				0, 0,              // x, y
				width/2, height/2, // w, h
				_sprites,          // sprites
				0.2,               // delay
				-10, 10,           // min vx, max vx
				0, 50,             // min vy, max vy
				-720, 720,         // min max rot
				20,                // gravity,
				0,                 // drag
				null, 0, false     // sheet, quantity, multiple
			);
			layer.add(this);
			kill();
		}
	}
}