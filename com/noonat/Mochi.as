package com.noonat {
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxGame;
	import flash.display.MovieClip;
	import flash.events.Event;
	import mochi.as3.MochiScores;
	import mochi.as3.MochiServices;
	import Config;
	
	public class Mochi {
		protected static var _clip:MovieClip;
		protected static var _connecting:Boolean = false;
		protected static var _connected:Boolean = false;
		protected static var _game:FlxGame;
		
		public static function initialize(game:FlxGame):void {
			_connecting = false;
			_connected = false;
			_game = game;
			_game.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void {
				_game.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
				_connect();
			});
		}
		
		public static function showLeaderboard():void {
			MochiScores.showLeaderboard();
		}
		
		public static function submitToLeaderboard():void {
			if (!_connected) return;
			MochiScores.showLeaderboard({score:FlxG.score});
		}
		
		protected static function _connect():void {
			trace('[com.noonat.Mochi] connecting');
			if (_connecting || _connected) return;
			_clip = _game.parent.addChild(new MovieClip()) as MovieClip;
			MochiServices.connect(Config.MOCHI_GAME_ID, _clip);
			_connecting = true;
			_game.addEventListener(Event.ENTER_FRAME, function(event:Event):void {
				if (MochiServices.connected) {
					_game.removeEventListener(Event.ENTER_FRAME, arguments.callee);
					_connected = true;
					_onConnected();
				}
			});
		}
		
		protected static function _onConnected():void {
			trace('[com.noonat.Mochi] connected');
			var o:Object = {n: Config.MOCHI_BOARD_ID, f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0, '');
			MochiScores.setBoardID(boardID);
		}
	}
}
