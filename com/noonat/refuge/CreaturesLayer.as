package com.noonat.refuge {
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import flash.geom.Rectangle;
	
	public class CreaturesLayer extends FlxLayer {
		protected static const SPAWN_AREA:Rectangle = new Rectangle(6*32, -9*32, 3*32, 9*32);
		protected static const SPAWN_TIMERS:Array = [
			{score:50000, interval:0.5, baseDownSpeed:35},
			{score:30000, interval:0.6, baseDownSpeed:30},
			{score:20000, interval:0.7, baseDownSpeed:25},
			{score:10000, interval:0.8, baseDownSpeed:20},
			{score:5000,  interval:0.9, baseDownSpeed:20},
			{score:0,     interval:1.0, baseDownSpeed:20}];
		public var creatures:FlxArray;
		protected var _bullets:FlxArray;
		protected var _lightsLayer:FlxLayer;
		protected var _spawnTimer:Number = 1.0;
		
		function CreaturesLayer(lightsLayer:FlxLayer):void {
			creatures = new FlxArray();
			_lightsLayer = lightsLayer;
		}
		
		protected function _addCreature():Creature {
			var creature:Creature = creatures.getNonexist() as Creature;
			if (creature) creature.spawn();
			else creature = creatures.add(add(new Creature(this, _lightsLayer))) as Creature;
			creature.angle = Math.random() * 360;
			creature.x = SPAWN_AREA.x + Math.random() * (SPAWN_AREA.width - creature.width);
			creature.y = SPAWN_AREA.y + Math.random() * (SPAWN_AREA.height - creature.height);
			return creature;
		}
		
		protected function _onCreatureHitCreature(creature1:Creature, creature2:Creature):void {
			var dead:Creature, alive:Creature;
			if (creature1.dying) {
				if (creature2.dying) return; // both dead, don't do anything
				dead = creature1;
				alive = creature2;
			}
			else if (creature2.dying) {
				dead = creature2;
				alive = creature1;
			}
			else return; // both alive, don't do anything
			
			// one is dead and the other is alive, chain death to the alive one
			if (!dead.chain) dead.chain = {chainedCount: 1};
			alive.chain = dead.chain;
			alive.kill();
			++alive.chain.chainedCount;
			
			// give them some point for the chained kill
			(FlxG.state as PlayState).onEvent(
				PlayState.EVENT_KILL_CHAINED,
				{killed:alive, killer:dead});
		}
		
		override public function update():void {
			var state:PlayState = FlxG.state as PlayState;
			
			_spawnTimer -= FlxG.elapsed;
			if (_spawnTimer <= 0) { // time to spawn a new creature
				for (var i:int=0; i < SPAWN_TIMERS.length; ++i) {
					if (FlxG.score >= SPAWN_TIMERS[i].score) {
						_spawnTimer = SPAWN_TIMERS[i].interval;
						Creature.BASE_DOWN_SPEED = SPAWN_TIMERS[i].baseDownSpeed;
						break;
					}
				}
				_addCreature();
			}
			
			super.update();
			
			FlxG.collideArrays(state.blocksLayer.blocks, creatures);
			FlxG.overlapArrays(creatures, creatures, _onCreatureHitCreature);
		}
	}
}
