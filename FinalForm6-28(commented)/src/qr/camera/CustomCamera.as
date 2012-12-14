package qr.camera
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MediaEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	
	import qr.events.CameraImageEvent;
	
	public class CustomCamera extends Sprite
	{
		
		private var camera:CameraUI;
		private var _mediaPromise:MediaPromise;
		private var cameraUILoader:Loader;
		private var _image:Bitmap;
		private var _portrait:Boolean;
		private var scaleNumber:Number;
		private var _stage:Stage;
		
		public function CustomCamera(imageWidth:Number = -1, _stage:Stage = null)
		{
			scaleNumber = imageWidth;
			this._stage = _stage;
			if(CameraUI.isSupported) {
				camera = new CameraUI();
				
				camera.addEventListener(MediaEvent.COMPLETE, getPic);
				camera.addEventListener( Event.CANCEL, captureCanceled );
				camera.addEventListener(ErrorEvent.ERROR, cameraLaunchError);
				camera.launch(MediaType.IMAGE);
			}
		}
		
		protected function cameraLaunchError(event:ErrorEvent):void
		{
			dispatchEvent(new Event("CaptureCanceled", true));
		}
		
		public function get mediaPromise():MediaPromise
		{
			return _mediaPromise;
		}

		protected function captureCanceled(event:Event):void
		{
			dispatchEvent(new Event("CaptureCanceled", true));
		}
		
		public function get image():Bitmap
		{
			return _image;
		}

		protected function getPic(event:MediaEvent):void
		{
			_mediaPromise = event.data;
			
			cameraUILoader = new Loader ();
			cameraUILoader.contentLoaderInfo.addEventListener (Event.COMPLETE, loadImageHandler);
			cameraUILoader.loadFilePromise(mediaPromise);
		}
		
		protected function loadImageHandler(event:Event):void
		{
			if(scaleNumber == -1)
				_image = resizeImage(event.currentTarget.content);//drawScaled(event.currentTarget.content, event.currentTarget.content.width, event.currentTarget.content.height);
			else
				_image = drawScaled(event.currentTarget.content, event.currentTarget.content.width, event.currentTarget.content.height);
			//trace(_image.width, _image.height);
			cameraUILoader.unload();
			cameraUILoader.contentLoaderInfo.removeEventListener (Event.COMPLETE, loadImageHandler);
			dispatchEvent(new CameraImageEvent(CameraImageEvent.IMAGE_EVENT, _image, true));
		}
		
		private function resizeImage(bit:DisplayObject) :Bitmap {
			var m:Matrix = new Matrix();
			m.scale(_stage.stageWidth / bit.width, _stage.stageWidth / bit.width);
			var bmp:BitmapData = new BitmapData(_stage.stageWidth, (bit.height * (_stage.stageWidth / bit.width)), false);
			bmp.draw(bit, m);
			
			return new Bitmap(bmp);
		}
		
		public function drawScaled(obj:DisplayObject, thumbWidth:Number, thumbHeight:Number):Bitmap {
			scaleNumber = scaleNumber / obj.width;
			var m:Matrix = new Matrix();
			/*var area3:Rectangle = new Rectangle( Math.floor(obj.width / 2 - (obj.width * .8) / 2), Math.floor(obj.height / 2 - (obj.height * .8) / 2), Math.floor(obj.width) * .8, Math.floor(obj.height * .8));
			//area3.x = obj.width / 2 - area3.width / 2;
			//area3.y = obj.height / 2 - area3.height / 2;
			m = obj.transform.matrix;
			obj = crop(area3, m, area3.width, area3.height, obj);
			this.parent.parent.addChild(obj);*/
			
			m.scale(scaleNumber, scaleNumber);
			var bmp:BitmapData = new BitmapData(thumbWidth * scaleNumber, thumbHeight * scaleNumber, false);
			bmp.draw(obj, m);
			
			//var bitmap:BitmapData = new BitmapData(area3.width, area3.height);
			//bitmap.draw(bmp, m, null, null, null, true);
			return new Bitmap(bmp);
		}
		
		private function crop( rect:Rectangle, matrix:Matrix, _width:Number, _height:Number, displayObject:DisplayObject):Bitmap {
			//Create cropped image
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw(displayObject, matrix , null, null, rect, true );
			return croppedBitmap;
		}
	}
}