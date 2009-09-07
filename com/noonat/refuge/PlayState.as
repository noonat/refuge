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
		public var uiLayer:UILayer;
		protected var _editor:Editor;
		
		function PlayState():void {
			super();
			
			FlxG.scroll.y = 640;
			Tweener.addTween(FlxG.scroll, {y:0, delay:1, time:1, transition:'easeOutQuad'});
			
			lightsLayer = new LightsLayer(1.0/3.0, 0.8);
			blocksLayer = new BlocksLayer();
			buildingsLayer = new BuildingsLayer();
			creaturesLayer = new CreaturesLayer(lightsLayer);
			playerLayer = new FlxLayer();
			uiLayer = new UILayer(lightsLayer);
			
			player = new Player(playerLayer, lightsLayer);
			player.angle = 270;
			player.x = FlxG.width / 2 - player.width / 2;
			player.y = 495;
			playerLayer.add(player);
			
			add(creaturesLayer);
			add(playerLayer);
			add(buildingsLayer);
			add(blocksLayer);
			add(uiLayer);
			add(lightsLayer);
			add(new Block(0, -1280, 480, 1280, 0xff000000));
		}
		
		public static const EVENT_DEAD:String = 'dead';
		public static const EVENT_KILL:String = 'kill';
		public static const EVENT_KILL_CHAINED:String = 'kill_chained';
		public static const SCORE_CREATURE:int = 100;
		public static const SCORE_MED_SHOT_MULTIPLIER:int = 2;
		public static const SCORE_LONG_SHOT_MULTIPLIER:int = 4;
		public static const SCORE_BOUNCE_MULTIPLIER:int = 2;
		public function onEvent(event:String, args:Object):void {
			var multiplier:int, score:int, scoreText:String='';
			switch (event) {
			case EVENT_DEAD:
				break;
			
			case EVENT_KILL:
				score = SCORE_CREATURE;
				multiplier = 1;
				if (args.bullet.lifeTime > 4) {
					multiplier += SCORE_LONG_SHOT_MULTIPLIER;
					scoreText += ' LONG';
				}
				else if (args.bullet.lifeTime > 2) {
					multiplier += SCORE_MED_SHOT_MULTIPLIER;
					scoreText += ' MED';
				}
				if (args.bullet.bounces > 0) {
					multiplier += SCORE_BOUNCE_MULTIPLIER * args.bullet.bounces;
					if (scoreText.length == 0) scoreText += ' BOUNCE';
				}
				score *= multiplier;
				args.killed.chain = {bounces:args.bullet.bounces, count:1, refCount:1, totalScore:score};
				scoreText = String(score) + scoreText;
				break;
			
			case EVENT_KILL_CHAINED:
				var chain:Object = args.killed.chain = args.killer.chain;
				++chain.count;
				score = SCORE_CREATURE * (Math.min(chain.count, 6) + SCORE_BOUNCE_MULTIPLIER*chain.bounces);
				chain.totalScore += score;
				scoreText = String(score) + ' CHAIN';
				break;
			}
			if (args.killed) args.killed.setText(scoreText);
			FlxG.score += score;
		}
		
		public function onGameOver():void {
			gameOver = true;
			player.onGameOver();
			uiLayer.onGameOver();
			Tweener.addTween(lightsLayer, {alpha:1.0, time:2, transition:'linear'});
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
		}
	}
}
