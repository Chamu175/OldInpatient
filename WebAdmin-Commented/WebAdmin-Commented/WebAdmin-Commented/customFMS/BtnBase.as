package fms
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BtnBase extends Sprite
	{
		private var button:Sprite = new Sprite();
		
		private var xPos:Number;
		private var yPos:Number;
		public var label:String;
		private var textLabel:TextField = new TextField()
		public function BtnBase(xpos:Number, ypos:Number, _label:String, defaultEventHandler:Function = null)
		{
			this.x = xpos;
			this.y = ypos;
			xPos = xpos;
			yPos = ypos;
			label = _label;
			drawButton();
			//button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this.buttonMode = true;
			addChild(button);
			if(defaultEventHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultEventHandler);
			}
		}
		private function drawButton():void {
			
			button.graphics.clear();
			button.graphics.lineStyle(2,0xff6600);
			button.graphics.beginFill(0xD4D4D4); // grey color
			button.graphics.drawRoundRect(0, 0, 100, 40, 10, 10); // x, y, width, height, ellipseW, ellipseH
			button.graphics.endFill();
			textLabel.text = label;
			textLabel.x = 10;
			textLabel.y = 5;
			textLabel.selectable = false;
			button.addChild(textLabel)
		}
		public function setLabel(lbl:String):void
		{
			label = lbl;
			textLabel.text = label;
		}
		/*private function mouseDownHandler(event:MouseEvent):void {
			button.x += 20
			if (button.x > 400) { button.x = 0}
		}*/
	}
}