package customClasses
{
	import events.CustomIndexEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	
	public class CalloutHelpMenu extends Sprite
	{
		[Embed(source="assets/question.png")]
		private static const Help:Class;
		[Embed(source="assets/questionPressed.png")]
		private static const HelpPressed:Class;
		
		private var menuHolder:Sprite;
		private var menu:SimpleImageButton;
		private var timer:Timer;
		private var btnLabels:Array;
		private var buttons:Array;
		private var _index:int;
		
		public function CalloutHelpMenu(buttonLabels:Array)
		{
			
			btnLabels = buttonLabels;
			
			menuHolder = new Sprite();
			addChild(menuHolder);
			
			init();
			
			index = 0;
			menu = new SimpleImageButton("", 0, Help, HelpPressed);
			addChild(menu);
			
			menu.addEventListener(MouseEvent.CLICK, showMenu);
		}
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
			
			dispatchEvent(new Event(Event.CHANGE, true));
			
			for (var i:int = 0; i < buttons.length; i++) 
			{
				buttons[i].setUnPressed();
			}
			buttons[value].setPressed();
		}

		private function init() :void {
			buttons = new Array();
			for (var i:int = 0; i < btnLabels.length; i++) 
			{
				var button:SimpleImageButton = new SimpleImageButton(btnLabels[i], i);
				button.x = i * button.width;
				button.addEventListener(CustomIndexEvent.CUSTOM_EVENT, resetTimer);
				buttons.push(button);
				menuHolder.addChild(button);
			}
			
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x0e5d8e);
			bg.graphics.drawRect(0,0, menuHolder.width, menuHolder.height);
			bg.graphics.endFill();
			menuHolder.addChildAt(bg, 0);
			
			buttons[0].setPressed();
			menuHolder.alpha = 0;
		}
		
		protected function resetTimer(event:CustomIndexEvent):void
		{
			if(timer) {
				timer.reset();
				timer.start();
			}
			
			index = event.index;
			
			for (var i:int = 0; i < buttons.length; i++) 
			{
				buttons[i].setUnPressed();
			}
			buttons[event.index].setPressed();
			
		}
		
		protected function showMenu(event:MouseEvent):void
		{
			TweenLite.to(menuHolder, 1 ,{x:menu.x - menuHolder.width, alpha:1});
			menu.setPressed();
			
			menu.removeEventListener(MouseEvent.CLICK, showMenu);
			menu.addEventListener(MouseEvent.CLICK, hideMenuClick);
			
			timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, hideMenu);
			timer.start();
		}
		
		protected function hideMenuClick(event:MouseEvent):void
		{
			menu.addEventListener(MouseEvent.CLICK, showMenu);
			menu.removeEventListener(MouseEvent.CLICK, hideMenuClick);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideMenu);
			
			TweenLite.to(menuHolder, .5 ,{x:menu.x, alpha:0});
			menu.setUnPressed();
		}
		
		protected function hideMenu(event:TimerEvent):void
		{
			TweenLite.to(menuHolder, .5 ,{x:menu.x, alpha:0});
			menu.setUnPressed();
			
			menu.addEventListener(MouseEvent.CLICK, showMenu);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideMenu);
		}
	}
}