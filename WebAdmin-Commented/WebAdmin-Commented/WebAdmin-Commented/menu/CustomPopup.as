package  menu{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import ui.UIButton;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import com.greensock.*;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	
	public class CustomPopup extends Sprite{
		
		private var square:Sprite;
		private var yes:UIButton;
		private var no:UIButton;
		private var confirm:TextField;
		private var _text:String = new String();
		
		public function CustomPopup(w:int, h:int, string:String) {
			_text = string;
			
			//creates square background
			square = new Sprite();
			addChild(square);
			square.graphics.lineStyle(3,0x333333);
			square.graphics.beginFill(0xCCCCCC);
			square.graphics.drawRect(0,0,w,h);
			square.graphics.endFill();
			
			//text that will be displayed on popup
			confirm = new TextField();
			confirm.text = _text;
			confirm.autoSize = TextFieldAutoSize.CENTER;
			var format:TextFormat = new TextFormat();
			format.size = 24;
			confirm.setTextFormat(format);
			confirm.x = square.x + 10;
			confirm.y = square.y + 10;
			square.addChild(confirm);
			
			yes = new UIButton(100, 50, "Yes", 0x33DD00, 20);
			yes.x = square.width / 2 - yes.width / 2 - 60;
			yes.y = square.height - 100;
			yes.addEventListener(UIButton.CLICKED, yesClicked);
			square.addChild(yes);
			
			no = new UIButton(100, 50, "No", 0xFF0000, 20);
			no.x = square.width / 2 - no.width / 2 + 60;
			no.y = square.height - 100;
			no.addEventListener(UIButton.CLICKED, noClicked);
			square.addChild(no);
		}
		
		//user clicks yes on popup
		private function yesClicked(event:Event):void {
			dispatchEvent(new Event("ON_YES_CLICK"));
			TweenLite.to(this, .5, {alpha:0, onComplete:deletePopup});
		}
		//user clicks no on popup
		private function noClicked(event:Event):void {
			TweenLite.to(this, .5, {alpha:0, onComplete:deletePopup});
		}

		//if no clicked, this class deletes itself
		private function deletePopup():void {
			this.parent.removeChild(this);
		}
	}
	
}
