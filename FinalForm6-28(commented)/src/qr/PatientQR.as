package qr
{
	import events.QRDataEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MediaEvent;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.FileReference;
	
	import gs.TweenFilterLite;
	
	import qr.camera.CustomCamera;
	import qr.events.CameraImageEvent;
	import qr.parse.QRReader;
	
	public class PatientQR extends Sprite
	{
		private var _stage:Stage;
		private var _image:Bitmap;
		private var cam:CustomCamera;
		public var qrReader:QRReader;
		private var userCrop:UserCrop;
		
		public function PatientQR(_stage:Stage)
		{
			this._stage = _stage;
			videoDisplay_creationComplete();
		}
		
		public function get image():Bitmap
		{
			return _image;
		}
		
		private function videoDisplay_creationComplete():void 
		{
			//start camera class
			cam = new CustomCamera(-1, _stage);
			cam.addEventListener(CameraImageEvent.IMAGE_EVENT, userCropImage);
			cam.addEventListener("CaptureCanceled", captureCancelled);
		}
		
		protected function userCropImage(event:CameraImageEvent):void
		{
			userCrop = new UserCrop(event.image, _stage);
			cam.removeEventListener(CameraImageEvent.IMAGE_EVENT, userCropImage);
			cam.removeEventListener("CaptureCanceled", captureCancelled);
			
			userCrop.addEventListener("ImageReady",decodeImage);
			userCrop.addEventListener("RetakeImage", retakeImage);
			addChild(userCrop);
		}
		
		protected function retakeImage(event:Event):void
		{
			removeChild(userCrop);
			userCrop.removeEventListener("ImageReady",decodeImage);
			userCrop.removeEventListener("RetakeImage", retakeImage);
			
			videoDisplay_creationComplete();
		}
		
		protected function captureCancelled(event:Event):void
		{
			dispatchEvent(new Event("CaptureCanceled", true));
		}
		
		protected function decodeImage(event:Event):void
		{	
			removeChild(userCrop);
			userCrop.removeEventListener("ImageReady",decodeImage);
			userCrop.removeEventListener("RetakeImage", retakeImage);
			
			qrReader = new QRReader();
			qrReader.addEventListener("ReadSuccess", setImage);
			qrReader.addEventListener("ReadFailure", sendError);
			
			qrReader.decodeSnapshot(userCrop.savedImage);
			//TweenFilterLite.
		}
		
		protected function sendError(event:Event):void
		{
			dispatchEvent(new Event("ReadFailure", true));
		}
		
		protected function setImage(event:Event):void
		{
			dispatchEvent(new  QRDataEvent(QRDataEvent.CUSTOM_EVENT, 	qrReader.qrText));
		}
		
	}
}