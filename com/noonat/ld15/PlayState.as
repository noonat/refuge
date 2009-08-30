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
		private var _creatures:FlxArray;
		private var _editor:Editor;
		private var _player:Player;
		private var _playerBullets:FlxArray;
		
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
			_blocks.add(this.add(newBlock( 0, 19, 15, 1)));
			
			var MOARBLOCKS:Array = [
				[163, 538, 186, 73],
				[341, 569, 62, 45],
				[393, 562, 46, 47],
				[422, 542, 50, 51],
				[115, 586, 69, 40],
				[39, 562, 97, 61],
				[17, 530, 51, 64],
				[24, 495, 19, 42],
				[152, 580, 22, 19],
				[157, 568, 10, 19],
				[344, 554, 22, 21],
				[363, 565, 19, 8],
				[438, 502, 16, 49],
				[176, 532, 53, 21],
				[221, 532, 119, 24],
				[213, 519, 84, 29],
				[291, 529, 31, 12],
				[398, 91, 26, 33],
				[440, 157, 18, 49],
				[71, 59, 49, 22],
				[51, 94, 27, 29],
				[26, 152, 24, 59],
				[304, 30, 33, 14],
				[366, 53, 24, 18],
				[123, 22, 24, 22],
			];
			for (var i:uint=0; i < MOARBLOCKS.length; ++i) {
				var b:Array = MOARBLOCKS[i];
				_blocks.add(this.add(new Block(b[0], b[1], b[2], b[3], 0xff333333)));
			}
			
			_editor = new Editor();
			
			_playerBullets = new FlxArray();
			_player = this.add(new Player(_playerBullets)) as Player;
			_player.angle = 270;
			_player.x = FlxG.width / 2 - _player.width / 2;
			_player.y = 503;
			
			_creatures = new FlxArray();
			var creature:Creature;
			for (i=0; i < 50; ++i) {
				creature = new Creature();
				creature.angle = Math.random() * 360;
				for (var j:uint=0; j < 5; ++j) {
					creature.y = 50 + 350 * Math.random();
					if (creature.y < 100) creature.x = 130 + Math.random() * 200;
					else if (creature.y < 170) creature.x = 90 + Math.random() * 300;
					else creature.x = 60 + 370 * Math.random();
					for (var k:uint=0; k < _creatures.length; ++k) {
						if (creature.overlaps(_creatures[k])) break;
					}
					if (k == _creatures.length) break;
				}
				_creatures.add(creature);
				this.add(creature);
			}
		}
		
		public function newBlock(x:int, y:int, w:int, h:int, color:uint=0xff333333, alpha:Boolean=false):Block {
			if (x < 0) x += 15;
			if (y < 0) y += 20;
			return new Block(x*SIZE_BLOCK, y*SIZE_BLOCK, w*SIZE_BLOCK, h*SIZE_BLOCK, color, alpha);
		}
		
		override public function render():void {
			super.render();
			lights.render();
			_editor.render();
		}
		
		internal function _onCreatureHitBullet(creature:Creature, bullet:Bullet):void {
			creature.kill();
		}
		
		override public function update():void {
			var b:Bullet;
			
			// disable the bullets before the update
			for (var i:uint=0; i < _playerBullets.length; ++i) {
				if (_playerBullets[i]) _playerBullets[i].active = false;
			}
			
			// update the rest of the world
			super.update();
			FlxG.collideArray(_blocks, _player);
			_player.postCollide();
			
			// enable bullets again
			for (i=0; i < _playerBullets.length; ++i) {
				if (_playerBullets[i]) _playerBullets[i].active = true;
			}
			// tick over the bullets a couple times
			// we have to tick these manually because of collision issues
			for (var j:uint=0; j < 16; ++j) {
				for (i=0; i < _playerBullets.length; ++i) {
					b = _playerBullets[i];
					if (b && b.exists && b.active) b.update();
				}
				FlxG.collideArrays(_blocks, _playerBullets);
				FlxG.overlapArrays(_creatures, _playerBullets, _onCreatureHitBullet);
			}
			
			lights.update();
			_editor.update();
		}
	}
}
