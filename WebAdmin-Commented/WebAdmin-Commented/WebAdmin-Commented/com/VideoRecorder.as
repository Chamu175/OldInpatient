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
	
	public class VideoRecorder extends VideoViewer
	{
		
		
		protected var mic:Microphone = Microphone.getMicrophone();
		
		public function VideoRecorder(w:Number, h:Number, xPos:Number, yPos:Number)
		{
			super(w, h, xPos, yPos);
			drawUI();
		}
		protected function drawUI():void
		{
			//connectBtn = new BtnBase(0,_height,"Connect",initConnection);
			//addChild(connectBtn);
			
			inputField= new TextField();
			addChild(inputField);
			inputField.border = true;
			inputField.width = 200;
			inputField.height = 25;
			inputField.x = 0;
			inputField.y = -25;
			inputField.type = "input";
			var vidName:TextField = new TextField()
			addChild(vidName);
			vidName.x = 0;
			vidName.y = -50;
			vidName.height = 25;
			vidName.text = "Enter a video name";
		}
		public function publish(event:Event):void
		{
			if(BtnBase(event.currentTarget).label == "Record" && inputField.text != "")
			{
				ns = new CustomNetStream(nc);
				ns.attachAudio( mic );
				ns.attachCamera( _cam );
				ns.publish("mp4:"+inputField.text+".f4v", "record" );
				BtnBase(event.currentTarget).setLabel("Stop");
			}else{
				BtnBase(event.currentTarget).setLabel("Record");
				dispatchEvent( new VideoNameEvent(VideoNameEvent.NAME_GIVEN, inputField.text, false, false));
				ns.close();
			}
			
		}
	}
}