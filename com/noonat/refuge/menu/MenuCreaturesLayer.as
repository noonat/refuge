package com.noonat.refuge.menu {
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	
	public class MenuCreaturesLayer extends FlxLayer {
		public function MenuCreaturesLayer():void {
			for (var i:int=0; i < 500; ++i) {
				var creature:MenuCreature = new MenuCreature();
				creature.x = Math.floor(Math.random() * FlxG.width);
				add(creature);
			}
		}
	}
}