package com.FMSConnections
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[Event(name="onNetStatus", type="flash.events.NetStatusEvent")]
	
	public class CustomNetStream extends NetStream
	{
		private var clientObject:Object = new Object();
		public function CustomNetStream(connection:NetConnection, peerID:String="connectToFMS")
		{
			super(connection, peerID);
			clientObject.onMetaData = metaDataHandler;
			this.client = clientObject;
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
		private function metaDataHandler(infoObject:Object):void 
		{ 
		
		}
	}
}