package ui {
	
	import flash.display.Sprite;
	import gs.TweenFilterLite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.danielfreeman.madcomponents.UIList;
	import com.danielfreeman.madcomponents.Attributes;
	import ui.UIListMaker;
	import flash.sampler.StackFrame;
	
	public class CreateName extends Sprite{
		
		protected var bg:Sprite = new Sprite();
		private var doneSprite:Sprite = new Sprite();
		private var done:TextField = new TextField();
		protected var _width:int;
		protected var _height:int;
		protected var inputField:TextField;
		protected var textLabel:TextField = new TextField();
		protected var format:TextFormat = new TextFormat();
		private var radio1:RadioButton;
		private var radio2:RadioButton;
		private var radioGroup:RadioButtonGroup;
		private var box:Sprite;
		private var _data:Array = new Array();
		private var list:UIListMaker;
		public var _itemClicked:int = -1;
		
		protected var inputField2:TextField;
		protected var textLabel2:TextField = new TextField();
		protected var textLabel3:TextField = new TextField();
		
		public function CreateName(w:Number, h:Number, xPos:Number, yPos:Number, _data:Array=null) {
			super();
			this.x = xPos;
			this.y = yPos;
			_width = w;
			_height = h;
			this.alpha = 0;
			this._data = _data;
			drawUI();
		}
		
		private function drawUI() :void {
			bg.graphics.clear();
			bg.graphics.beginFill(0x990000);
			bg.graphics.drawRect(0, 0, _width, _height); // x, y, width, height, ellipseW, ellipseH
			bg.graphics.endFill();
			addChildAt(bg, 0);
			
			format.color = 0xFFFFFF;
			
			radio1 = new RadioButton();
			radio2 = new RadioButton();
			
			radioGroup = new RadioButtonGroup("group1");
			radio1.group = radioGroup;
			radio1.label = "Patient";
			radio1.setStyle("textFormat", format);
			radio1.selected = true;
			radio2.group = radioGroup;
			radio2.label = "Department";
			radio2.setStyle("textFormat", format);
			radio2.width = 150;
			
			radio1.addEventListener(MouseEvent.CLICK, tweenBG);
			radio2.addEventListener(MouseEvent.CLICK, tweenBG);
			
			radio1.move(5, 25);
			radio2.move(100, 25);
			
			addChild(radio1);
			addChild(radio2);
			
			format.size = 16;
			format.color = 0xFFFFFF;
			
			var maskList:Sprite = new Sprite();
			maskList.graphics.beginFill(0x000000);
			maskList.graphics.drawRect(5, 90, _width - 10, 210);
			maskList.graphics.endFill();
			bg.addChild(maskList);
			
			list = new UIListMaker(bg, 5, 90, _width - 10, 210, 'background="#CCCCFF, #9999CC, #AAAACC"');
			list.data = _data;
			list.mask = maskList;
			list.addEventListener(UIList.CLICKED, onListChange);
			
			textLabel.text = "Selected person: None";
			textLabel.width = _width - 5;
			textLabel.height = 45;
			textLabel.wordWrap = true;
			textLabel.x = 5;
			textLabel.y = 60;
			textLabel.selectable = false;
			textLabel.setTextFormat(format);
			addChild(textLabel);
			
			var listBG:Sprite = new Sprite();
			listBG.graphics.beginFill(0x690000);
			listBG.graphics.drawRect(0, 55, _width, 250);
			listBG.graphics.endFill();
			bg.addChildAt(listBG, 0);
			
			textLabel2.text = "Enter message you would like to send:";
			textLabel2.width = _width;
			textLabel2.height = 25;
			textLabel2.x = 5;
			textLabel2.y = 305;
			textLabel2.selectable = false;
			textLabel2.setTextFormat(format);
			addChild(textLabel2);
			
			inputField2 = new TextField();
			addChild(inputField2);
			inputField2.border = true;
			inputField2.wordWrap = true;
			inputField2.width = _width - 10;
			inputField2.height = 50;
			inputField2.x = 5;
			inputField2.y = 330;
			inputField2.type = "input";
			inputField2.background = true;
			inputField2.backgroundColor = 0xFFFFFF;
			
			textLabel3.text = "What is this QR code for?";
			textLabel3.width = _width;
			textLabel3.height = 20;
			textLabel3.x = 5;
			textLabel3.y = 0;
			textLabel3.selectable = false;
			textLabel3.setTextFormat(format);
			addChild(textLabel3);
			
			doneSprite.graphics.clear();
			doneSprite.graphics.beginFill(0x690000)
			doneSprite.graphics.drawRect(0,0, _width, 35);
			doneSprite.graphics.endFill();
			addChild(doneSprite);
			doneSprite.y = bg.height - 35;
			doneSprite.buttonMode = true;
			doneSprite.addEventListener(MouseEvent.CLICK, closeThis);
			
			done.text = "Done";
			done.selectable = done.mouseEnabled = false;
			doneSprite.addChild(done);
			done.width = 50;
			done.x = _width / 2 - done.width / 2;
			done.y = 5;
			done.setTextFormat(format);
			
			TweenFilterLite.to( this, .5, { autoAlpha : 1 } );
		}
		
		//fires when user selects an item from the list
		private function onListChange(event:Event):void {
			_itemClicked = list.index;
			
			textLabel.text = "Selected person: " + list.row.toString();
			textLabel.setTextFormat(format);
		}
		
		private function closeThis(event:MouseEvent) :void {
			dispatchEvent(new Event("Closed", true));
		}
		
		private function setAlpha() :void {
			if(textLabel2.alpha == 1) {
				textLabel2.alpha = 0;
				inputField2.alpha = 0;
				doneSprite.alpha = 0;
				list.alpha = 0;
			}
			else {
				textLabel2.alpha = 1;
				inputField2.alpha = 1;
				doneSprite.alpha = 1;
				list.alpha = 1;
			}
		}
		
		private function tweenBG(event:MouseEvent) :void {
			if(bg.height != 400) {
				TweenFilterLite.to( bg, .5, { height:400, onComplete:setAlpha} );
			}
			
			if(radioGroup.selection.label == "Patient") {
				textLabel2.text = "Enter message you would like to send:";
				textLabel2.setTextFormat(format);
			}
			else if(radioGroup.selection.label == "Department") {
				textLabel2.text = "Enter the name of the Department:";
				textLabel2.setTextFormat(format);
			}
		}
		
		public function returnRadio() :String {
			var str:String;
			try {
				str = radioGroup.selection.label;
			}
			catch(e:Error) {
				str = "wrong";
			}
				
			return str;
		}
		
		public function returnInput1() :String {
			return inputField.text;
		}
		
		public function returnInput2() :String {
			return inputField2.text;
		}

	}
	
}
