package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.*;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class PlayState extends FlxState {
		private const COLOR_WATER:uint = 0x33000066;
		private const CREATURE_TIMER:Number=1;
		private const SIZE_BLOCK:uint = 32;
		
		public var lights:LightLayer;
		
		public var buildings:FlxArray;
		public var gameOver:Boolean;
		private var _blocks:FlxArray;
		private var _creatures:FlxArray;
		private var _creatureTimer:Number=CREATURE_TIMER;
		private var _editor:Editor;
		private var _player:Player;
		private var _playerBullets:FlxArray;
		private var _scoreText:FlxText;
		
		function PlayState():void {
			super();
			
			lights = new LightLayer();
			
			_playerBullets = new FlxArray();
			_player = this.add(new Player(_playerBullets)) as Player;
			_player.angle = 270;
			_player.x = FlxG.width / 2 - _player.width / 2;
			_player.y = 495;
			
			var MOARBUILDINGS:Array = [
				[ 32, 481, 2],
				[ 48, 516, 3],
				[ 64, 516, 2],
				[ 80, 548, 3],
				[ 96, 548, 1],
				[112, 548, 2],
				[128, 552, 2],
				[144, 552, 3],
				[160, 532, 3],
				[176, 521, 3],
				[192, 516, 2],
				[208, 516, 2],
				[224, 508, 1],
				[240, 508, 1],
				[256, 508, 1],
				[272, 508, 2],
				[288, 508, 3],
				[304, 516, 3],
				[320, 524, 2],
				[336, 532, 2],
				[352, 532, 1],
				[368, 545, 2],
				[384, 545, 2],
				[400, 540, 3],
				[416, 524, 2],
				[432, 488, 1],
			];
			buildings = new FlxArray();
			for (i=0; i < MOARBUILDINGS.length; ++i) {
				var h:Number = MOARBUILDINGS[i][2] * 16;
				buildings.add(this.add(new Building(
					MOARBUILDINGS[i][0], MOARBUILDINGS[i][1] - h + 16,
					16, h)));
			}
			
			_blocks = new FlxArray();
			_blocks.add(this.add(newBlock( 0,-10, 6, 11)));
			_blocks.add(this.add(newBlock( 9,-10, 6, 11)));
			_blocks.add(this.add(newBlock( 0,  1, 4, 1)));
			_blocks.add(this.add(newBlock(-4,  1, 4, 1)));
			_blocks.add(this.add(newBlock( 0,  2, 3, 1)));
			_blocks.add(this.add(newBlock(-3,  2, 3, 1)));
			_blocks.add(this.add(newBlock( 0,  3, 2, 2)));
			_blocks.add(this.add(newBlock(-2,  3, 2, 2)));
			_blocks.add(this.add(newBlock( 0,  5, 1, 14)));
			_blocks.add(this.add(newBlock(-1,  5, 1, 14)));
			_blocks.add(this.add(newBlock( 0, 19, 15, 1)));
			var MOARBLOCKS:Array = [
				[32, 496, 16, 112],
				[48, 532, 32, 76],
				[80, 564, 48, 44],
				[128, 576, 32, 32],
				[160, 564, 16, 44],
				[176, 548, 16, 60],
				[192, 532, 32, 76],
				[224, 524, 80, 84],
				[304, 532, 16, 76],
				[320, 540, 16, 68],
				[336, 548, 32, 60],
				[368, 568, 32, 40],
				[400, 556, 32, 52],
				[416, 540, 32, 68],
				[432, 504, 16, 40],
				[176, 544, 16, 8],
				[176, 536, 16, 12],
				[160, 548, 16, 20],
				[128, 568, 32, 12],
				[352, 560, 48, 12],
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
			
			var lx:Array = [
				_player.x + _player.width / 2,
				FlxG.width - (FlxG.width / 4)];
			var ly:Number = _player.y - _player.height*2;
			var ls:Number = 100;
			var la:Number = 0.3;
			_creatures = new FlxArray();

			_scoreText = new FlxText(0, FlxG.height - 32, FlxG.width, 80, "Score:"+FlxG.score, 0xffffff, null, 16, "center");
			this.add(_scoreText);
		}
		
		public function newBlock(x:int, y:int, w:int, h:int, color:uint=0xff333333, alpha:Boolean=false):Block {
			if (x < 0) x += 15;
			return new Block(x*SIZE_BLOCK, y*SIZE_BLOCK, w*SIZE_BLOCK, h*SIZE_BLOCK, color, alpha);
		}
		
		public function newCreature():Creature {
			var creature:Creature = new Creature();
			creature.angle = Math.random() * 360;
			for (var j:uint=0; j < 5; ++j) {
				creature.x = 6*SIZE_BLOCK + Math.random() * (3*SIZE_BLOCK - creature.width);
				creature.y = -9*SIZE_BLOCK + Math.random() * 9*SIZE_BLOCK;//50 + 350 * Math.random();
			}
			_creatures.add(creature);
			this.add(creature);
			return creature;
		}
		
		override public function render():void {
			super.render();
			lights.render();
			_editor.render();
		}
		
		private const SCORE_CREATURE:int = 100;
		private const SCORE_MED_SHOT_MUL:int = 2;
		private const SCORE_LONG_SHOT_MUL:int = 4;
		private const SCORE_BOUNCE_MUL:int = 4;
		
		internal function _onCreatureHitBullet(creature:Creature, bullet:Bullet):void {
			if (!creature.dying) {
				var score:int = SCORE_CREATURE;
				var scoreText:Array = [];
				if (bullet.lifeTime > 4) {
					score *= SCORE_LONG_SHOT_MUL;
					scoreText.push('x'+SCORE_LONG_SHOT_MUL+' LONG SHOT');
				}
				else if (bullet.lifeTime > 2) {
					score *= SCORE_MED_SHOT_MUL;
					scoreText.push('x'+SCORE_MED_SHOT_MUL+' MED SHOT');
				}
				if (bullet.bounces > 0) {
					score *= SCORE_BOUNCE_MUL * bullet.bounces;
					scoreText.push(
						'x'+(SCORE_BOUNCE_MUL*bullet.bounces)+
						' '+bullet.bounces+
						' '+(bullet.bounces === 1 ? 'BOUNCE':'BOUNCES'));
				}
				scoreText.push(String(score)+' PTS');
				creature.setText(scoreText.join('\n'));
				FlxG.score += score;
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
		
		internal function _onCreatureHitBuilding(a:Creature, b:Building):void {
			if (a.dying) return;
			b.hurt(1);
		}
		
		internal function _onCreatureHitCreature(a:Creature, b:Creature):void {
			if (a.dying && b.dying) return;
			else if (a.dying) b.kill();
			else if (b.dying) a.kill();
		}
		
		override public function update():void {
			_creatureTimer -= FlxG.elapsed;
			if (_creatureTimer <= 0) {
				_creatureTimer = CREATURE_TIMER;
				newCreature();
			}
			var b:Bullet;
			
			// disable the bullets before the update
			for (var i:uint=0; i < _playerBullets.length; ++i) {
				if (_playerBullets[i]) _playerBullets[i].active = false;
			}
			
			// update the rest of the world
			super.update();
			//FlxG.collideArray(_blocks, _player);
			FlxG.collideArrays(_blocks, _creatures);
			FlxG.overlapArrays(_creatures, _creatures, _onCreatureHitCreature);
			FlxG.overlapArrays(_creatures, buildings, _onCreatureHitBuilding);
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
			
			if (!gameOver) {
				for (i=0; i < buildings.length; ++i) {
					if (!buildings[i].dead) break
				}
				if (i === buildings.length) {
					this.add(new FlxText(0, FlxG.height/2, FlxG.width, 80, "GAME OVER\nScore: "+FlxG.score, 0xffffff, null, 16, "center"));
					gameOver = true;
					Tweener.addTween(lights, {
						ALPHA:0xff, time:1,
						transition:'linear'
					});
				}
			}
			_scoreText.setText('Score: '+ FlxG.score);
		}
	}
}
