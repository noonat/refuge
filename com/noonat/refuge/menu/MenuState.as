package com.noonat.refuge.menu {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxButton;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	import com.noonat.refuge.Block;
	import com.noonat.refuge.PlayState;
	import flash.geom.Rectangle;
	
	public class MenuState extends FlxState {
		[Embed(source="../../../../data/cityscape_left.png")] public static var ImgCityscapeLeft:Class;
		[Embed(source="../../../../data/cityscape_right.png")] public static var ImgCityscapeRight:Class;
		
		protected var _blocks:FlxArray;
		protected var _smokeLayer:SmokeLayer;
		protected var _creaturesLayer:MenuCreaturesLayer;
		
		function MenuState():void {
			super();
			_smokeLayer = add(new SmokeLayer()) as SmokeLayer;
			_creaturesLayer = add(new MenuCreaturesLayer()) as MenuCreaturesLayer;
			
			// buildings
			add(new FlxSprite(ImgCityscapeLeft, 0, FlxG.height-256, false, false));
			add(new FlxSprite(ImgCityscapeRight, FlxG.width-200, FlxG.height-256, false, false));
			
			// caverns
			_blocks = new FlxArray();
			_blocks.add(add(new Block(0, FlxG.height-128, 216, 384, 0xff000000)) as Block);
			_blocks.add(add(new Block(216, FlxG.height-96, 8, 384, 0xff000000)) as Block);
			_blocks.add(add(new Block(FlxG.width-200-16, FlxG.height-64, 8, 384, 0xff000000)) as Block);
			_blocks.add(add(new Block(FlxG.width-200-8, FlxG.height-120, 200, 384, 0xff000000)) as Block);
			_blocks.add(add(new Block(FlxG.width-200, FlxG.height-128, 200, 384, 0xff000000)) as Block);
			
			// title
			var titleText:FlxText = new FlxText(0, 64, FlxG.width, 96, 'REFUGE', 0x000000, null, 96, "center");
			var startButton:FlxButton = new FlxButton(
				FlxG.width/2 - 144/2, FlxG.height - 256,
				new FlxSprite(null, 0, 0, false, false, 144, 32, 0xff000000),
				function():void {
					Tweener.addTween(FlxG.scroll, {
						y:-640, time:1, transition:'easeInQuad',
						onComplete: function():void { FlxG.switchState(PlayState); }
					});
				},
				new FlxSprite(null, 0, 0, false, false, 144, 32, 0xff000000),
				new FlxText(0, 5, 144, 24, 'Click to Play', 0x15190f, null, 16, 'center'),
				new FlxText(0, 5, 144, 24, 'Click to Play', 0xffffff, null, 16, 'center')
			);
			startButton.alpha = 0.0;
			Tweener.addTween(startButton, {alpha:1, delay:3, time:0.2, transition:'linear'});
			add(titleText);
			add(startButton);
		}
		
		override public function render():void {
			FlxG.buffer.fillRect(new Rectangle(0, 0, FlxG.width, FlxG.height), 0xff000000)
			super.render();
		}
	}
}
