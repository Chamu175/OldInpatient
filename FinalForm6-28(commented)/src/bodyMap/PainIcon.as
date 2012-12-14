package bodyMap
{
	import com.greensock.TweenMax;
	
	import events.IconDragEvent;
	
	import flash.desktop.Icon;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	
	public class PainIcon extends Sprite
	{
		[Embed(source="assets/bodyMap/glow.png")]
		private var Glow:Class;
		
		public static const ICON_GRABBED:String = "iconGrabbed"; 
		
		private var _class:Class
		private var bounds:Rectangle;
		private var line:Sprite = new Sprite();
		private var _type:String;
		private var _dropCount:int = 0;
		
		//variables to store data for icon
		private var _painIntensity:int = 0;
		private var _painLength:int = 0;
		private var _painTime:String = "hours";
		private var _xPercent:Number;
		private var _yPercent:Number;
		public var index:int;
		public var iconSide:String;
		private var glowImage:Bitmap;

		private var bitmap:Bitmap;

		private var tmr:Timer;
		
		public function PainIcon(c:Class, type:String, dragBounds:Rectangle)
		{
			_class = c;
			_type = type;
			bounds = dragBounds;
			init();
		}

		private function init():void {
			glowImage = new Glow;
			glowImage.alpha = 0;
			glowImage.x = -12.5;
			glowImage.y = -12.5;
			this.addChild(glowImage);
			bitmap = new _class;
			this.addChild(bitmap);
			this.addEventListener(MouseEvent.MOUSE_DOWN, startIconDrag);
			this.addEventListener(MouseEvent.MOUSE_UP, stopIconDrag);
		}
		
		protected function startIconDrag(event:MouseEvent):void
		{
			
			
			/*tmr = new Timer(500, 1);
			tmr.addEventListener(TimerEvent.TIMER_COMPLETE, yesDrag);
			tmr.start();*/
			
			this.startDrag(false, bounds);
			
			//dispatch event saying new icon is grabbed (is also dispatched if icon is quickly touched, in order to turn off glow of previous icon and select current)
			dispatchEvent(new IconDragEvent(IconDragEvent.DRAG, this, true));
			
			startGlow();
		}
		
		protected function yesDrag(event:TimerEvent=null):void {
			/*line.y = 0;
			line.alpha = 1;
			line.graphics.clear();
			line.graphics.lineStyle(10, 0xCDCD00, 1);
			line.graphics.moveTo(bitmap.width / 2, bitmap.height / 2 - 5);
			line.graphics.lineTo(bitmap.width / 2, bitmap.height / 2 - 5);
			line.graphics.lineTo(bitmap.width / 2, 125);
			line.graphics.endFill();
			line.scaleY = 0;
			addChildAt(line, 0);
			TweenLite.to(line, .4, {scaleY:1});*/
			
		}
		
		protected function stopIconDrag(event:MouseEvent):void
		{
			
			//tween with line
			/*TweenLite.to(this, .4, {y:this.y + line.height - 10});
			TweenLite.to(line, .4, {y:-(line.height), alpha:0});*/
			this.stopDrag();
			
			dropCount++;
			dispatchEvent(new IconDragEvent(IconDragEvent.DROP, this, true));
			
			/*tmr.stop();
			tmr.reset();*/
		}
		
		public function startGlow():void {
			TweenLite.to(glowImage, .3, {alpha:1});
		}
		
		public function stopGlow():void {
			TweenLite.to(glowImage, .3, {alpha:0});
		}
		
		public function get dropCount():int
		{
			return _dropCount;
		}
		
		public function set dropCount(value:int):void
		{
			_dropCount = value;
		}
		
		public function get yPercent():Number
		{
			return _yPercent;
		}
		
		public function set yPercent(value:Number):void
		{
			_yPercent = value;
		}
		
		public function get xPercent():Number
		{
			return _xPercent;
		}
		
		public function set xPercent(value:Number):void
		{
			_xPercent = value;
		}
		
		public function get painTime():String
		{
			return _painTime;
		}
		
		public function set painTime(value:String):void
		{
			_painTime = value;
		}
		
		public function get painLength():int
		{
			return _painLength;
		}
		
		public function set painLength(value:int):void
		{
			_painLength = value;
		}
		
		public function get painIntensity():int
		{
			return _painIntensity;
		}
		
		public function set painIntensity(value:int):void
		{
			_painIntensity = value;
		}
		
		public function get type():String
		{
			return _type;
		}
	}
}