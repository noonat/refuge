package com.noonat.refuge {
	import com.adamatomic.flixel.*;
	import flash.geom.Rectangle;
	
	public class Editor extends FlxLayer {
		private var _blocks:FlxArray;
		private var _block:Boolean=false;
		private var _bx:Number, _by:Number, _bw:Number, _bh:Number;
		private var _r:Rectangle;
		
		function Editor():void {
			_blocks = new FlxArray();
			_r = new Rectangle;
		}
		
		override public function render():void {
			super.render();
			if (!_block) return;
			_r.x = _bw < 0 ? _bx + _bw : _bx;
			_r.y = _bh < 0 ? _by + _bh : _by;
			_r.width = Math.abs(_bw);
			_r.height = Math.abs(_bh);
			FlxG.buffer.fillRect(_r, 0xffff0000);
		}
		
		override public function update():void {
			if (FlxG.consoleVisible) return;
			if (FlxG.justPressed(FlxG.MOUSE)) {
				//var ps:PlayState = FlxG.state as PlayState;
				//ps._buildings.add(ps.add(new Building(FlxG.mouse.x, FlxG.mouse.y)));
				if (!_block) startBlock();
				else finishBlock();
			}
			if (_block) {
				_bw = Math.floor((FlxG.mouse.x - _bx) / 16) * 16;
				_bh = Math.floor((FlxG.mouse.y - _by) / 4) * 4;
			}
		}
		
		internal function startBlock():void {
			_block = true;
			_bx = Math.floor(FlxG.mouse.x / 16) * 16;
			_by = Math.floor(FlxG.mouse.y / 4) * 4;
			_bw = _bh = 1;
		}
		
		internal function finishBlock():void {
			if (_bw < 0) _bx += _bw;
			if (_bh < 0) _by += _bh;
			_bw = Math.abs(_bw);
			_bh = Math.abs(_bh);
			_blocks.add(this.add(new Block(_bx, _by, _bw, _bh, 0xffff0000)));
			FlxG.log('['+[_bx,_by,_bw,_bh].join(', ')+'],')
			_block = false;
		}
	}
}