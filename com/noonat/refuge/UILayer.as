package com.noonat.refuge {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxText;
	import flash.display.GradientType;
	import flash.display.Shape;
	
	public class UILayer extends FlxLayer {
		protected var _gameOverLight:Light;
		protected var _gameOverText:FlxText;
		protected var _scoreText:FlxText;
		
		function UILayer(lightsLayer:FlxLayer):void {
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.RADIAL,
				[0x000000, 0x000000], [0.7, 0.0], [0, 200]);
			shape.graphics.drawCircle(0, 0, 100);
			shape.graphics.endFill();
			_gameOverLight = new Light(FlxG.width/2, FlxG.height/2+35, 1.0, 1.0, 0, shape);
			_gameOverLight.kill();
			lightsLayer.add(_gameOverLight);
			
			_gameOverText = new FlxText(0, FlxG.height/2, FlxG.width, 80, "GAME OVER\nScore: "+FlxG.score, 0xffffff, null, 16, "center");
			_gameOverText.alpha = 0.0;
			_gameOverText.visible = false;
			add(_gameOverText);
			
			_scoreText = new FlxText(0, FlxG.height - 32, FlxG.width, 80, "Score:"+FlxG.score, 0xffffff, null, 16, "center");
			add(_scoreText);
		}
		
		public function onGameOver():void {
			_gameOverLight.spawn();
			_gameOverLight.alpha = 0.0;
			Tweener.addTween(_gameOverLight, {alpha:1, time:5, transition:'linear'});
			_gameOverText.visible = true;
			_gameOverText.setText("GAME OVER\nScore: "+FlxG.score);
			Tweener.addTween(_gameOverText, {alpha:1, time:5, transition:'linear'});
			_scoreText.visible = false;
		}
		
		override public function update():void {
			super.update();
			_scoreText.setText('Score: '+ FlxG.score);
		}
	}
}