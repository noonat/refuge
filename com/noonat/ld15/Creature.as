package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.*;
	import flash.display.*;
	import flash.geom.*;
	
	public class Creature extends FlxSprite {
		private const STATE_SPAWNING:int = 0;
		private const STATE_DESCENDING:int = 1;
		private const STATE_ATTACKING:int = 2;
		
		public var chain:Object = null;
		public var dying:Boolean = false;
		private var _explosionSprites:FlxArray = new FlxArray();
		private var _explosion:FlxEmitter;
		private var _light:Light;
		private var _attackLight:Light;
		private var _downMultiplier:Number;
		private var _downSpeed:Number;
		private var _b:uint, _argb:uint;
		private var _state:uint = STATE_SPAWNING;
		private var _spawnTime:Number;
		
		private var _attacking:Building;
		private var _attackTime:Number;
		private var _nextAttackTime:Number=0;
		private var _text:FlxText;
		
		public static var _baseDownSpeed:Number = 20;
		
		public function Creature() {
			super(null, 0, 0, false, false, 20, 20, 0x00000000);
			pixels = pixels.clone();
			spawn();
			
			alpha = 1.0;
			acceleration.y = 80;
			maxVelocity.y = 5;
			velocity.x = Math.random() * 60 - 30;
			
			_downMultiplier = Math.random();
			
			var g:Number=0xff669933;
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,6,6,g));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,3,3,_argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,_argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,4,4,_argb));
			_explosionSprites.add(new FlxSprite(null,0,0,false,false,6,6,_argb));
			for (var i:uint=0; i < _explosionSprites.length; ++i) FlxG.state.add(_explosionSprites[i]);
			_explosion = FlxG.state.add(new FlxEmitter(
				0, 0, // x, y
				width/2, height/2, // w, h
				_explosionSprites, // sprites
				0.2, // delay
				-10, 10, // min vx, max vx
				0, 50, // min vy, max vy
				-720, 720, // min max rot
				20, // gravity,
				0, // drag
				null, 0, false // sheet, quantity, multiple
			)) as FlxEmitter;
			_explosion.kill();
			
			_light = new Light(0, 0, 1, 0);
			_light.kill();
			(FlxG.state as PlayState).lights.add(_light);
			
			_attackLight = new Light(0, 0, 1, 0);
			_attackLight.kill();
			(FlxG.state as PlayState).lights.add(_attackLight);
			
			_spawnTime = FlxG.time;
		}
		
		internal function _explode(delay:Number=0.2):void {
			_explosion._delay = delay;
			_explosion.reset();
		}
		
		internal function _flash(radius:Number, X:Number=0, Y:Number=0, light:Light=null):void {
			if (!light) light = _light;
			light.spawn();
			light.xy(X||x, Y||y);
			light.scale = radius;
			Tweener.addTween(light, {
				scale:1, time:2,
				transition: 'linear',
				onComplete: function():void {
					light.kill();
				}
			});
		}
		
		override public function kill():void {
			if (dead || dying) return;
			maxVelocity.y = 80;
			dying = true;
			_explode(0.6);
			_flash(40);
			pixels.colorTransform(_r, _ct);
			alpha = alpha;
		}
		
		override public function hitFloor():Boolean {
			if (dying) {
				super.kill();
				_explode(-1.5);
				_flash(60);
			}
			return true;
		}
		
		override public function hitWall(movingRight:Boolean):Boolean {
			velocity.x *= -1;
			return true;
		}
		
		public function redraw():void {
			// draw the 5x5 sprite
			var i:uint = _next++;
			if (_next >= _bits.length) _next = 0;
			_pxls.fillRect(_pxlsr, 0x00000000);
			_b = 75 + Math.floor(Math.random() * (255 - 75));
			_argb = 0xff000000 | (_b << 16) | (_b << 8) | _b;
			for (var y:uint=0; y < 5; ++y) {
				for (var x:uint=0; x < 5; ++x) {
					if (_bits[i][y][x]) _pxls.setPixel32(x, y, _argb);
				}
			}
			
			// blit it into the bigger one
			pixels.draw(_pxls, _pxlsm);
		}
		
		override public function render():void {
			if (!dying && !dead && _attacking) {
				_sh.graphics.clear();
				_sh.graphics.lineStyle(3, 0xff006600, 0.5, true, LineScaleMode.NORMAL, CapsStyle.SQUARE);
				_sh.graphics.moveTo(x+width/2, y+height/2);
				_sh.graphics.lineTo(_attacking.x+_attacking.width/2, _attacking.y+_attacking.height/2);
				FlxG.buffer.draw(_sh);
			}
			super.render();
		}
		
		public function setText(text:String):void {
			var ty:Number = y - text.split('\n').length * 10;
			if (!_text) {
				_text = new FlxText(x, ty, 300, 80, text, 0xffffffff, null, 6, 'left', 0);
				FlxG.state.add(_text);
			}
			else {
				_text.setText(text);
				_text.x = x;
				_text.y = ty;
			}
			_text.visible = true;
			Tweener.removeTweens(_text);
			Tweener.addTween(_text, {
				y:_text.y-20, time:1.0, transition:'linear',
				onComplete: function():void {
					_text.visible = false;
					/*Tweener.addTween(_text, {
						y:_text.y+FlxG.height, time:0.2, transition:'linear',
						onComplete: function():void {
							_text.visible = false;
						}
					});*/
				}
			})
		}
		
		override public function spawn():void {
			super.spawn();
			redraw();
		}
		
		override public function update():void {
			_downSpeed = 5 + _downMultiplier * _baseDownSpeed;
			_explosion.x = x;
			_explosion.y = y;
			if (dying) maxVelocity.y = 80;
			else if (_state === STATE_SPAWNING) maxVelocity.y = _downSpeed + Math.min(((64-y)/64)*(80-_downSpeed), (80-_downSpeed));
			else if (_state === STATE_DESCENDING) maxVelocity.y = _downSpeed;
			else if (_state === STATE_ATTACKING) maxVelocity.y = 0;
			super.update();
			if (!dying) {
				switch (_state) {
					case STATE_SPAWNING:
						if (y > 64) _state = STATE_DESCENDING;
						break;
					case STATE_DESCENDING:
						if (y > 460) _state = STATE_ATTACKING;
						break;
					case STATE_ATTACKING:
						y = y + Math.sin(FlxG.time - _spawnTime) * 0.1;
						if (_attacking) {
							if (FlxG.time > _attackTime) {
								_flash(20, _attacking.x, _attacking.y, _attackLight)
								_attacking.hurt(1);
								_attacking = null;
								_attackTime = 0;
								_nextAttackTime = FlxG.time + 2;
							}
						}
						else if (FlxG.time > _nextAttackTime) {
							_findNextTarget();
						}
						break;
				}
			}
			if (_light.exists && (_light.x != x || _light.y != y))
				_light.xy(x+width/2, y+height/2);
		}
		
		internal function _findNextTarget():void {
			var buildings:FlxArray = (FlxG.state as PlayState).buildings;
			var delta:Number, deltaX:Number, deltaY:Number;
			var target:Building, targetDelta:Number;
			for (var i:uint=0; i < buildings.length; ++i) {
				var building:Building = buildings[i];
				if (building.dead) continue;
				deltaX = (x + width/2) - (building.x + building.width/2);
				deltaY = (y + height/2) - (building.y + building.height/2);
				delta = deltaX*deltaX + deltaY*deltaY;
				if (delta < 100*100 && (!target || delta < targetDelta)) {
					target = building;
					targetDelta = delta;
				}
			}
			if (target) {
				_attacking = target;
				_attackTime = FlxG.time + 1;
			}
		}

		private static var _bits:Array = [
			[[1,1,1,1,1],
			 [1,1,1,1,1],
			 [1,1,0,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [1,1,0,1,1],
			 [0,1,1,1,0],
			 [0,1,0,1,0],
			 [1,0,0,0,1]],
			
			[[0,0,1,0,0],
			 [1,1,0,1,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,0,0,0,0]],
			
			[[1,1,1,1,1],
			 [1,0,1,0,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0],
			 [0,1,0,1,0]],
			
			[[0,0,1,0,0],
			 [0,1,1,1,0],
			 [1,0,1,0,1],
			 [1,1,1,1,1],
			 [0,1,0,1,0]],
			
			[[0,1,1,1,0],
			 [0,1,0,1,0],
			 [0,1,1,1,0],
			 [1,1,1,1,1],
			 [1,0,1,0,1]],

			/*
			[[],
			 [],
			 [],
			 [],
			 []],
			
			*/
		];
		private static var _next:uint=0;
		private static var _pxls:BitmapData = new BitmapData(5, 5, true, 0x00000000);
		private static var _pxlsm:Matrix = new Matrix(4, 0, 0, 4);
		private static var _pxlsr:Rectangle = new Rectangle(0, 0, 5, 5);
		private static var _r:Rectangle = new Rectangle(0, 0, 20, 20);
		private static var _ct:ColorTransform = new ColorTransform(0.4, 0.6, 0.2, 1.0, 50, 50, 50);
		private static var _sh:Shape = new Shape();
	}
}
