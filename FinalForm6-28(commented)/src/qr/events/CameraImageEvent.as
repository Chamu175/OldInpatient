package qr.events
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class CameraImageEvent extends Event
	{
		
		public static const IMAGE_EVENT:String = "IMAGEEVENT";
		public var image:Bitmap;
		
		public function CameraImageEvent(type:String, image:Bitmap, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.image = image;
			super(type, bubbles, cancelable);
		}
		
		override public function clone() :Event {
			return new CameraImageEvent(type, image, bubbles, cancelable);
		}
	}
}