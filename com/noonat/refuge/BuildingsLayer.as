package com.noonat.refuge {
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxLayer;
	
	public class BuildingsLayer extends FlxLayer {
		public var buildings:FlxArray;
		
		function BuildingsLayer():void {
			buildings = new FlxArray();
			_addBuildings([
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
			]);
		}
		
		protected function _addBuildings(values:Array):void {
			for (var i:int=0; i < values.length; ++i) {
				var b:Array = values[i];
				var height:uint = b[2] * 16;
				buildings.add(add(new Building(b[0], b[1] - height + 16, 16, height)));
			}
		}
		
		public function buildingsAreAllDead():Boolean {
			for (var i:int=0; i < buildings.length; ++i) {
				if (!buildings[i].dead) return false;
			}
			return true;
		}
	}
}