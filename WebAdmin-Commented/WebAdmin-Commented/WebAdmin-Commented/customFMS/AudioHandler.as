package customFMS
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Graphics;
	
	public class AudioHandler extends Sprite
	{
		protected var _nc:CustomNetConnection;
		protected var _ns:CustomNetStream;
		private var _mic:Microphone = Microphone.getMicrophone();
		private var _vidName:String;
		protected var _width:int;
		protected var _height:int;
		private var soundTrans:SoundTransform = _mic.soundTransform;
		
		private var canvas:Sprite = new Sprite();
		private var g:Graphics = canvas.graphics;
		private var xInc:int = 5;
		
		public function AudioHandler(nc:CustomNetConnection,ns:CustomNetStream,vidName:String,w:Number,h:Number)
		{
			super();
			_width = w;
			_height = h;
			_nc = nc;
			_ns = ns;
			_vidName = vidName;
			setupSound();
			doStreams();
		}
		private function setupSound() :void {
			//soundTrans.volume = 0;
			_mic.soundTransform = soundTrans;
			addChild(canvas);
			
			initCanvas();
			
			var myTimer:Timer = new Timer(50);
			myTimer.addEventListener("timer", timeHandler);
			myTimer.start();
		}
		private function initCanvas() :void {
			g.clear();
			g.lineStyle(0, 0x000000);
			g.moveTo(5,200);
		}
		private function timeHandler(event:TimerEvent) :void {
			g.lineTo(xInc, 200 - _mic.activityLevel);
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
			_ns.publish("mp4:"+_vidName+".f4v", "record" );
		}
		
		public function stopPublishing() :void {
			_ns.close();
		}
	}
}