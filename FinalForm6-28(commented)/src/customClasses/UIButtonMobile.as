package customClasses {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import gs.TweenFilterLite;
	
	[Event( name="clicked", type="flash.events.Event" )] 
	 
	public class UIButtonMobile extends Sprite {
		public static const CLICKED:String = "clicked"; 
		
		private var btnWidth:int;
		private var btnHeight:int;
		private var btnColor:int;
		private var cornerRad:int;
		private var labelText:String;
		private var fontSize:int;
		private var _label:TextField;
		private var format:TextFormat;
		private var iconName:MovieClip;
		private var newIcon:MovieClip;
		public var isDimmed:Boolean = false;

		public function UIButtonMobile(txt:String = "Label", color:int = 0x000000, fontSize:int = 20, w:int = 0, h:int = 0, cornerRadius:int = 10, _icon:MovieClip = null) {
			btnWidth = w;
			btnHeight = h;
			labelText = txt;
			btnColor = color;
			cornerRad = cornerRadius;
			iconName = _icon;
			this.fontSize = fontSize;
			/*this.x = xx;
			this.y = yy;*/
			this.buttonMode = true;
			
			init();
		}
		
		public function get label():String
		{
			return _label.text;
		}

		private function init() :void {
			_label = new TextField();
			_label.text = labelText;
			format = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.color = 0xFFFFFF;
			format.size = fontSize;
			_label.setTextFormat(format);
			
			this.graphics.beginFill(btnColor);
			if (btnWidth == 0) {
				this.graphics.drawRoundRect(0, 0, _label.textWidth + 30, _label.textHeight + 20, cornerRad);
			} else {
				this.graphics.drawRoundRect(0, 0, btnWidth, btnHeight, cornerRad);
			}
			
			this.graphics.endFill();
			
			_label.width = this.width;
			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.selectable = _label.multiline = _label.mouseEnabled = false;
			
			if (iconName != null) {
				newIcon = new MovieClip();
				newIcon = iconName;
				newIcon.x = newIcon.width / 4;
				addChild(newIcon);
				_label.x = (this.width / 2) - (_label.width / 2) + (newIcon.width / 2);
				_label.y = (this.height / 2) - (_label.height / 2);
			} else {
				_label.y = (this.height / 2) - (_label.height / 2);
			}
			
			addChild(_label);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, buttonDown);
			this.addEventListener(MouseEvent.MOUSE_UP, buttonClicked);
		}
		
		protected function buttonDown(event:MouseEvent):void
		{
			var a : Number = .8 + Number( event.type == MouseEvent.MOUSE_UP ) * .2;
			
			TweenFilterLite.to( this, .25, { alpha : a } );
		}
		
		private function buttonClicked(event:MouseEvent) :void {
			var a : Number = .8 + Number( event.type == MouseEvent.MOUSE_UP ) * .2;
			
			TweenFilterLite.to( this, .25, { alpha : a } );
			dispatchEvent(new Event(CLICKED)); 
		}
		
		public function show () : void
		{
			if ( !this.visible ) this.alpha = 0;
			TweenFilterLite.to( this, .5, { autoAlpha : 1 } );
			this.mouseEnabled = true;
			
			isDimmed = false;
		}

		public function hide () : void
		{
			this.alpha = 0;
			this.visible = false;
		}
		
		public function dim () : void
		{
			if ( !this.visible ) this.alpha = 0;
			TweenFilterLite.to( this, .5, { autoAlpha : .4 } );
			this.mouseEnabled = false;
			
			isDimmed = true;
		}
		
		public function setLabel(label:String) :void {
			_label.text = label;
			_label.setTextFormat(format);
		}
	}
	
}
