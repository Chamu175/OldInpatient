package customFMS
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.text.TextField;
	
	public class VideoHandler extends Sprite
	{
		protected var _nc:CustomNetConnection;
		protected var _ns:CustomNetStream;
		private var _mic:Microphone = Microphone.getMicrophone();
		private var _cam:Camera = Camera.getCamera();
		private var _vidName:String;
		protected var _width:int;
		protected var _height:int;
		private var vid:Video;
		
		public function VideoHandler(nc:CustomNetConnection,ns:CustomNetStream,vidName:String,w:Number,h:Number)
		{
			_width = w;
			_height = h;
			this.y = 20;
			_nc = nc;
			_ns = ns;
			_vidName = vidName;
			initVideo();
			doStreams();
		}
		private function initVideo():void
		{
			if (_cam != null){
				_cam.setMode(320, 240, 15);
				_cam.setQuality(0, 80);
				
				vid = new Video();
				vid.attachCamera(_cam);
				addChild(vid);
			} else {
				trace('No camera available.');
			}
		}
		private function doStreams():void
		{
			_ns = new CustomNetStream(_nc);
			_ns.attachAudio( _mic );
			_ns.attachCamera( _cam );
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