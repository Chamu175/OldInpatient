package customClasses
{
	import events.CustomIndexEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class SimpleImageButton extends Sprite
	{
		private var button:Bitmap;
		private var buttonPressed:Bitmap;
		private var buttonHolder:Sprite;
		private var formatUnPressed:TextFormat;
		private var formatPressed:TextFormat;
		
		public var index:int;
		
		[Embed(source="assets/standard.png")]
		private static const Standard:Class;
		[Embed(source="assets/standardPressed.png")]
		private static const StandardPressed:Class;

		private var textField:TextField;
		
		public function SimpleImageButton(label:String, index:int, buttonUp:Class = null, buttonDown:Class = null)
		{
			this.index = index;
			
			buttonHolder = new Sprite();
			addChild(buttonHolder);
			
			if(buttonUp != null || buttonDown != null) {
				button = new buttonUp();
				buttonPressed = new buttonDown();
			}
			else {
				button = new Standard();
				buttonPressed = new StandardPressed();
			}
			buttonHolder.addChild(button);
			buttonHolder.addChild(buttonPressed);
			buttonPressed.visible = false;
			
			if(label != "") {
				textField = new TextField();
				textField.text = label;
				textField.width = this.width;
				textField.height = textField.textHeight * 1.5;
				textField.wordWrap = true;
				textField.y = this.height / 2 - textField.height / 2;
				textField.selectable = false;
				formatUnPressed = new TextFormat();
				formatUnPressed.color = 0xFFFFFF;
				formatUnPressed.size = 18;
				formatUnPressed.align = TextAlign.CENTER;
				textField.setTextFormat(formatUnPressed);
				addChild(textField);
				
				formatPressed = new TextFormat();
				formatPressed.color = 0x000000;
				formatPressed.size = 18;
				formatPressed.align = TextAlign.CENTER;
			}
			
			this.addEventListener(MouseEvent.MOUSE_UP, buttonClicked);
			this.addEventListener(MouseEvent.MOUSE_DOWN, buttonPressedDown);
		}
		
		protected function buttonClicked(event:MouseEvent):void
		{
			buttonPressed.visible = false;
			if(textField)
				textField.setTextFormat(formatUnPressed);
			dispatchEvent(new CustomIndexEvent(CustomIndexEvent.CUSTOM_EVENT, index));
		}
		
		protected function buttonPressedDown(event:MouseEvent):void
		{
			buttonPressed.visible = true;
			if(textField)
				textField.setTextFormat(formatPressed);
		}
		
		public function setPressed() :void {
			buttonPressed.visible = true;
			if(textField)
				textField.setTextFormat(formatPressed);
		}
		
		public function setUnPressed() :void {
			buttonPressed.visible = false;
			if(textField)
				textField.setTextFormat(formatUnPressed);
		}
	}
}