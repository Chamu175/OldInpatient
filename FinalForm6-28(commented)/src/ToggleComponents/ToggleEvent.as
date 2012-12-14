package ToggleComponents
{
	import flash.events.Event;
	
	public class ToggleEvent extends Event
	{
		public var state:String;
		public static const TOGGLE_POSITION:String = "PositionEvent";
		
		public function ToggleEvent(type:String,state:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.state = state;
		}
		public override function clone():Event
		{
			return new ToggleEvent(type,state,bubbles,cancelable );
		}
		override public function toString():String
		{
			return formatToString("PositionEvent", "type","PositionEvent", "bubbles", "cancelable");
		}
	}
}