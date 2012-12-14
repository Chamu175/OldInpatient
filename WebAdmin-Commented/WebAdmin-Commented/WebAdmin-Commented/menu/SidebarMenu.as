package menu {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import flash.text.TextFormat;
	import ui.UIButton;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import com.greensock.*;
	import flash.events.Event;
	
	public class SidebarMenu extends Sprite{

		private var square:Sprite;
		public var selectedRb:int;
		private var closeMenu:CloseMenu;
		private var openMenu:OpenMenu;
		private var export:UIButton;
		private var newMap:UIButton;
		private var clearMap:UIButton;
		private var floorText:TextField;

		public function SidebarMenu() {
			init();
		}
		
		private function init() :void {
			//radio button menu
			var wallRb:RadioButton = new RadioButton();
			var restroomRb:RadioButton = new RadioButton();
			var elevatorRb:RadioButton = new RadioButton();
			var informationRb:RadioButton = new RadioButton();
			var stairsRb:RadioButton = new RadioButton();
			var waitingRb:RadioButton = new RadioButton();
			var emptyRb:RadioButton = new RadioButton();
			var rbGrp:RadioButtonGroup = new RadioButtonGroup("mapGrp");
			
			square = new Sprite();
			addChild(square);
			square.graphics.lineStyle(3,0x333333);
			square.graphics.beginFill(0xA2ABA5);
			square.graphics.drawRect(0,0,115,430);
			square.graphics.endFill();
			
			closeMenu =  new CloseMenu();
			closeMenu.x = -(closeMenu.width);
			closeMenu.y = square.height / 2 - closeMenu.height / 2;
			closeMenu.addEventListener(MouseEvent.CLICK, hideMenu);

			openMenu = new OpenMenu();
			openMenu.x = -(closeMenu.width);
			openMenu.y = square.height / 2 - closeMenu.height / 2;
			openMenu.visible = false;
			
			square.addChild(closeMenu);
			square.addChild(openMenu);
			square.addChild(wallRb);
			square.addChild(restroomRb);
			square.addChild(elevatorRb);
			square.addChild(informationRb);
			square.addChild(stairsRb);
			square.addChild(waitingRb);
			square.addChild(emptyRb);

			//values correspond to frame of Box movieclip (Wall is frame 8, etc)
			wallRb.label = "Wall";
			wallRb.value = 8;
			restroomRb.label = "Restroom";
			restroomRb.value = 5;
			elevatorRb.label = "Elevator";
			elevatorRb.value = 3;
			informationRb.label = "Info Desk";
			informationRb.value = 4;
			stairsRb.label = "Stairs";
			stairsRb.value = 6;
			waitingRb.label = "Waiting Room";
			waitingRb.value = 7;
			emptyRb.label = "Clear Space";
			emptyRb.value = 1;
			wallRb.group = restroomRb.group = elevatorRb.group = informationRb.group = stairsRb.group = waitingRb.group = emptyRb.group = rbGrp;
			wallRb.move(5, 80);
			restroomRb.move(5, 115);
			elevatorRb.move(5, 150);
			informationRb.move(5, 185);
			stairsRb.move(5, 220);
			waitingRb.move(5, 255);
			emptyRb.move(5, 290);
			
			export = new UIButton(50, 35, "Export", 0xFF0000, 14);
			export.x = square.width / 2 - 5;
			export.y = 390;
			export.addEventListener(UIButton.CLICKED, exportXML);
			square.addChild(export);

			newMap = new UIButton(100, 35, "New Floor", 0x000000, 14);
			newMap.x = square.width / 2 - newMap.width / 2 - 7;
			newMap.y = 335;
			newMap.addEventListener(UIButton.CLICKED, newFloor);
			square.addChild(newMap);
			
			clearMap = new UIButton(50, 35, "Clear", 0xFF6600, 14);
			clearMap.x = square.width / 2 - clearMap.width - 10;
			clearMap.y = 390;
			clearMap.addEventListener(UIButton.CLICKED, clearGrid);
			square.addChild(clearMap);
			
			var floorIndicator:FloorBtn = new FloorBtn();
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 45;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.color = 0xFFFFFF;
			floorText = new TextField();
			floorText.text = "1";
			floorIndicator.x = 22;
			floorIndicator.y = 5;
			floorText.setTextFormat(textFormat);
			floorText.width = floorIndicator.width;
			floorText.height =  47;
			floorText.x = (floorIndicator.width / 2) - (floorText.width / 2) + 11;
			floorText.y = (floorIndicator.height / 2) - (floorText.height / 2) + 6;
			floorIndicator.addChild(floorText);
			square.addChild(floorIndicator);

			rbGrp.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clearGrid(event:Event):void {
			dispatchEvent(new Event("ON_MAP_CLEAR"));
		}
		
		//changes selectedRb variable that is passed on each grid square click
		function clickHandler(event:MouseEvent):void {
			selectedRb = event.target.selection.value;
		}
		
		public function hideMenu(event:MouseEvent=null):void {
			TweenLite.to(square, 1, {x:square.width - closeMenu.width});
			closeMenu.removeEventListener(MouseEvent.CLICK, hideMenu);
			openMenu.addEventListener(MouseEvent.CLICK, showMenu);
			closeMenu.visible = false;
			openMenu.visible = true;
		}
		
		public function showMenu(event:MouseEvent=null):void {
			TweenLite.to(square, 1, {x:0});
			openMenu.removeEventListener(MouseEvent.CLICK, showMenu);
			closeMenu.addEventListener(MouseEvent.CLICK, hideMenu);
			closeMenu.visible = true;
			openMenu.visible = false;
		}
		
		private function newFloor(event:Event):void {
			dispatchEvent(new Event("CREATE_NEW_FLOOR"));
		}
		
		private function exportXML(event:Event):void {
			dispatchEvent(new Event("EXPORT_XML"));
		}
		
		//resets textformat for Current Floor, because needs to be set everytime you change a textfield
		public function setFloor(floor:int):void {
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 45;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.color = 0xFFFFFF;
			floorText.text = floor.toString();
			floorText.setTextFormat(textFormat);
		}
	}
	
}
