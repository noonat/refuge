package com.noonat.ld15 {
	import com.adamatomic.flixel.*;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class PlayState extends FlxState {
		private const COLOR_WATER:uint = 0x33000066;
		private const SIZE_BLOCK:uint = 32;
		
		public var lights:LightLayer;
		
		private var _blocks:FlxArray;
		private var _player:Player;
		private var _playerBullets:FlxArray;
		private var _water:BitmapData;
		private var _waterRect:Rectangle;
		private var _waterPoint:Point = new Point(0, 0);
		
		function PlayState():void {
			super();
			
			lights = new LightLayer();
			
			_blocks = new FlxArray();
			_blocks.add(this.add(newBlock( 0,  0, 6, 1)));
			_blocks.add(this.add(newBlock( 9,  0, 6, 1)));
			_blocks.add(this.add(newBlock( 0,  1, 4, 1)));
			_blocks.add(this.add(newBlock(-4,  1, 4, 1)));
			_blocks.add(this.add(newBlock( 0,  2, 3, 1)));
			_blocks.add(this.add(newBlock(-3,  2, 3, 1)));
			_blocks.add(this.add(newBlock( 0,  3, 2, 2)));
			_blocks.add(this.add(newBlock(-2,  3, 2, 2)));
			_blocks.add(this.add(newBlock( 0,  5, 1, 13)));
			_blocks.add(this.add(newBlock(-1,  5, 1, 13)));
			_blocks.add(this.add(newBlock( 0, 18, 2, 1)));
			_blocks.add(this.add(newBlock(-2, 18, 2, 1)));
			_blocks.add(this.add(newBlock( 0, 19, 20, 1)));
			
			_playerBullets = new FlxArray();
			_player = this.add(new Player(_playerBullets)) as Player;
			_player.x = _player.y = 100;
			
			_water = new BitmapData(FlxG.width, FlxG.height);
			_waterRect = new Rectangle(0, 0, _water.width, _water.height);
			_water.fillRect(_waterRect, COLOR_WATER);
		}
		
		public function newBlock(x:int, y:int, w:int, h:int, color:uint=0xff333333, alpha:Boolean=false):Block {
			if (x < 0) x += 15;
			if (y < 0) y += 20;
			return new Block(x*SIZE_BLOCK, y*SIZE_BLOCK, w*SIZE_BLOCK, h*SIZE_BLOCK, color, alpha);
		}
		
		override public function render():void {
			super.render();
			lights.render();
			//FlxG.buffer.copyPixels(_water, _waterRect, _waterPoint, null, null, true);
		}
		
		override public function update():void {
			super.update();
			FlxG.collideArray(_blocks, _player);
			FlxG.collideArrays(_blocks, _playerBullets);
			_player.postCollide();
			lights.update();
		}
	}
}
