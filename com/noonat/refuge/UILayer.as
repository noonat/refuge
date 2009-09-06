package com.noonat.refuge {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxButton;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxText;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	public class UILayer extends FlxLayer {
		protected var _gameOverLight:Light;
		protected var _gameOverText:FlxText;
		protected var _scoreText:FlxText;
		protected var _submitScoreButton:FlxButton;
		protected var _tryAgainButton:FlxButton;
		
		function UILayer(lightsLayer:FlxLayer):void {
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(300, 300, 0, -150, -150);
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(GradientType.RADIAL,
				[0x000000, 0x0000ff], [1.0, 1.0], [100, 255], matrix);
			shape.graphics.drawCircle(0, 0, 200);
			shape.graphics.endFill();
			_gameOverLight = new Light(FlxG.width/2, FlxG.height/2+0, 1.0, 1.0, 0, shape);
			_gameOverLight.kill();
			lightsLayer.add(_gameOverLight);
			
			var y:int = FlxG.height / 2 - 80;
			_gameOverText = new FlxText(0, y, FlxG.width, 96, "GAME OVER\nScore: "+FlxG.score, 0xffffff, null, 32, "center");
			_gameOverText.alpha = 0.0;
			_gameOverText.visible = false;
			add(_gameOverText);
			
			y += 96;
			_submitScoreButton = new FlxButton(FlxG.width/2-144/2, y,
				new FlxSprite(null, 0, 0, false, false, 144, 28, 0x99000000),
				function():void { Mochi.submitToLeaderboard(); },
				new FlxSprite(null, 0, 0, false, false, 144, 28, 0x99ffffff),
				new FlxText(0, 3, 144, 24, 'Submit Score', 0xffffff, null, 16, 'center'),
				new FlxText(0, 3, 144, 24, 'Submit Score', 0x000000, null, 16, 'center'));
			_submitScoreButton.alpha = 0.0;
			_submitScoreButton.visible = false;
			add(_submitScoreButton);
			
			y += 40;
			_tryAgainButton = new FlxButton(FlxG.width/2-144/2, y,
				new FlxSprite(null, 0, 0, false, false, 144, 28, 0x99000000),
				function():void {
					FlxG.score = 0;
					FlxG.switchState(PlayState);
				},
				new FlxSprite(null, 0, 0, false, false, 144, 28, 0x99ffffff),
				new FlxText(0, 3, 144, 24, 'Try Again', 0xffffff, null, 16, 'center'),
				new FlxText(0, 3, 144, 24, 'Try Again', 0x000000, null, 16, 'center'));
			_tryAgainButton.alpha = 0.0;
			_tryAgainButton.visible = false;
			add(_tryAgainButton);
			
			_scoreText = new FlxText(0, FlxG.height - 32, FlxG.width, 80, "Score: "+FlxG.score, 0xffffff, null, 16, "center");
			add(_scoreText);
		}
		
		public function onGameOver():void {
			_gameOverLight.spawn();
			_gameOverLight.alpha = 0.0;
			Tweener.addTween(_gameOverLight, {alpha:1, time:5, transition:'linear'});
			_gameOverText.visible = true;
			_gameOverText.setText("GAME OVER\nScore: "+FlxG.score);
			Tweener.addTween(_gameOverText, {
				alpha:1, time:5, transition:'linear',
				onComplete: function():void {
					_submitScoreButton.visible = _tryAgainButton.visible = true;
					Tweener.addTween(_submitScoreButton, {alpha:1.0, time:2, transition:'linear'});
					Tweener.addTween(_tryAgainButton, {alpha:1.0, time:2, transition:'linear'});
				}
			});
			_scoreText.visible = false;
		}
		
		override public function update():void {
			super.update();
			_scoreText.setText('Score: '+ FlxG.score);
		}
	}
}