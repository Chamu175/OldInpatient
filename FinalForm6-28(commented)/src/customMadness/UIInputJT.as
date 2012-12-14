package customMadness
{
	import com.danielfreeman.madcomponents.UIBlueText;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	/**
	 * The input has lost input focus
	 */
	[Event( name="focusOut", type="flash.events.FocusEvent" )]
	
	/**
	 * The text has changed
	 */
	[Event( name="textInput", type="flash.events.TextEvent" )]
	
	public class UIInputJT extends Sprite
	{
		
		protected static const SHADOW_OFFSET:Number = 1.0;
		protected static const FORMAT:TextFormat = new TextFormat("_sans", 20, 0x333333);
		protected static const WIDTH:Number = 80.0;
		protected static const CURVE:Number = 16.0;
		protected static const SIZE_X:Number = 10.0;
		protected static const SIZE_Y:Number = 7.0;
		protected static const SIZE_ALT:Number = 4.0;
		protected static const COLOUR:uint = 0x333339;
		protected static const SHADOW_COLOUR:uint = 0xAAAAAC;
		protected static const BACKGROUND:uint = 0xF0F0F0;
		
		protected var _format:TextFormat = FORMAT;
		protected var _label:*; //UIBlueText;
		protected var _colours:Vector.<uint>;
		protected var _fixwidth:Number = WIDTH;
		protected var _alt:Boolean;
		
		public function UIInputJT(screen:Sprite, xx:Number, yy:Number, text:String, colours:Vector.<uint> = null, alt:Boolean = false, prompt:String="", promptColour:uint = 0x999999)
		{
			screen.addChild(this);
			x=xx;y=yy;
			_alt = alt;
			_colours = colours ? colours : new <uint>[];
			inputField = new UIBlueText(this, alt ? SIZE_ALT : SIZE_X, (alt ? SIZE_ALT : SIZE_Y) + 1, prompt, -1, _format, prompt!="", promptColour);
			if (XML(text).hasSimpleContent())
				_label.text = text;
			else
				_label.htmlText = XML(text).children()[0].toXMLString();
			if (_colours.length>4 && _label.hasOwnProperty("highlightColour")) {
				_label.highlightColour = _colours[4];
			}
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		/**
		 *  By default, the input field is based on flash.text.TextField.  This allows you to specify an alternative object such as TLFTextField
		 */
		public function set inputField(value:*):void {
			if (_label) {
				_label.removeEventListener(Event.CHANGE,textChanged);
				_label.removeEventListener(FocusEvent.FOCUS_OUT,focusOut);
				removeChild(_label);
			}
			_label = value;
			_label.fixwidth = _fixwidth - 2 * (_alt ? SIZE_ALT : SIZE_X);
			_label.addEventListener(Event.CHANGE,textChanged);
			_label.addEventListener(FocusEvent.FOCUS_OUT,focusOut);
			drawOutline();
		}
		
		
		public function get inputField():* {
			return _label;
		}
		
		
		protected function focusOut(event:FocusEvent):void {
			dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
		}
		
		
		protected function textChanged(event:Event):void {
			dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT));
			event.stopPropagation();
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			drawOutline(true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			drawOutline();
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		/**
		 *  Set text of input
		 */
		public function set text(value:String):void {
			_label.text = value;
			drawOutline();
		}
		
		/**
		 *  Set html text of input
		 */
		public function set htmlText(value:String):void {
			_label.htmlText = value;
			drawOutline();
		}
		
		
		public function get text():String {
			return _label.text;
		}
		
		/**
		 *  Width of input field
		 */
		public function set fixwidth(value:Number):void {
			_fixwidth = value;
			_label.fixwidth = value - 2 * (_alt ? SIZE_ALT : SIZE_X);
			drawOutline();
		}
		
		
		public function focus():void {
			stage.focus = _label;
		}
		
		/**
		 *  Draw input field chrome
		 */
		protected function drawOutline(pressed:Boolean = false):void {
			var height:Number = _label.height + 2 * (_alt ? SIZE_ALT : SIZE_Y);
			graphics.clear();
			if (_colours.length > 3) {
				graphics.beginFill(_colours[3]);
				graphics.drawRect(0, 0, _fixwidth, height+1);
			}
			graphics.beginFill(_colours.length > 0 ? _colours[0] : COLOUR);
			graphics.drawRoundRect(0, 0, _fixwidth, height, CURVE);
			graphics.beginFill(_colours.length > 2 ? _colours[2] : SHADOW_COLOUR);
			graphics.drawRoundRect(1, 1, _fixwidth-2, height-2, CURVE-1);
			graphics.beginFill(_colours.length > 1 ? _colours[1] : BACKGROUND);
			graphics.drawRoundRect(2.5, 3, _fixwidth-3.5, height-4, CURVE-2);
		}
		
		
		/**
		 *  Stage rectangle
		 */             
		public function stageRect():Rectangle {
			var leftTop:Point = _label.localToGlobal(new Point(0,0));
			var rightBottom:Point = _label.localToGlobal(new Point(_label.width,_label.height));
			return new Rectangle(leftTop.x, leftTop.y, rightBottom.x - leftTop.x, rightBottom.y - leftTop.y);
		}
		
		
		public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_label.removeEventListener(Event.CHANGE,textChanged);
			_label.removeEventListener(FocusEvent.FOCUS_OUT,focusOut);
			_label.destructor();
		}
	}
}