package ui {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gs.TweenFilterLite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.display.MovieClip;
	
	//event that dispatches when button is clicked
	[Event( name="clicked", type="flash.events.Event" )] 
	 
	public class UIButton extends Sprite {
		public static const CLICKED:String = "clicked"; 
		
		private var btnWidth:int;
		private var btnHeight:int;
		private var btnColor:int;
		private var labelText:String;
		private var fontSize:int;
		private var label:TextField;
		private var format:TextFormat;
		private var iconName:MovieClip;
		private var newIcon:MovieClip;

		public function UIButton(w:int, h:int, txt:String = "Label", color:int = 0x000000, fontSize:int = 20, _icon:MovieClip = null, xx:int = 0, yy:int = 0) {
			btnWidth = w;
			btnHeight = h;
			labelText = txt;
			btnColor = color;
			iconName = _icon;
			this.fontSize = fontSize;
			this.x = xx;
			this.y = yy;
			this.buttonMode = true;
			
			init();
		}
		
		private function init() :void {
			this.graphics.beginFill(btnColor);
			this.graphics.drawRoundRect(0, 0, btnWidth, btnHeight, 10);
			this.graphics.endFill();
			
			label = new TextField();
			label.text = labelText;
			label.width = this.width;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.selectable = label.multiline = label.mouseEnabled = false;
			
			format = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.color = 0xFFFFFF;
			format.size = fontSize;
			label.setTextFormat(format);
			//if an icon class was passed to the button, then use it as part of the button
			if (iconName != null) {
				newIcon = new MovieClip();
				newIcon = iconName;
				if (labelText == "") {
					//if button only contains an icon
					newIcon.x = this.width / 2 - newIcon.width / 2;
					newIcon.y = this.height / 2 - newIcon.height / 2;
				} else {
					newIcon.x = newIcon.width / 4;
					label.x = (this.width / 2) - (label.width / 2) + (newIcon.width / 2);
					label.y = (this.height / 2) - (label.height / 2);
				}
				addChild(newIcon);
				
			} else {
				label.y = (this.height / 2) - (label.height / 2);
			}
			
			addChild(label);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, buttonHover);
			this.addEventListener(MouseEvent.MOUSE_OUT, buttonHover);
			this.addEventListener(MouseEvent.MOUSE_UP, buttonClicked);
		}
		
		//slightly dim button on hover
		private function buttonHover(event:MouseEvent) {
			var a : Number = .8 + Number( event.type == MouseEvent.MOUSE_OUT ) * .2;
			TweenFilterLite.to( this, .25, { alpha : a } );
		}
		
		//dispatch event when the button is clicked
		private function buttonClicked(event:MouseEvent) {
			dispatchEvent(new Event(CLICKED)); 
		}
		
		//shows button, if it is hidden
		public function show () : void
		{
			if ( !this.visible ) this.alpha = 0;
			
			TweenFilterLite.to( this, .5, { autoAlpha : 1 } );
			this.addEventListener( MouseEvent.MOUSE_OVER, buttonHover );
			this.addEventListener( MouseEvent.MOUSE_OUT, buttonHover );
		}

		//hides button, if it is shown
		public function hide () : void
		{
			this.alpha = 0;
			this.visible = false;
			this.removeEventListener( MouseEvent.MOUSE_OVER, buttonHover );
			this.removeEventListener( MouseEvent.MOUSE_OUT, buttonHover );
		}
		
		//dim button
		public function dim () : void
		{
			if ( !this.visible ) this.alpha = 0;
			TweenFilterLite.to( this, .5, { autoAlpha : .4 } );
			
			this.removeEventListener( MouseEvent.MOUSE_OVER, buttonHover );
			this.removeEventListener( MouseEvent.MOUSE_OUT, buttonHover );
		}
		
		//set the label of the button
		public function setLabel(label:String) :void {
			this.label.text = label;
			this.label.setTextFormat(format);
		}
	}
	
}
