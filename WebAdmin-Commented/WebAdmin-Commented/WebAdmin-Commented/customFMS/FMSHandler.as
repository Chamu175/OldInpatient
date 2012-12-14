package customFMS
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenFilterLite;
	
	public class FMSHandler extends Sprite
	{
		protected var bg:Sprite = new Sprite();
		protected var _width:int;
		protected var _height:int;
		protected var textLabel:TextField = new TextField();
		protected var conText:TextField = new TextField();
		protected var format:TextFormat = new TextFormat();
		protected var nc:CustomNetConnection;
		protected var ns:CustomNetStream;
		private const rtmp:String =  "rtmpe://o8kqbyc7.rtmphost.com/Inpatient";
		public var audioHandle:AudioHandler;
		public var vidHandle:VideoHandler;
		private var vidName:TextField;
		
		public function FMSHandler(w:Number, h:Number, xPos:Number, yPos:Number)
		{
			super();
			this.x = xPos;
			this.y = yPos;
			_width = w;
			_height = h;
			//this.alpha = 0;
			drawBg();
			initConnection();
		}
		protected function drawBg():void {
			
			bg.graphics.clear();
			bg.graphics.beginFill(0x00CC00);
			bg.graphics.drawRect(0, 0, _width, _height); // x, y, width, height, ellipseW, ellipseH
			bg.graphics.endFill();
			format.size = 20;
			textLabel.text = "Record Audio";
			textLabel.width = 150;
			textLabel.x = 5;
			textLabel.y = 0;
			textLabel.selectable = false;
			textLabel.setTextFormat(format);
			conText.text = "Connecting...";
			conText.x = _width - 65;
			format.size = 15;
			conText.selectable = false;
			addChild(bg);
			addChild(textLabel);
			addChild(conText);
		}
		protected function initConnection():void
		{
			//connectBtn.setLabel("Connecting");
			nc = new CustomNetConnection();
			nc.addEventListener("onConnect", onConnect);
			nc.addEventListener("onFail",onFail);
			nc.client = this;
			nc.initConnection(rtmp);
			
			TweenFilterLite.to( this, .5, { autoAlpha : 1 } );
		}
		protected function onFail(event:NetStatusEvent):void
		{
			trace(event.info.code);
		}
		
		protected function onConnect(event:NetStatusEvent):void
		{
			dispatchEvent(new Event("Connected", true));
			conText.text = "Connected";
			doStreams();	
			//drawUI();
		}
		protected function doStreams():void
		{
			ns = new CustomNetStream( nc );
			ns.client = this;
			ns.addEventListener("onNetStatus",onNetStatus);
			//video.attachCamera( _cam );
		}
		protected function onNetStatus(event:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			//trace(event.info.code);
		}
		public function recordAudio(qrName:String):void
		{
			audioHandle = new AudioHandler(nc,ns,qrName + "Audio",_width,_height);
			addChild(audioHandle);
			dispatchEvent( new VideoNameEvent(VideoNameEvent.NAME_GIVEN, qrName + "Audio", false, false));
		}
		public function stopAudio() :void {
			audioHandle.stopPublishing();
		}
		public function createVideo(w:int, h:int, qrName:String) :void {
			vidHandle = new VideoHandler(nc,ns,qrName + "Video",w,h);
			addChild(vidHandle);
		}
		public function recordVideo(qrName:String):void
		{
			vidHandle = new VideoHandler(nc,ns,qrName + "Video",_width,_height);
			addChild(vidHandle);
			dispatchEvent( new VideoNameEvent(VideoNameEvent.NAME_GIVEN, qrName + "Video", false, false));
		}
		public function stopVideo() :void {
			vidHandle.stopPublishing();
		}
		
		public function setVideo() :void {
			textLabel.text = "Record Video";
			textLabel.setTextFormat(format);
			bg.graphics.clear();
			bg.graphics.beginFill(0x669900);
			bg.graphics.drawRect(0, 0, _width, _height); // x, y, width, height, ellipseW, ellipseH
			bg.graphics.endFill();
			if(audioHandle) {
				removeChild(audioHandle);
			}
		}
		
		public function setAudio() :void {
			textLabel.text = "Record Audio";
			textLabel.setTextFormat(format);
			bg.graphics.clear();
			bg.graphics.beginFill(0x00CC00);
			bg.graphics.drawRect(0, 0, _width, _height); // x, y, width, height, ellipseW, ellipseH
			bg.graphics.endFill();
			if(vidHandle) {
				removeChild(vidHandle);
			}
		}
	}
}