package qr.fms
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import qr.fms.CustomNetConnection;
	import qr.fms.CustomNetStream;
	
	[Event(name="Connected", type="flash.events.NetStatusEvent")]
	
	public class VideoPlayback extends Sprite
	{
		private var videoName:String;
		private var video:Video;
		private var _ns:CustomNetStream;
		private var _nc:CustomNetConnection;
		
		private var background:Sprite;
		private var buffering:TextField;
		
		[Embed(source="assets/exitVideo.png")]
		private static const Close:Class;
		private var close:Bitmap;
		
		[Embed(source="assets/pause.png")]
		private static const Pause:Class;
		private var pause:Bitmap;
		
		[Embed(source="assets/replay.png")]
		private static const Replay:Class;
		private var replay:Bitmap;

		private var nsBuffer:Boolean;
		private var finished:Boolean;
		private var replayHolder:Sprite;
		private var vidFinished:Boolean = false;
		private var exit:Boolean;
		
		public function VideoPlayback(ns:CustomNetStream, nc:CustomNetConnection, _video:String, exitButton:Boolean = false)
		{
			super();
			_ns = ns;
			_nc = nc;
			videoName =  _video;
			exit = exitButton;
			initVideo();
		}
		
		public function replayVid(event:Event):void
		{
			_ns.play("mp4:"+ videoName + ".f4v");
		}
		
		public function pauseVid(event:Event):void
		{
			_ns.pause();
		}
		public function pausePlay(playing:Boolean):void
		{
			if(!playing) {
				_ns.resume();
				removeChild(pause);
				dispatchEvent(new Event("Playing", true));
			}
			else if(playing && !vidFinished){
				addChild(pause);
				_ns.pause();
				dispatchEvent(new Event("Paused", true));
			}
		}
		public function stopVideo() :void {
			_ns.close();
			video.clear();
		}
		private function initVideo():void
		{
			var playerBackground:Sprite = new Sprite();
			playerBackground.graphics.beginFill(0x000000);
			playerBackground.graphics.drawRoundRect(0, 0, 395, 290, 5);
			playerBackground.graphics.endFill();
			addChild(playerBackground);
			
			_ns = new CustomNetStream(_nc);
			_ns.addEventListener("onNetStatus", onNetStatus);
			_ns.bufferTime = 1000;
			video = new Video(385,280);
			video.x = 5;
			video.y = 5;
			video.attachNetStream(_ns);
			addChild(video);
			trace("mp4:"+ videoName + ".f4v");
			_ns.play("mp4:"+ videoName + ".f4v");
			
			var customClient:Object = new Object();
			_ns.client = customClient;
			customClient.onMetaData = metaDataHandler;
			
			if(exit) {
				close = new Close();
				var closeSprite:Sprite = new Sprite();
				closeSprite.addChild(close);
				closeSprite.addEventListener(MouseEvent.CLICK, closeVideo);
				addChild(closeSprite);
				closeSprite.x = video.width + 10;
				closeSprite.y = -25;
			}
			
			pause = new Pause();
			pause.x = ((video.width + 20) / 2) - (pause.width / 2);
			pause.y = ((video.height + 20) / 2) - (pause.height / 2);
			
			buffering = new TextField();
			buffering.width = 300;
			buffering.text = "Buffering...";
			var format:TextFormat = new TextFormat();
			format.size = 20;
			format.align = TextFormatAlign.CENTER;
			format.color = 0xFFFFFF;
			buffering.setTextFormat(format);
			
			buffering.x = video.width / 2 - buffering.width / 2;
			buffering.y = video.height / 2;
			addChild(buffering);
			
			replay = new Replay();
			replayHolder = new Sprite();
			replayHolder.addChild(replay);
			replayHolder.addEventListener(MouseEvent.CLICK, replayVideo);
			replay.x = ((video.width + 20) / 2) - (replay.width / 2);
			replay.y = ((video.height + 20) / 2) - (replay.height / 2);
			addChild(replayHolder);
			replayHolder.visible = false;
		}
		
		protected function replayVideo(event:MouseEvent):void
		{
			_ns.seek(0);
			replayHolder.visible = false;
			vidFinished = false;
		}
		
		protected function closeVideo(event:MouseEvent = null):void
		{
			_ns.close();
			video.clear();
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				this.removeChildAt(i);
			}
			dispatchEvent(new Event("Closed", true));
		}
		
		public function metaDataHandler(infoObject:Object):void {
			//trace(infoObject);
		}
		
		public function showBuffer():void
		{
			buffering.visible= true;
		}
		
		public function removeBuffer():void
		{
			buffering.visible = false;
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			switch(event.info.code) {
				case "NetStream.Buffer.Empty":
					if (nsBuffer){ 
						//do buffer animation
						showBuffer();
					}
					nsBuffer = false;
					
					if (finished) //actual video is done playing
					{
						finished = false;
						vidFinished = true;
						removeBuffer();
						//show replay button
						replayHolder.visible = true;
						
					}
					break;
				
				case "NetStream.Buffer.Full":
					if (!nsBuffer){ 
						//remove buffer animation 
						removeBuffer();
					}
					nsBuffer = true;
					break;
				
				case "NetStream.Play.Stop" :
					finished = true;//playback has stopped
					break;
				
				case "NetStream.Buffer.Flush":
					
					break;
				
				case "NetStream.Play.Start":
					removeBuffer();
					nsBuffer = false;
					break;
			}
		}
	}
}