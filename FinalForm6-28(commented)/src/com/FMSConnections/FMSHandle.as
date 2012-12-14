package com.FMSConnections
{
	
	//SocketCatcher
	
	import com.Events.NumberPassEvent;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetStream;
	import flash.net.Responder;
	import flash.net.SharedObject;
	[Event(name="onConnect", type="flash.events.NetStatusEvent")]
	public class FMSHandle extends Sprite
	{
		//private var rtmp:String = "rtmpe://o8kqbyc7.rtmphost.com/pureASAutism/Holder/";
		private var rtmp:String;
		private var _so:SharedObject;
		public var nc:CustomNetConnection;
		private var _ns:NetStream;
		private var _userID:Number;
		private var fullPath:String;
		private var date:String;
		public var cam:Camera = Camera.getCamera();
		private var clientObject:Object = new Object();
		private var mic:Microphone = Microphone.getMicrophone();
		//public var videoObject:VideoDataObject = new VideoDataObject();
		//private var respond:Responder = new Responder(onRespond);
		
		public function FMSHandle()
		{
			super();
			//init();
		}
		public function init(cardNum:String):void
		{
			var num:Number = Number(cardNum);
			rtmp = "rtmp://localhost/patientMap/";
			//rtmp = "rtmp://o8kqbyc7.rtmphost.com/patientMapping/";
			nc = new CustomNetConnection();
			nc.initConnection(rtmp,"Patient",num);
			nc.addEventListener("onConnect", onConnect);
			nc.addEventListener("onFail",onFail);
			nc.client = this;
		}
		/**Fires when FMS is connected */
		private function onConnect(event:NetStatusEvent):void
		{
			trace("connected");
			dispatchEvent(new NetStatusEvent("onConnect",false,false, event.info));
			//clientObject.idNumber = 10115;
			//callForDate();
			//initSO();
			//doStreams();
		}
		/***********calls fms for date**************/
		private function callForDate():void
		{
			trace("date");
			nc.call("returnDate",  new Responder(dateReply), null); 
		}
		private function dateReply(result:Object):void { 
			
			date = String(result);
			trace("dateReply received value: " + result); 
			//dateHolder = String(result);
		}
		/************************************ End **************************************************/
		/**Gets a custom user id from the fms and inits the creation of the avatarholder class which will 
		 * init the drawing of the avatars*/
		public function setUserID(userID:Number):void
		{
			
			_userID = userID;
			//avatarsHolder =new AvatarsHolder();
			//addChild(avatarsHolder);
			
			//avatarsHolder.addAvatar(_userID, 200, 200);
			//createSharedObject();
			
			//stage.addEventListener(MouseEvent.CLICK, onStageClick);
			
		}
		public function getUserID():Number
		{
			return _userID;
		}
		
		/**inits the shared object(SO) on the server.  Shared objects are objects that can be shared between
		 * clients.  There are three types:
		 * Local-which can be used to hold high scores on local machines
		 * Remote Server- These are held and handled on the server (We will use this type for this example) 
		 * Remote Client- Held on server but handled by client*/
	/*	private function createSharedObject():void
		{
			_so = SharedObject.getRemote("avatars", nc.uri,false);
			_so.client = this;
			_so.addEventListener(NetStatusEvent.NET_STATUS, onSoNetStatus);
			_so.addEventListener(SyncEvent.SYNC, onSync);
			_so.connect(nc);
		}
		private function onSoNetStatus(e:NetStatusEvent):void
		{
			
		}

		private function onSync(e:SyncEvent):void
		{
			trace("synced");
			for (var i in _so.data.users) 
			{
				if(_so.data.users[i].userID != _userID){
					avatarsHolder.addAvatar(_so.data.users[i].userID,_so.data.users[i].xPos,_so.data.users[i].yPos);
				}
			}
			_so.removeEventListener(SyncEvent.SYNC, onSync);
		}
		//SO functions from server
		public function onMoveAvatar(userID:Number, xPos:Number, yPos:Number):void
		{
			trace("UID: "+ userID + "X: " +xPos +"Y: "+ yPos)
			//avatarsHolder.moveAvatarTo(userID, xPos, yPos);
		}

		public function addUser(clientObj:Object):void
		{
			//avatarsHolder.addAvatar(clientObj.userID, clientObj.xPos, clientObj.yPos);
		}
		public function removeUser(userID:Number):void
		{
			//avatarsHolder.removeAvatar(userID);
		}*/
		public function updateUserPosition(locationID:Number):void
		{
			trace("position update");
			dispatchEvent(new NumberPassEvent(NumberPassEvent.NUMBER_PASS_EVENT,locationID,false,false));
		}
		private function doStreams():void
		{
			_ns = new NetStream( nc );
			_ns.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
			var client:Object = new Object();
			client.onTimeCoordInfo = function():void {};
			client.onMetaData = onMetaDataResponse;
			ns.client = client;
		}
		protected function onNetStatus(event:NetStatusEvent):void
		{
			trace(event.info.code);
		} 
		public function beginRecord():void
		{
			_ns.attachCamera(cam);
			_ns.attachAudio(mic);
			//trace("mp4:"+"Holder/"+MobileAutismV2.child.childName+"/"+date+"_"+MobileAutismV2.user.userInitials+".f4v");
			//_ns.publish("mp4:"+MobileAutismV2.child.childName+"/"+date+"_"+MobileAutismV2.user.userInitials+".f4v", "record" );
		}
		public function playVid(vidName:String):void
		{
			//trace("mp4:"+"streams/"+vidName+".f4v");
			_ns.play("mp4:"+vidName+".f4v");
			//_ns.play("mp4:"+"streams/"+vidName+".f4v");
		}
		public function stopRecord():void
		{
			_ns.close();
		}
		
		public function soProperty(propertyName:String,value:Object):void
		{
			_so.setProperty(propertyName,value);
		}
		public function callFMS(commandString:String,userID:int,positionID:int):void
		{
			nc.call(commandString,null,userID,positionID);
		}
		public function callForID(cardNum:String):void
		{
			var num:Number = Number(cardNum);
			nc.call("returnID",new Responder(onReply),num);
		}
		private function onReply(num:Number):void
		{
			trace(num);
		}
		
		/**Fires when FMS fails to connect */
		private function onFail(event:NetStatusEvent):void
		{
			
		}
		private function onAsyncError(event:AsyncErrorEvent):void
		{
			try{}catch(e:Error){}	
		}
		private function onMetaDataResponse(metaData:Object):void
		{
			/*videoObject.vidLength = metaData.duration;
			var key:String; 
			for (key in metaData){ 
				trace(key + ": " + metaData[key] + "\n"); 
			} */
		}
		
		public function getNSTime():Number
		{
			return ns.time;
		}
		public function get ns():NetStream
		{
			return _ns;
		}
		/*public function getNS():CustomNetStream
		{
			return ns;
		}*/
	}
}