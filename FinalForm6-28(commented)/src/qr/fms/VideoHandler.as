package qr.fms
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.text.TextField;
	
	public class VideoHandler extends Sprite
	{
		protected var _nc:CustomNetConnection;
		protected var _ns:CustomNetStream;
		private var _mic:Microphone = Microphone.getMicrophone();
		public var _cam:Camera = getFrontCamera();
		private var _vidName:String;
		protected var _width:int;
		protected var _height:int;
		public var vid:Video;
		
		public function VideoHandler(nc:CustomNetConnection,ns:CustomNetStream,vidName:String,w:Number,h:Number)
		{
			super();
			_width = w;
			_height = h;
			_nc = nc;
			_ns = ns;
			_vidName = vidName;
			initVideo();
			doStreams();
		}
		private function initVideo():void
		{
			_cam.setMode(320, 240, 15);
			_cam.setQuality(0, 80);
			
			var playerBackground:Sprite = new Sprite();
			playerBackground.graphics.beginFill(0x000000);
			playerBackground.graphics.drawRoundRect(0, 0, 680, 520, 5);
			playerBackground.graphics.endFill();
			addChildAt(playerBackground, 0);
			
			vid = new Video(640, 480);
			vid.x = 20;
			vid.y = 20;
			vid.attachCamera(_cam);
			addChild(vid);
		}
		
		private function doStreams():void
		{
			_ns = new CustomNetStream(_nc);
			if(_mic != null && vid != null) {
				_ns.attachAudio( _mic );
				_ns.attachCamera( _cam );
			}
		}
		
		public function publish():void
		{
			_ns.bufferTime = 0;
			_ns.publish("mp4:"+_vidName+".f4v", "record" );
		}
		
		public function stopPublishing() :void {
			_ns.close();
		}
		
		public function getFrontCamera():Camera
		{
			//First check if the device supports a camera
			if (Camera.isSupported == false)
			{
				return null;
			}
			var numCameras:int = Camera.names.length;
			var frontCam:Camera;
			//Loop through all the available cameras on the device
			for (var i:int = 0; i < numCameras; i++)
			{
				frontCam = Camera.getCamera(Camera.names[i]);
				
				//If the camera.position property matches the constant CameraPosition.FRONT we have found
				//the front camera
				if (frontCam.position == CameraPosition.FRONT)
				{
					break;
				}
				
				//Make sure the camera object is set to null
				frontCam = null;
			}
			//Return the found camera
			return frontCam;
		}

	}
}