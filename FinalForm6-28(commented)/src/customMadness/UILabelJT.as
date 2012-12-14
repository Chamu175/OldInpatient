package customMadness
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class UILabelJT extends TextField
	{
		public static var FORMAT:TextFormat = new TextFormat("_sans",23,0x333333);
		
		public function UILabelJT(screen:Sprite,xx:int,yy:int,txt:String = "",format:TextFormat=null) {
			screen.addChild(this);
			x=xx;y=yy;
			mouseEnabled=multiline=selectable=false;
			type=TextFieldType.DYNAMIC;
			autoSize=TextFieldAutoSize.LEFT;
			if (format==null) format=FORMAT;
			defaultTextFormat=format;height=10;
			if (txt=="")
				text=" ";
			else
				text=txt;
		}
		
		/**
		 *  Set width of label
		 */
		public function set fixwidth(value:Number):void {
			multiline=wordWrap = true;
			width = value;
		}
		
		/**
		 *  Set height of multi-line label
		 */
		public function set fixheight(value:Number):void {
			autoSize=TextFieldAutoSize.NONE;
			multiline=wordWrap = true;
			height = value;
		}
		
		/**
		 *  Set html text
		 */
		override public function set htmlText(value:String):void {
			super.htmlText = value;
			defaultTextFormat = this.getTextFormat();
		}
	}
}