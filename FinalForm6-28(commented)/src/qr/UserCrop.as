package qr
{
	import customClasses.UIButtonMobile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import gs.TweenFilterLite;
	
	public class UserCrop extends Sprite
	{
		private static const SMALL_CROP:Number = .4;
		private static const MEDIUM_CROP:Number = .5;
		private static const LARGE_CROP:Number = .6;
		
		private var image:Bitmap;
		private var _stage:Stage;
		private var close:UIButtonMobile;
		public var savedImage:Bitmap;

		private var mask2:Sprite;
		private var retake:UIButtonMobile;
		private var small:UIButtonMobile;
		private var medium:UIButtonMobile;
		private var large:UIButtonMobile;
		
		public function UserCrop(image:Bitmap, _stage:Stage) :void{
			this.image = image;
			this._stage = _stage;
			if(this.image.height > _stage.stageHeight) {
				this.image.width = this.image.width * (_stage.stageHeight / this.image.height);
				this.image.height = this.image.height * (_stage.stageHeight / this.image.height);
			}
			//image.width = _stage.stageWidth;
			//image.height = _stage.stageHeight;
			addChild(image);
			
			this.alpha = 0;
			TweenFilterLite.to(this, .2, {alpha:1});
			
			initUserCrop();
		}
		
		private function initUserCrop():void
		{
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRect(image.width, 0, _stage.stageWidth - image.width, _stage.stageHeight);
			bg.graphics.endFill();
			addChild(bg);
			
			close = new UIButtonMobile("Crop Image",0x00FF00, 28, bg.width / 1.3, 85);
			close.addEventListener(UIButtonMobile.CLICKED, saveAndCrop);
			addChild(close);
			close.x = (image.width + bg.width / 2) - close.width / 2;
			close.y = (_stage.height / 2 - close.height / 2) - 75;
			
			retake = new UIButtonMobile("Retake Image", 0xFF0000, 28, bg.width / 1.3, 85);
			retake.addEventListener(UIButtonMobile.CLICKED, retakeImage);
			addChild(retake);
			retake.x = (image.width + bg.width / 2) - close.width / 2;
			retake.y = (_stage.height / 2 - close.height / 2) + 75;
			
			mask2 = new Sprite();
			mask2.graphics.lineStyle(10, 0x000000);
			mask2.graphics.beginFill(0x000000, 0);
			mask2.graphics.drawRect(image.width / 2 - (image.width * SMALL_CROP) / 2, image.height / 2 - (image.width * SMALL_CROP) / 2, image.width * SMALL_CROP, image.width * SMALL_CROP);
			mask2.graphics.endFill();
			addChild(mask2);
			
			small = new UIButtonMobile("Small",0x000000,20,0,0,0);
			small.addEventListener(UIButtonMobile.CLICKED, changeCropSize);
			small.dim();
			addChild(small);
			
			medium = new UIButtonMobile("Medium",0x000000,20,0,0,0);
			medium.addEventListener(UIButtonMobile.CLICKED, changeCropSize);
			medium.x = small.width;
			addChild(medium);
			
			large = new UIButtonMobile("Large",0x000000,20,0,0,0);
			large.addEventListener(UIButtonMobile.CLICKED, changeCropSize);
			large.x = small.width + medium.width;
			addChild(large);
			
			mask2.addEventListener(MouseEvent.MOUSE_DOWN, startCropDrag);
			mask2.addEventListener(MouseEvent.MOUSE_UP, stopCropDrag);
		}
		
		protected function changeCropSize(event:Event):void
		{
			switch(event.target.label) {
				case "Small":
					mask2.graphics.clear();
					mask2.graphics.lineStyle(10, 0x000000);
					mask2.graphics.beginFill(0x000000, 0);
					mask2.graphics.drawRect(image.width / 2 - (image.width * SMALL_CROP) / 2, image.height / 2 - (image.width * SMALL_CROP) / 2, image.width * SMALL_CROP, image.width * SMALL_CROP);
					mask2.graphics.endFill();
					
					small.dim();
					medium.show();
					large.show();
				break;
				case "Medium":
					mask2.graphics.clear();
					mask2.graphics.lineStyle(10, 0x000000);
					mask2.graphics.beginFill(0x000000, 0);
					mask2.graphics.drawRect(image.width / 2 - (image.width * MEDIUM_CROP) / 2, image.height / 2 - (image.width * MEDIUM_CROP) / 2, image.width * MEDIUM_CROP, image.width * MEDIUM_CROP);
					mask2.graphics.endFill();
					
					small.show();
					medium.dim();
					large.show();
				break;
				case "Large":
					mask2.graphics.clear();
					mask2.graphics.lineStyle(10, 0x000000);
					mask2.graphics.beginFill(0x000000, 0);
					mask2.graphics.drawRect(image.width / 2 - (image.width * LARGE_CROP) / 2, image.height / 2 - (image.width * LARGE_CROP) / 2, image.width * LARGE_CROP, image.width * LARGE_CROP);
					mask2.graphics.endFill();
					
					small.show();
					medium.show();
					large.dim();
				break;
			}
		}
		
		protected function retakeImage(event:Event):void
		{
			close.removeEventListener(UIButtonMobile.CLICKED, saveAndCrop);
			retake.removeEventListener(UIButtonMobile.CLICKED, retakeImage);
			dispatchEvent(new Event("RetakeImage"));
		}
		
		protected function saveAndCrop(event:Event):void
		{
			//crop image
			var rect:Rectangle = mask2.getBounds(image);
			savedImage = crop(rect.x, rect.y, rect.width, rect.height, image);
			
			close.removeEventListener(UIButtonMobile.CLICKED, saveAndCrop);
			retake.removeEventListener(UIButtonMobile.CLICKED, retakeImage);
			dispatchEvent(new Event("ImageReady"));
		}
		
		private function crop( _x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject):Bitmap
		{
			var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw(displayObject, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
			return croppedBitmap;
		}
		
		protected function startCropDrag(event:MouseEvent):void
		{
			event.target.startDrag();
		}
		
		protected function stopCropDrag(event:MouseEvent):void
		{
			event.target.stopDrag();
		}
	}
}