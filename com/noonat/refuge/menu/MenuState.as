package com.noonat.refuge.menu {
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxState;
	import com.noonat.refuge.Block;
	import flash.filters.BlurFilter;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MenuState extends FlxState {
		[Embed(source="../../../../data/cityscape_left.png")] public static var ImgCityscapeLeft:Class;
		[Embed(source="../../../../data/cityscape_right.png")] public static var ImgCityscapeRight:Class;
		
		protected var _blocks:FlxArray;
		protected var _greenGradient:Shape;
		protected var _smokeLayer:SmokeLayer;
		protected var _creaturesLayer:MenuCreaturesLayer;
		
		function MenuState():void {
			var matrix:Matrix = new Matrix();
			super();
			
			matrix.createGradientBox(FlxG.width, FlxG.height, 90*(Math.PI/180), 0, 0);
			_greenGradient = new Shape();
			_greenGradient.graphics.beginGradientFill(GradientType.LINEAR,
				[0x669933, 0x000000], [0.0, 0.5], [0, 255], matrix);
			_greenGradient.graphics.drawRect(0, 0, FlxG.width, FlxG.height);
			_greenGradient.graphics.endFill();
			_greenGradient.cacheAsBitmap = true;
			
			// smoke
			_smokeLayer = add(new SmokeLayer()) as SmokeLayer;
			
			// creatures
			_creaturesLayer = add(new MenuCreaturesLayer()) as MenuCreaturesLayer;
			
			// buildings
			add(new FlxSprite(ImgCityscapeLeft, 0, FlxG.height-256, false, false));
			add(new FlxSprite(ImgCityscapeRight, FlxG.width-200, FlxG.height-256, false, false));
			
			// caverns
			_blocks = new FlxArray();
			_blocks.add(add(new Block(0, FlxG.height-128, 216, 128, 0xff000000)) as Block);
			_blocks.add(add(new Block(216, FlxG.height-96, 8, 96, 0xff000000)) as Block);
			_blocks.add(add(new Block(FlxG.width-200-16, FlxG.height-64, 8, 64, 0xff000000)) as Block);
			_blocks.add(add(new Block(FlxG.width-200-8, FlxG.height-120, 200, 120, 0xff000000)) as Block);
			_blocks.add(add(new Block(FlxG.width-200, FlxG.height-128, 200, 128, 0xff000000)) as Block);
		}
		
		override public function render():void {
			FlxG.buffer.draw(_greenGradient);
			super.render();
		}
	}
}
