package qr.fms
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.utils.Timer;
	
	public class AudioPlay extends MovieClip
	{
		
		protected var _nc:CustomNetConnection;
		protected var _ns:CustomNetStream;
		private var audio:String;
		private var finished:Boolean = false;
		
		public function AudioPlay(nc:CustomNetConnection, ns:CustomNetStream, _audio:String)
		{
			super();
			_nc = nc;
			_ns = ns;
			audio = _audio;
			doStreams();
		}
		
		private function doStreams():void
		{
			_ns = new CustomNetStream(_nc);
			_ns.addEventListener("onNetStatus", onNetStatus);
			
			var customClient:Object = new Object();
			_ns.client = customClient;
			customClient.onMetaData = metaDataHandler;
			_ns.play("mp4:"+ audio + ".f4v");
		}
		
		public function metaDataHandler(infoObject:Object):void {
			//trace(infoObject);
		}
		
		public function stopAudio() :void {
			_ns.close();
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			switch(event.info.code) {
				case "NetStream.Buffer.Empty":
					if (finished) //actual video is done playing
					{
						finished = false;
						dispatchEvent(new Event("AudioClosed", true));
					}
					break;
				
				case "NetStream.Buffer.Full":
					break;
				
				case "NetStream.Play.Stop" :
					finished = true;//playback has stopped
					break;
				
				case "NetStream.Buffer.Flush":
					
					break;
				
				case "NetStream.Play.Start":
					break;
			}
		}
	}
}