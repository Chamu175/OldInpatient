package qr.fms
{
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	public class AudioHandler extends Sprite
	{
		protected var bg:Sprite = new Sprite();
		protected var _nc:CustomNetConnection;
		protected var _ns:CustomNetStream;
		private var _mic:Microphone;
		private var _audioName:String;
		protected var _width:int;
		protected var _height:int;
		
		private var canvas:Sprite = new Sprite();
		private var g:Graphics = canvas.graphics;
		private var xInc:int = 5;
		
		private var recording:Boolean = false;
		
		public function AudioHandler(nc:CustomNetConnection,ns:CustomNetStream,audioName:String,w:Number,h:Number)
		{
			super();
			_width = 640;
			_height = 480;
			_nc = nc;
			_ns = ns;
			_audioName = audioName;
			setupSound();
			doStreams();
		}
		private function setupSound() :void {
			if(Microphone.isSupported) {
				_mic = Microphone.getMicrophone();
				if(_mic != null) {
					bg.graphics.clear();
					bg.graphics.lineStyle(3,0x000000);
					bg.graphics.beginFill(0xFFFFFF);
					bg.graphics.drawRoundRect(0, 0, _width, _height - 200, 5); // x, y, width, height, ellipseW, ellipseH
					bg.graphics.endFill();
					addChild(bg);
					
					addChild(canvas);
					
					initCanvas();
					
					var myTimer:Timer = new Timer(50);
					myTimer.addEventListener("timer", timeHandler);
					myTimer.start();
				}
			}
		}
		private function initCanvas() :void {
			g.clear();
			g.lineStyle(2, 0x000000);
			g.moveTo(5,275);
		}
		private function timeHandler(event:TimerEvent) :void {
			if(recording = true) {
				if(_mic.activityLevel > 1 && _mic.activityLevel < 10) {
					g.lineTo(xInc, 275 - (_mic.activityLevel * 12));
					//trace(_mic.activityLevel + ": " + (275 - (_mic.activityLevel * 3)));
				}
				else if(_mic.activityLevel >= 10 && _mic.activityLevel < 30) {
					g.lineTo(xInc, 275 - (_mic.activityLevel * 6.5));
					//trace(_mic.activityLevel + ": " + (275 - (_mic.activityLevel * 1.5)));
				}
				else if(_mic.activityLevel >= 30 && _mic.activityLevel < 60) {
					g.lineTo(xInc, 275 - (_mic.activityLevel * 4));
					//trace(_mic.activityLevel + ": " + (275 - (_mic.activityLevel * 1.2)));
				}
				else {
					g.lineTo(xInc, 275 - (_mic.activityLevel * 2.5));
				}
			}
			if(xInc > _width - 5) {
				xInc = 5;
				initCanvas();
			}
			else{
				xInc +=2;
			}
		}
		private function doStreams():void
		{
			_ns = new CustomNetStream(_nc)
			_ns.attachAudio(_mic);
		}
		public function publish():void
		{
			_ns.bufferTime = 0;
			_ns.publish("mp4:"+_audioName+".f4v", "record" );
			recording = true;
		}
		
		public function stopPublishing() :void {
			_ns.close();
			recording = false;
		}
	}
}