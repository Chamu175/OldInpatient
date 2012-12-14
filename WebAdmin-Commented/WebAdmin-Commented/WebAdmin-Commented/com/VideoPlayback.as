package com.FMSConnections
{
	import com.FMSConnections.CustomNetConnection;
	import com.FMSConnections.CustomNetStream;
	
	import customComponentClasses.BtnBase;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.text.TextField;
	
	[Event(name="Connected", type="flash.events.NetStatusEvent")]
	
	public class VideoPlayback extends VideoViewer
	{
		private var videoName:String;
		public function VideoPlayback(w:Number, h:Number, xPos:Number, yPos:Number)
		{
			super(w, h, xPos, yPos);
		}
		protected override function onConnect(event:NetStatusEvent):void
		{
			trace("Player: " + event.info.code);
			//doStreams();
			initVideo();
			drawPlaybackUI();
			dispatchEvent(new NetStatusEvent("Connected",false,false, event.info));
		}
		
		private function drawPlaybackUI():void
		{
			var pauseBtn:BtnBase = new BtnBase(0,_height,"Pause",pauseVid);
			addChild(pauseBtn);
			var replayBtn:BtnBase = new BtnBase(_width-100,_height,"Record",replayVid);
			addChild(replayBtn);
		}
		
		private function replayVid(event:Event):void
		{
			ns.play(videoName);
		}
		
		private function pauseVid(event:Event):void
		{
			if(BtnBase(event.currentTarget).label == "Pause" && inputField.text != "")
			{
				ns.pause();
				BtnBase(event.currentTarget).setLabel("Play");
			}else{
				BtnBase(event.currentTarget).setLabel("Pause");
				ns.resume();
			}
		}
		public function playVid(vidName:String):void
		{
			trace("vidName: "+ vidName);
			videoName = vidName;
			ns.play("mp4:"+vidName+".f4v");
		}
		/*protected override function initVideo():void
		{
			video = new Video(_width,_height);
			video.attachNetStream(ns);
			bg.addChild(video);	
			trace("added");
		}*/
		public function checkConnection():Boolean
		{
			var connected:Boolean = nc.connected;
			return connected;
		}
	}
}