package customFMS
{
	import flash.events.Event;
	
	public class VideoNameEvent extends Event
	{
		public var vidName:String;
		
		public static const NAME_GIVEN:String = "CustomEventNameGiven";
		
		public function VideoNameEvent(type:String,vidName:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.vidName = vidName;
		}
		public override function clone():Event
		{
			return new VideoNameEvent(type,vidName,bubbles,cancelable );
		}
		override public function toString():String
		{
			return formatToString("VideoNameEvent", "type","vidName", "bubbles", "cancelable");
		}
	}
}