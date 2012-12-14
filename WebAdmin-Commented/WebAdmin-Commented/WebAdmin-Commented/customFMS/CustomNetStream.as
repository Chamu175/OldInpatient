package customFMS
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[Event(name="onNetStatus", type="flash.events.NetStatusEvent")]
	
	public class CustomNetStream extends NetStream
	{
		public function CustomNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
			addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			var code:String = event.info.code;
			trace("onNetStatus "+code);
			dispatchEvent(new NetStatusEvent("onNetStatus",false,false, event.info));
		}
		private function onAsyncError(e:AsyncErrorEvent):void
		{
			
		}
	}
}