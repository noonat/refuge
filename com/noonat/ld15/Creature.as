package com.noonat.ld15 {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxText;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	public class Creature extends FlxSprite {
		[Embed(source="../../../data/creature_hit.mp3")] protected var SndHit:Class;
		[Embed(source="../../../data/creature_explode.mp3")] protected var SndExplode:Class;
		[Embed(source="../../../data/creature_shoot2.mp3")] protected var SndShoot:Class;
		
		public static var BASE_DOWN_SPEED:Number = 20;
		public static var _shape:Shape = new Shape();
		protected static const DEAD_TRANSFORM:ColorTransform = new ColorTransform(0.4, 0.6, 0.2, 1.0, 50, 50, 50);
		protected static const SCALE:int = 4;
		protected static const SCALED_MATRIX:Matrix = new Matrix(SCALE, 0, 0, SCALE);
		protected static const SCALED_RECT:Rectangle = new Rectangle(0, 0, SCALE*5, SCALE*5);
		protected static const STATE_SPAWNING:int = 0;
		protected static const STATE_DESCENDING:int = 1;
		protected static const STATE_ATTACKING:int = 2;
		
		public var chain:Object;
		public var dying:Boolean;
		protected var _attacking:Building;
		protected var _attackTime:Number;
		protected var _downMultiplier:Number;
		protected var _downSpeed:Number;
		protected var _explosion:CreatureExplosion;
		protected var _light:Light;
		protected var _lightBeam:Light;
		protected var _nextAttackTime:Number;
		protected var _pixelsAlive:BitmapData;
		protected var _pixelsDead:BitmapData;
		protected var _sndExplode:Sound;
		protected var _sndHit:Sound;
		protected var _sndShoot:Sound;
		protected var _spawnTime:Number;
		protected var _state:uint;
		protected var _text:FlxText;
		
		public function Creature(layer:FlxLayer, lightsLayer:FlxLayer) {
			super(null, 0, 0, false, false, SCALE*5, SCALE*5, 0x00000000);
			var brightness:Number = 0.3 + (0.7 * Math.random());
			_pixelsAlive = pixels = pixels.clone(); // cloned because flixel tries to share bitmaps
			CreatureBitmaps.drawNext(_pixelsAlive, SCALED_MATRIX);
			_pixelsAlive.colorTransform(SCALED_RECT, new ColorTransform(brightness, brightness, brightness));
			_pixelsDead = _pixelsAlive.clone();
			_pixelsDead.colorTransform(SCALED_RECT, DEAD_TRANSFORM);
			_explosion = new CreatureExplosion(brightness, layer);
			_light = lightsLayer.add(new Light(0, 0, 1, 0)) as Light;
			_lightBeam = lightsLayer.add(new Light(0, 0, 1, 0)) as Light;
			_sndExplode = new SndExplode();
			_sndHit = new SndHit();
			_sndShoot = new SndShoot();
			spawn();
		}
		
		override public function kill():void {
			if (dead || dying) return;
			FlxG.play(_sndHit);
			maxVelocity.y = 80;
			dying = true;
			_explode(0.6);
			_flash(40);
			pixels = _pixelsDead;
			alpha = alpha;
		}
		
		override public function hitFloor():Boolean {
			if (dying) {
				FlxG.play(_sndExplode, 0.3);
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
		
		override public function render():void {
			if (!dying && !dead && _attacking) {
				_shape.graphics.clear();
				_shape.graphics.lineStyle(3, 0xff006600, 0.5, true, LineScaleMode.NORMAL, CapsStyle.SQUARE);
				_shape.graphics.moveTo(x+width/2, y+height/2);
				_shape.graphics.lineTo(_attacking.x+_attacking.width/2, _attacking.y+_attacking.height/2);
				FlxG.buffer.draw(_shape);
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
				}
			})
		}
		
		override public function spawn():void {
			super.spawn();
			pixels = _pixelsAlive;
			alpha = 1.0;
			acceleration.y = 80;
			chain = null;
			dying = false
			maxVelocity.y = 5;
			velocity.x = Math.random() * 60 - 30;
			_downMultiplier = Math.random();
			_light.kill();
			_lightBeam.kill();
			_nextAttackTime = 0;
			_spawnTime = FlxG.time;
			_state = STATE_SPAWNING;
		}
		
		override public function update():void {
			_downSpeed = 5 + _downMultiplier * BASE_DOWN_SPEED;
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
								_flash(20, _attacking.x, _attacking.y, _lightBeam)
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
		
		internal function _explode(delay:Number=0.2):void {
			_explosion._delay = delay;
			_explosion.reset();
		}
		
		internal function _findNextTarget():void {
			var buildings:FlxArray = (FlxG.state as PlayState).buildingsLayer.buildings;
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
				FlxG.play(_sndShoot, 0.2);
				_attacking = target;
				_attackTime = FlxG.time + 1;
			}
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
	}
}
