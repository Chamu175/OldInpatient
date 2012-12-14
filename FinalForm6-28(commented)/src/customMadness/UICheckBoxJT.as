package customMadness
{
	import com.danielfreeman.extendedMadness.UICheckBox;
	import com.danielfreeman.extendedMadness.UITick;
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class UICheckBoxJT extends MadSprite
	{
		protected static const SIZE:Number = 35;
		protected static const ALT_SIZE:Number = 18.0;
		protected static const CURVE:Number = 6.0;
		protected static const ON:Number = 6.0;
		protected static const ON_COLOUR:uint=0xFFF999;
		protected static const COLOUR:uint = 0xFCFCFC;
		protected static const GAP:Number = 10.0;
		protected static const SMALL_GAP:Number = 4.0;
		
		protected var _colour:uint = COLOUR;
		protected var _tick:UITickJT;
		protected var _state:Boolean = false;
		protected var _onColour:uint = ON_COLOUR;
		protected var _offColour:uint;
		protected var _alt:Boolean = false;
		public var _label2:UILabelJT;
		
		public function UICheckBoxJT(screen:Sprite, xml:XML, attributes:Attributes)
		{
			screen.addChild(this);
			_alt = xml.@alt.length()>0 && xml.@alt[0]!="false";
			_colour = attributes.backgroundColours.length>0 ? attributes.backgroundColours[0] : COLOUR;
			_onColour = attributes.backgroundColours.length>1 ? attributes.backgroundColours[1] : ON_COLOUR;
			_offColour = Colour.darken(_colour,-90);
			
			buttonChrome();
			makeTick();
			state = xml.@state=="true";
			buttonMode = mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_label2 = new UILabelJT(this, (_alt ? ALT_SIZE+SMALL_GAP  : 35+GAP), 0, xml.toString());
			assignToLabel(xml, _label2);
		}
		
		protected function assignToLabel(xml:XML, label:UILabelJT):void {
			if (xml.hasComplexContent()) {
				var xmlString:String = xml.toXMLString();
				var htmlText:String = xmlString.substring(xmlString.indexOf(">")+1,xmlString.lastIndexOf("<"));
				
				label.htmlText = htmlText;
				if (label.text=="") {
					label.text=" ";
				}
			}
			label.y = Math.max(((_alt ? ALT_SIZE : SIZE) - label.height)/2,0);
		}
		
		/**
		 * Get label component
		 */
		public function get label2():UILabelJT {
			return _label2;
		}
		
		/**
		 * Set label text
		 */
		public function set text(value:String):void {
			_label2.text = value;
			label2.y = Math.max((SIZE - label2.height)/2,0);
		}
		
		/**
		 * Set label html text
		 */
		public function set htmlText(value:String):void {
			_label2.htmlText = value;
			label2.y = Math.max((SIZE - label2.height)/2,0);
		}
		
		
		protected function makeTick():void {
			var shadow:UITickJT = new UITickJT(this,3,2,Colour.darken(_colour,-128),true);
			_tick = new UITickJT(this,4,2,_offColour,true);
			if (_alt) {
				_tick.scaleX = _tick.scaleY = shadow.scaleX = shadow.scaleY = ALT_SIZE/SIZE;
				_tick.x = 2.5;shadow.x=2.0;
				_tick.y=shadow.y = 1.0;
			}
		}
		
		
		protected function buttonChrome():void {
			var matr:Matrix = new Matrix();
			var gradient:Array = [Colour.lighten(_colour,80),Colour.darken(_colour),Colour.darken(_colour)];
			var size:Number = _alt ? ALT_SIZE : SIZE;
			
			matr.createGradientBox(size, size, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, size + GAP, size);
			graphics.beginFill(Colour.darken(_colour,-80));
			graphics.drawRoundRect(0, 0, size, size, CURVE);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.drawRoundRect(1, 1, size-2, size-2, CURVE);
		}
		
		
		protected function redraw():void {
			_tick.colour = _state ? _onColour : _offColour;
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			_state = !_state;
			redraw();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Set tickbox state
		 */
		public function set state(value:Boolean):void {
			_state = value;
			redraw();
		}
		
		/**
		 * Get tickbox state
		 */
		public function get state():Boolean {
			return _state;
		}
		
		
		public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
		}
	}
}