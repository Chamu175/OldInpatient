package events
{
	import bodyMap.PainIcon;
	
	import flash.events.Event;
	
	public class IconDragEvent extends Event
	{
		public static const DROP: String = "DROPEVENT";
		public static const DRAG: String = "DRAGEVENT";
		public var icon:PainIcon;
		
		public function IconDragEvent(type:String, _icon:PainIcon, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			icon = _icon;
			super(type, bubbles, cancelable);
		}
		
		override public function clone() :Event {
			return new IconDragEvent(type, icon, bubbles, cancelable);
		}
	}
}