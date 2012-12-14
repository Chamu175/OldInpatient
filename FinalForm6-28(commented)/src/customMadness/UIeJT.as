package customMadness
{
	import com.danielfreeman.extendedMadness.UIe;
	import com.danielfreeman.madcomponents.UI;
	
	import flash.display.Sprite;
	
	public class UIeJT extends UIe
	{
		public static function createCustom(screen:Sprite, xml:XML, width:Number = -1, height:Number = -1):Sprite
		{
			if (!_cursor)
				activate(screen);
			UI.FormClass = UIFormJT;
			UI.extend(["checkBoxJT","radioButtonJT"],[UICheckBoxJT, UIRadioButtonJT]);
			var result:Sprite = UI.create(screen, xml, width, height);
			listListener(result, xml);
			screen.setChildIndex(_cursor, screen.numChildren - 1);
			return result;
		}
		
		public static function redraw():Sprite {
			return create(_screen, UIFormJT(_root).xml);
		}
	}
}