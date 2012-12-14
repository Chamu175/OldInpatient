package files
{
	import com.adobe.images.JPGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	public class FileManager extends Sprite
	{
		private var file:File;
		private var _path:String;
		public var imageData:BitmapData;
		
		private var db_path:String = "http://wdmdsrv1.uwsp.edu/MobileUWSPApp/image.php";
		
		public function FileManager(path:String, server_path:String)
		{
			file = File.applicationStorageDirectory.resolvePath(path);
			db_path = server_path;
		}
		
		public function saveImage(imageData:BitmapData):void {
			this.imageData = imageData;
			try {
				var stream:FileStream = new FileStream;
				stream.open(file, FileMode.WRITE);
				var data:ByteArray = getJPEG(imageData);
				stream.writeBytes(data, 0, data.bytesAvailable);
				stream.close();
			}
			catch(error:Error) {
				//throw error
				throw new Error(error.message);
			}
		}
		
		private function getJPEG(bmd:BitmapData):ByteArray {
			var jpg:JPGEncoder = new JPGEncoder(80);
			return jpg.encode(bmd);
		}
		
		public function upload() :void {
			try {
				file.addEventListener(IOErrorEvent.IO_ERROR, fileFailUpload);
				file.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler );
				var request:URLRequest = new URLRequest(db_path);
				request.method = URLRequestMethod.POST;
				file.upload(request);
			}
			catch(error:Error) {
				//throw error
				throw new Error(error.message);
			}
		}
		
		protected function uploadCompleteDataHandler(event:DataEvent):void
		{
			if(event.data != "Error") {
				dispatchEvent(new Event("ImageUploaded",true));
				if(file.exists)
					file.deleteFile();
			}
			else {
				dispatchEvent(new Event("UploadFail",true));
			}
		}
		
		protected function fileFailUpload(event:IOErrorEvent):void
		{
			dispatchEvent(new Event("UploadFail",true));
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function set path(url:String):void
		{
			_path = url;
			file = File.applicationStorageDirectory.resolvePath(url);
		}
	}
}