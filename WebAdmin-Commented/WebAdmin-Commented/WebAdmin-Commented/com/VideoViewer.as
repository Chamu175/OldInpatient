package com.FMSConnections
{
	import com.FMSConnections.CustomNetConnection;
	import com.FMSConnections.CustomNetStream;
	
	import customComponentClasses.BtnBase;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.text.TextField;
	
	//[Event(name="videoNameEvent", type="flash.events.Event")]
	public class VideoViewer extends Sprite
	{
		protected var _cam:Camera = Camera.getCamera();
		protected var _mic:Microphone = Microphone.getEnhancedMicrophone();
		protected var bg:Sprite = new Sprite();
		protected var _width:int;
		protected var _height:int;
		protected var textLabel:TextField = new TextField();
		protected var connectBtn:BtnBase;
		protected var video:Video;
		protected var nc:CustomNetConnection;
		protected var ns:CustomNetStream;
		private const rtmp:String =  "rtmpe://o8kqbyc7.rtmphost.com/objectRec";
		
		protected var inputField:TextField;
		
		
		public function VideoViewer(w:Number, h:Number, xPos:Number, yPos:Number )
		{
			super();
			this.x = xPos;
			this.y = yPos;
			_width = w;
			_height = h;
			drawBg();
			initConnection();
		}
		
		protected function drawBg():void {
			
			bg.graphics.clear();
			bg.graphics.beginFill(0xD4D4D4); // grey color
			bg.graphics.drawRect(0, 0, _width, _height); // x, y, width, height, ellipseW, ellipseH
			bg.graphics.endFill();
			textLabel.text = "Not Connected";
			textLabel.x = 10;
			textLabel.y = 5;
			textLabel.selectable = false;
			addChild(bg);
			bg.addChild(textLabel)
		}
		protected function initConnection():void
		{
			//connectBtn.setLabel("Connecting");
			nc = new CustomNetConnection();
			nc.addEventListener("onConnect", onConnect);
			nc.addEventListener("onFail",onFail);
			nc.client = this;
			nc.initConnection(rtmp);
		}
		
		protected function onFail(event:NetStatusEvent):void
		{
			trace(event.info.code);
		}
		
		protected function onConnect(event:NetStatusEvent):void
		{
			trace(event.info.code);
			connectBtn.setLabel("Connected");
			initVideo();
			doStreams();	
		}
		protected function initVideo():void
		{
			video = new Video(_width,_height);
			video.attachCamera(_cam);
			bg.addChild(video);
		
		}
		protected function doStreams():void
		{
			
			ns = new CustomNetStream( nc );
			ns.client = this;
			ns.attachAudio(_mic);
			ns.addEventListener("onNetStatus",onNetStatus);
			//video.attachCamera( _cam );
		}
		protected function onNetStatus(event:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			trace(event.info.code);
		}
	
	}
}