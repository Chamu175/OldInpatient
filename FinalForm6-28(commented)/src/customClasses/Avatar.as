package customClasses
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class Avatar extends Sprite
	{
		[Embed(source="assets/hospitalHelper.png")]
		public static const mouthClosed:Class;
		
		[Embed(source="assets/hospitalHelper2.png")]
		public static const mouthOpen:Class;
		
		private var _mouthClosed:Bitmap;
		private var _mouthOpen:Bitmap;
		private var closedHolder:Sprite = new Sprite();
		private var openHolder:Sprite = new Sprite();
		private var talking:Boolean = true;
		private var myTimer:Timer;
		
		public function Avatar()
		{
			_mouthClosed = new mouthClosed();
			
			_mouthOpen = new mouthOpen();
			
			closedHolder.addChild(_mouthClosed);
			addChild(closedHolder);
			
			openHolder.addChild(_mouthOpen);
			addChild(openHolder);
			openHolder.visible = false;
		}
		
		public function startTalking():void {
			myTimer = new Timer(300, 9999);
			myTimer.addEventListener(TimerEvent.TIMER, talk);
			myTimer.start();
		}
		
		private function talk (e:TimerEvent):void{
			if (talking == true) {
				closedHolder.visible = false;
				openHolder.visible = true;
				talking = false;
				//trace('open');
			} else if (talking == false) {
				closedHolder.visible = true;
				openHolder.visible = false;
				talking = true;
				//trace('closed');
			}
		}
		
		public function idle():void {
			myTimer.stop();
			openHolder.visible = false;
		}
	}
}