package events
{
	import flash.events.Event;
	
	public class QRDataEvent extends Event
	{
		public static const CUSTOM_EVENT: String = "custom_event";
		public var data:Array;
		
		public function QRDataEvent(type:String, data:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		override public function clone() :Event {
			return new QRDataEvent(type, data, bubbles, cancelable);
		}
	}
}