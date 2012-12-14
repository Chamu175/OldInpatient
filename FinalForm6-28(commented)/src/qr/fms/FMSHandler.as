package qr.fms
{
	
	import events.FMSMessageEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class FMSHandler extends Sprite
	{
		protected var nc:CustomNetConnection;
		protected var ns:CustomNetStream;
		private const rtmp:String =  "rtmp://o8kqbyc7.rtmphost.com/Inpatient/";
		
		public var audio:AudioPlay;
		public var video:VideoPlayback;
		public var audioHandle:AudioHandler;
		public var videoHandle:VideoHandler;
		private var finished:Boolean;
		public var videoPlaying:Boolean;
		private var audioPlaying:Boolean;
		private var vidPlay:Boolean;
		
		protected var _width:int;
		protected var _height:int;
		private var nsBuffer:Boolean;
		
		public function FMSHandler(xPos:Number, yPos:Number, w:Number, h:Number, rfid:String = "0")
		{
			super();
			this.x = xPos;
			this.y = yPos;
			_width = w;
			_height = h;
			initConnection(rfid);
		}
		protected function initConnection(RFID:String):void
		{
			//connectBtn.setLabel("Connecting");
			nc = new CustomNetConnection();
			nc.addEventListener("onConnect", onConnect);
			nc.addEventListener("onFail",onFail);
			nc.client = this;
			if(RFID != "0")
				nc.initConnection(rtmp, "Patient", Number(RFID));
			else
				nc.initConnection(rtmp);
			
			//this.addEventListener(Event.REMOVED_FROM_STAGE, closeConnection);
		}
		
		public function receiveChatMessage(message:String) :void {
			dispatchEvent(new FMSMessageEvent(FMSMessageEvent.MESSAGE, message, true));
		}
		
		protected function closeConnection(event:Event):void
		{
			nc.close();
		}
		protected function onFail(event:NetStatusEvent):void
		{
			dispatchEvent(new Event("ConnectFailed", true));
		}
		
		protected function onConnect(event:NetStatusEvent):void
		{
			dispatchEvent(new Event("Connected", true));
			//doStreams();	
		}
		public function playAudio(_audio:String) :void {
			removePlayers();
			audio = new AudioPlay(nc, ns, _audio + "Audio");
			audio.addEventListener("AudioClosed", removeAudio);
			addChild(audio);
			//audio.x = 0;
			//audio.y = 0;
		}
		
		protected function removeAudio(event:Event):void
		{
			audio.removeEventListener("AudioClosed", removeAudio);
			audio.stopAudio();
			removePlayers();
		}
		
		public function playVideo(_video:String, userVideo:String = "") :void {
			removePlayers();
			
			video = new VideoPlayback(ns, nc, _video + userVideo);
			addChild(video);
			
			videoPlaying = true;
			vidPlay = true;
			video.addEventListener(MouseEvent.CLICK, checkVideoStatus);
			video.addEventListener("Paused", setPauseVariable);
			video.addEventListener("Playing", setPlayVariable);
			video.addEventListener("Closed", removeVideo);
		}
		
		public function removeVideo(event:Event = null):void
		{
			video.removeEventListener(MouseEvent.CLICK, checkVideoStatus);
			video.removeEventListener("Paused", setPauseVariable);
			video.removeEventListener("Playing", setPlayVariable);
			video.removeEventListener("Closed", removeVideo);
			removePlayers();
		}
		
		public function recordAudio(qrName:String) :void {
			removePlayers();
			audioHandle = new AudioHandler(nc,ns,qrName + "Audio",_width,_height);
			addChild(audioHandle);
		}
		
		public function recordVideo(qrName:String, userVid:Boolean = false) :void {
			removePlayers();
			if(userVid) {
				videoHandle = new VideoHandler(nc,ns,qrName + "UserVideo",_width,_height);
			}
			else
				videoHandle = new VideoHandler(nc,ns,qrName + "Video",_width,_height);
			addChild(videoHandle);
		}
		
		public function removePlayers():void
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				this.removeChildAt(i);
			}
			videoPlaying = false;
			audioPlaying = false;
		}
		
		protected function setPlayVariable(event:Event):void
		{
			vidPlay = true;
		}
		
		protected function setPauseVariable(event:Event):void
		{
			vidPlay = false;
		}
		
		protected function checkVideoStatus(event:MouseEvent):void
		{
			video.pausePlay(vidPlay);
		}
		
		public function addUser(firstname:String, lastname:String, rfid:String, location:String, imageURL:String) :void {
			nc.call("addPatient", null, firstname, lastname, rfid, location, imageURL);
		}
	}
}