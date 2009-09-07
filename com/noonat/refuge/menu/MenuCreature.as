package com.noonat.refuge.menu {
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.noonat.refuge.CreatureBitmaps;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class MenuCreature extends FlxSprite {
		protected var _baseY:Number;
		protected var _offset:Number;
		
		public function MenuCreature():void {
			var scale:uint = Math.random() < 0.7 ? 1 : 2;
			super(null, 0, 0, false, false, scale*5, scale*5, 0x00000000);
			pixels = pixels.clone(); // cloned because flixel tries to share bitmaps
			CreatureBitmaps.drawNext(pixels, new Matrix(scale, 0, 0, scale));
			pixels.colorTransform(new Rectangle(0, 0, scale*5, scale*5), new ColorTransform(0, 0, 0));
			if (scale === 1) alpha = 0.3 + Math.random()*0.7;
			else alpha = 1.0;
			spawn();
		}
		
		override public function spawn():void {
			super.spawn();
			maxVelocity.x = (5 + Math.random() * 10) * alpha;
			acceleration.x = 100;
			acceleration.y = 0;
			this.x = -width;
			this.y = _baseY = Math.random()*(FlxG.height-128);
			_offset = Math.random() * 1000;
		}
		
		override public function update():void {
			super.update();
			if (x > FlxG.width) x = -width
			y = _baseY + Math.sin(FlxG.time + _offset) * 4 * alpha;
			
			//maxVelocity.y = 5;// + _velocityScale * BASE_DOWN_SPEED;
			//if (y >= FlxG.height-256 && _velocityScale > 0) _velocityScale *= -1;
			//else if (y <= -32 && _velocityScale < 0) _velocityScale *= -1;
		}
	}
}
