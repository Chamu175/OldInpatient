package events
{
	
	import com.danielfreeman.madcomponents.UILabel;
	
	import customMadness.UITouchLabel;
	
	import flash.events.Event;
	
	public class LabelTouchEvent extends Event
	{
		public static const CUSTOM_EVENT: String = "custom_event";
		public var label:UITouchLabel;
		
		public function LabelTouchEvent(type:String, _label:UITouchLabel, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			label = _label
		}
		
		override public function clone() :Event {
			return new LabelTouchEvent(type, label, bubbles, cancelable);
		}
	}
}