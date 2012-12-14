package customMadness
{
	import com.danielfreeman.madcomponents.UILabel;
	
	import events.LabelTouchEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class UITouchLabel extends UILabelJT
	{
		[Embed(source="assets/questionCircle.png")]
		private static const QUESTION:Class;
		
		public var id:String;
		public function UITouchLabel(screen:Sprite, xx:int, yy:int, txt:String="", id:String = "", format:TextFormat=null)
		{
			txt = "     " + txt;
			super(screen, xx, yy, txt, format);
			
			var q:Bitmap = new QUESTION();
			q.x = 2;
			q.y = this.height / 2 - q.height / 2;
			var s:Sprite = new Sprite();
			s.addChild(q);
			parent.addChild(s);
			
			this.id = id;
			var timer:Timer = new Timer(50, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, addExtras);
			timer.start();
		}
		
		protected function addExtras(event:TimerEvent):void
		{
			this.selectable = true;
			this.mouseEnabled = true;
			/*this.background = true;
			this.backgroundColor = 0x0e5d8e;*/
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x0e5d8e, .4);
			bg.graphics.drawRoundRect(0,0,this.width,this.height,10);
			bg.graphics.endFill();
			parent.addChildAt(bg,0);
			
			this.addEventListener(MouseEvent.CLICK, throwTouchEvent);
		}
		
		protected function throwTouchEvent(event:MouseEvent):void
		{
			dispatchEvent(new LabelTouchEvent(LabelTouchEvent.CUSTOM_EVENT, this, true));
		}
	}
}