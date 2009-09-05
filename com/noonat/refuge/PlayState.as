package com.noonat.refuge {
	import caurina.transitions.Tweener;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxLayer;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class PlayState extends FlxState {
		public var blocksLayer:BlocksLayer;
		public var buildingsLayer:BuildingsLayer;
		public var creaturesLayer:CreaturesLayer;
		public var gameOver:Boolean = false;
		public var lightsLayer:LightsLayer;
		public var player:Player;
		public var playerLayer:FlxLayer;
		protected var _editor:Editor;
		protected var _scoreText:FlxText;
		
		function PlayState():void {
			super();
			
			lightsLayer = new LightsLayer();
			blocksLayer = new BlocksLayer();
			buildingsLayer = new BuildingsLayer();
			creaturesLayer = new CreaturesLayer(lightsLayer);
			playerLayer = new FlxLayer();
			
			player = new Player(playerLayer, lightsLayer);
			player.angle = 270;
			player.x = FlxG.width / 2 - player.width / 2;
			player.y = 495;
			playerLayer.add(player);
			
			add(creaturesLayer);
			add(playerLayer);
			add(buildingsLayer);
			add(blocksLayer);
			add(lightsLayer);
			
			_scoreText = new FlxText(0, FlxG.height - 32, FlxG.width, 80, "Score:"+FlxG.score, 0xffffff, null, 16, "center");
			add(_scoreText);
		}
		
		public static const EVENT_KILL:String = 'kill';
		public static const EVENT_KILL_CHAINED:String = 'kill_chained';
		public static const SCORE_CREATURE:int = 100;
		public static const SCORE_MED_SHOT_MULTIPLIER:int = 2;
		public static const SCORE_LONG_SHOT_MULTIPLIER:int = 4;
		public static const SCORE_BOUNCE_MULTIPLIER:int = 4;
		public function onEvent(event:String, args:Object):void {
			var score:int, scoreText:String='';
			switch (event) {
			case EVENT_KILL:
				score = SCORE_CREATURE;
				if (args.bullet.lifeTime > 4) {
					score *= SCORE_LONG_SHOT_MULTIPLIER;
					scoreText += ' LONG';
				}
				else if (args.bullet.lifeTime > 2) {
					score *= SCORE_MED_SHOT_MULTIPLIER;
					scoreText += ' MED';
				}
				if (args.bullet.bounces > 0) {
					score *= SCORE_BOUNCE_MULTIPLIER * args.bullet.bounces;
					if (scoreText.length == 0) scoreText += ' BOUNCE';
				}
				scoreText = String(score) + scoreText;
				break;
			
			case EVENT_KILL_CHAINED:
				score = SCORE_CREATURE * Math.min(args.killed.chain.chainedCount, 3);
				scoreText = String(score) + ' CHAIN';
				break;
			}
			if (args.killed) args.killed.setText(scoreText);
			FlxG.score += score;
		}
		
		public function onGameOver():void {
			gameOver = true;
			_scoreText.visible = false;
			add(new FlxText(0, FlxG.height/2, FlxG.width, 80, "GAME OVER\nScore: "+FlxG.score, 0xffffff, null, 16, "center"));
			Tweener.addTween(lightsLayer, {
				ALPHA:0xff, time:1,
				transition:'linear'
			});
		}
		
		override public function render():void {
			super.render();
			if (_editor) _editor.render();
		}
		
		override public function update():void {
			player.disableBullets();
			super.update();
			player.updateBullets();
			if (_editor) _editor.update();
			if (!gameOver && buildingsLayer.buildingsAreAllDead()) onGameOver();
			_scoreText.setText('Score: '+ FlxG.score);
		}
	}
}
