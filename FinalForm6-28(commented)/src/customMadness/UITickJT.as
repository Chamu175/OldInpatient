package customMadness
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	
	public class UITickJT extends MadSprite
	{
		public static const SIZE:Number = 27.0;
		public static const HEAD:Number = 6.0;
		protected static const HEIGHT:Number = SIZE - HEAD + WIDTH;             
		protected static const WIDTH:Number = 4.0;
		
		protected var _width:Number = WIDTH;
		
		public function UITickJT(screen:Sprite, xx:Number, yy:Number, colour:uint, alt:Boolean = false)
		{
			screen.addChild(this);
			x=xx;y=yy;
			clickable = mouseEnabled = false;
			if (alt)
				_width = 6;
			this.colour = colour;
		}
		
		public function set colour(value:uint):void {
			graphics.clear();
			graphics.beginFill(value);
			graphics.moveTo(0, HEIGHT-HEAD);
			graphics.lineTo(0, HEIGHT-HEAD+_width);
			graphics.lineTo(HEAD, HEIGHT+_width);
			graphics.lineTo(SIZE, _width);
			graphics.lineTo(SIZE, 0);
			graphics.lineTo(HEAD, HEIGHT);
			graphics.lineTo(0, HEIGHT-HEAD);
		}
		
		/**
		 *  Set the visibility of the tick "true" or "false"
		 */     
		public function set text(value:String):void {
			visible = value!="false";
		}
	}
}