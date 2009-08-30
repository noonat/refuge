package com.noonat.ld15 {
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
				if (!_block) startBlock();
				else finishBlock();
			}
			if (_block) {
				_bw = FlxG.mouse.x - _bx;
				_bh = FlxG.mouse.y - _by;
			}
		}
		
		internal function startBlock():void {
			_block = true;
			_bx = FlxG.mouse.x;
			_by = FlxG.mouse.y;
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