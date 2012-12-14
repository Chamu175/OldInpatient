package customMadness
{
	import asfiles.MyEvent;
	
	import com.danielfreeman.extendedMadness.UICheckBox;
	import com.danielfreeman.extendedMadness.UITick;
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.Colour;
	import com.danielfreeman.madcomponents.MadSprite;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class UIRadioButtonJT extends MadSprite
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
		protected var _state:Boolean = false;
		protected var _onColour:uint = ON_COLOUR;
		protected var _offColour:uint;
		protected var _alt:Boolean = false;
		public var _label2:UILabelJT;
		public static const TOGGLE:String = "toggle";
		
		public function UIRadioButtonJT(screen:Sprite, xml:XML, attributes:Attributes)
		{
			screen.addChild(this);
			_alt = xml.@alt.length()>0 && xml.@alt[0]!="false";
			_colour = attributes.backgroundColours.length>0 ? attributes.backgroundColours[0] : COLOUR;
			_onColour = attributes.backgroundColours.length>1 ? attributes.backgroundColours[1] : ON_COLOUR;
			_offColour = Colour.darken(_colour,-90);
			
			buttonChrome();
			state = xml.@state=="true";
			buttonMode = mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			_label2 = new UILabelJT(this, (_alt ? ALT_SIZE+SMALL_GAP  : SIZE+GAP), 0, xml.toString());
			assignToLabel(xml, _label2);
			screen.addEventListener(TOGGLE, toggle);
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
		
		protected function toggle(event:MyEvent):void {
			_state = event.parameters[0] == this;
			buttonChrome();
		}
		
		protected function buttonChrome():void {
			var matr:Matrix = new Matrix();
			var gradient:Array = [Colour.lighten(_colour,80),Colour.darken(_colour),Colour.darken(_colour)];
			var size:Number = _alt ? ALT_SIZE : SIZE;
			
			matr.createGradientBox(size/2, size/2, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, size+GAP, size);
			graphics.beginFill(_offColour);
			graphics.drawCircle(size/2, size/2, size/2);
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.drawCircle(size/2, size/2, size/2-1);
			
			var colour:uint = _state ? _onColour : Colour.darken(_colour,-128);
			graphics.beginGradientFill(GradientType.RADIAL, [colour,Colour.lighten(colour)], [1.0,1.0], [0x00,0xff], matr);
			graphics.drawCircle(size/2, size/2, size/4);
		}
		
		protected function redraw():void {
			parent.dispatchEvent(new MyEvent(TOGGLE, this));
			buttonChrome();
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