package events
{
	import flash.events.Event;
	
	public class CustomIndexEvent extends Event
	{
		public static const CUSTOM_EVENT: String = "IndexEvent";
		public var index:int;
		
		public function CustomIndexEvent(type:String, index:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.index = index;
		}
		
		override public function clone() :Event {
			return new CustomIndexEvent(type, index, bubbles, cancelable);
		}
	}
}