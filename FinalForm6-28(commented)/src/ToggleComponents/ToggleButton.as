package ToggleComponents
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ToggleButton extends Sprite
	{
		private var bg:Sprite = new Sprite();
		private var hotLeft:Sprite = new Sprite();
		private var hotRight:Sprite = new Sprite();
		private var hotMiddle:Sprite = new Sprite();
		private var toggle:Sprite = new Sprite();
		private var leftString:String;
		private var rightString:String;
		
		public function ToggleButton(parent:DisplayObjectContainer = null,xPos:Number= 0,yPos:Number= 0,leftData:String ="",rightData:String="")
		{
			super();
			leftString = leftData;
			rightString = rightData;
			this.x = xPos;
			this.y = yPos;
			init();
			if(parent != null)
			{
				parent.addChild(this);
			}
			
		}
		private function init():void
		{
			drawBg();
			drawToggle();
			drawHotZones();
			handleListeners();
		}
		private function handleListeners():void
		{
			hotLeft.addEventListener(MouseEvent.CLICK,leftZoneHit);
			hotRight.addEventListener(MouseEvent.CLICK,rightZoneHit);
			hotMiddle.addEventListener(MouseEvent.CLICK,middleHit);
		}
		
		protected function middleHit(event:MouseEvent):void
		{
			toggle.x = 0;
			dispatchEvent(new ToggleEvent(ToggleEvent.TOGGLE_POSITION,"Middle",false,false));
		}
		
		protected function rightZoneHit(event:MouseEvent):void
		{
			if(toggle.x != bg.width/2-toggle.width-15){
				toggle.x = bg.width/2-toggle.width-15;
				dispatchEvent(new ToggleEvent(ToggleEvent.TOGGLE_POSITION,"Right",false,false));
			}
		}
		
		protected function leftZoneHit(event:MouseEvent):void
		{
			if(toggle.x != (bg.x-bg.width/2)+(toggle.width*2-20)){
				toggle.x = (bg.x-bg.width/2)+(toggle.width*2-20);
				dispatchEvent(new ToggleEvent(ToggleEvent.TOGGLE_POSITION,"Left",false,false));
			}
		}
		
		private function drawHotZones():void
		{
			var leftText:TextField = new TextField();
			var rightText:TextField = new TextField();
			hotLeft.graphics.clear();
			//hotLeft.graphics.lineStyle(1,0x000000);
			hotLeft.graphics.beginFill(0x0000ff,0);
			hotLeft.graphics.drawRoundRect(0,0,bg.width/3,bg.height,45,45);
			hotLeft.graphics.endFill();
			leftText.text = leftString;
			leftText.selectable = false;
			leftText.height = bg.height/2;
			leftText.width = hotLeft.width/2;
			leftText.x = 4;
			leftText.y = 8;
			bg.addChild(hotLeft);
			hotLeft.addChild(leftText);
			
			
			hotRight.graphics.clear();
			//hotRight.graphics.lineStyle(1,0x000000);
			hotRight.graphics.beginFill(0x0000ff,0);
			hotRight.graphics.drawRoundRect(bg.width-bg.width/3,0,bg.width/3,bg.height/2,45,45);
			hotRight.graphics.endFill();
			rightText.text = rightString;
			rightText.selectable = false;
			rightText.x = bg.width - hotRight.width/2;
			rightText.y = 8;
			bg.addChild(hotRight);
			hotRight.addChild(rightText);
			hotMiddle.graphics.clear();
			//hotMiddle.graphics.lineStyle(1,0x000000);
			hotMiddle.graphics.beginFill(0x0000ff,0);
			hotMiddle.graphics.drawRoundRect(bg.width/3,0,bg.width/3,bg.height,20,20);
			hotMiddle.graphics.endFill();
			addChild(hotMiddle);
		}
		
		private function drawToggle():void
		{
			toggle.graphics.clear();
			toggle.graphics.lineStyle(1,0x000000);
			toggle.graphics.beginFill(0x000000);
			toggle.graphics.drawCircle(bg.width/2,bg.height/2,bg.height/2);
			toggle.graphics.endFill();
			bg.addChild(toggle);
		}
		
		private function drawBg():void
		{
			bg.graphics.clear();
			bg.graphics.lineStyle(1,0x000000);
			bg.graphics.beginFill(0xD4D4D4);
			bg.graphics.drawRoundRect(0,0,250,30,45,45);
			bg.graphics.endFill();
			addChild(bg);
		}
		
	}
}