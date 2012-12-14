package events
{
	import flash.events.Event;
	
	public class FMSMessageEvent extends Event
	{
		public static const MESSAGE:String = "MESSAGE";
		public var message:String;
		
		public function FMSMessageEvent(type:String, _message:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			message = _message;
			super(type, bubbles, cancelable);
		}
		
		override public function clone() :Event {
			return new FMSMessageEvent(type, message, bubbles, cancelable);
		}
	}
}