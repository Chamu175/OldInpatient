//used for drop down list that holds all patients

package ui {
	
	import com.danielfreeman.madcomponents.Attributes;
    import com.danielfreeman.madcomponents.UIList;
	import flash.display.Sprite;

	public class UIListMaker extends UIList {

		public function UIListMaker(screen:Sprite, xx:Number, yy:Number, width:Number, height:Number, style:String = "", renderer:String = "") {
			x = xx;
			y = yy;
			var attributes:Attributes = new Attributes(0, 0, width, height);
			var xml:XML = XML('<list '+(style!="" ? style : '') + '><font '+ style + '/>' + (renderer!="" ? '<' + renderer + '/>' : '') +'</list>');
			attributes.parse(xml);
			super(screen, xml, attributes);
		}
	}
}
