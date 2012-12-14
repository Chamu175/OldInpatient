package bodyMap
{
	import bodyMap.PainIcon;
	
	import com.danielfreeman.madcomponents.UIWindow;
	
	import customClasses.UIButtonMobile;
	
	import customMadness.UIInputJT;
	import customMadness.UILabelJT;
	import customMadness.UISliderLA;
	
	import events.IconDragEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	
	import mx.controls.Text;
	
	public class BodyMap extends Sprite
	{
		private static const MENU_HEIGHT:int = 250;
		
		[Embed(source="assets/bodyMap/maleFront.png")]
		private var MaleFront:Class;
		
		[Embed(source="assets/bodyMap/maleBack.png")]
		private var MaleBack:Class;
		
		[Embed(source="assets/bodyMap/femaleFront.png")]
		private var FemaleFront:Class;
		
		[Embed(source="assets/bodyMap/femaleBack.png")]
		private var FemaleBack:Class;
		
		[Embed(source="assets/bodyMap/burningPain.png")]
		private var BurningPain:Class;
		
		[Embed(source="assets/bodyMap/cuttingPain.png")]
		private var CuttingPain:Class;
		
		[Embed(source="assets/bodyMap/throbbingPain.png")]
		private var ThrobbingPain:Class;
		
		[Embed(source="assets/bodyMap/trashIcon_96.png")]
		private var TrashIcon:Class;
		
		private var bodyHolder:Sprite = new Sprite();
		private var menuHolder:Sprite = new Sprite();
		private var maleBtn:UIButtonMobile;
		private var femaleBtn:UIButtonMobile;
		private var _width:int;
		private var _height:int;

		private var frontImage:Bitmap;
		private var backImage:Bitmap;
		private var front:Sprite;
		private var back:Sprite;
		private var trashIcon:Bitmap;
		
		private var sideMenu:Sprite;

		private var frontBtn:UIButtonMobile;

		private var backBtn:UIButtonMobile;
		private var bottomMenu:Sprite;

		private var bottomMenuOptions:Sprite;

		private var lengthLabel:UILabelJT;
		private var lengthLabelTime:UILabelJT;
		private var painLabel:UILabelJT;

		private var commentBtn:UIButtonMobile;
		private var finishBtn:UIButtonMobile;

		private var format:TextFormat;
		private var comment:TextField;
		private var commentFormat:TextFormat;
		private var dimBlack:Sprite;
		private var iconLabel:UILabelJT;
		private var rec:Rectangle;
		private var burningPlace:Sprite;
		private var cuttingPlace:Sprite;
		private var throbbingPlace:Sprite;
		private var painScale:UISliderLA;
		
		private var timeString:String;
		private var timeInt:int;
		private var infoLabel:UILabelJT;
		private var iconArray:Array;
		private var iconIndex:int;
		private var painLength:UISliderLA;
		private var painLength2:UISliderLA;
		private var iconId:int = 3;

		private var selectIcon:UILabelJT;
		
		public function BodyMap(w:int, h:int)
		{
			_width = w;
			_height = h;
			init();
		}
		
		private function init() :void {
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0x757A80);
			bg.graphics.drawRect(0, 0, _width, _height);
			bg.graphics.endFill();
			addChildAt(bg, 0);
			
			maleBtn = new UIButtonMobile("Male", 0x00BADC, 50, 300, 85);
			maleBtn.x = _width / 2 - maleBtn.width / 2;
			maleBtn.y = _height / 2 - maleBtn.height / 2 - 50;
			maleBtn.addEventListener(UIButtonMobile.CLICKED, bodySelcted);
			addChild(maleBtn);
			femaleBtn = new UIButtonMobile("Female", 0x00BADC, 50, 300, 85);
			femaleBtn.x = _width / 2 - femaleBtn.width / 2;
			femaleBtn.y = _height / 2 - femaleBtn.height / 2 + 50;
			femaleBtn.addEventListener(UIButtonMobile.CLICKED, bodySelcted);
			addChild(femaleBtn);
			
			addChild(bodyHolder);
			addChild(menuHolder);
		}
		
		protected function bodySelcted(event:Event):void
		{
			removeChild(maleBtn);
			removeChild(femaleBtn);
			
			front = new Sprite();
			back = new Sprite();
			switch (event.target.label) {
				case "Male":
					frontImage = new MaleFront();
					backImage = new MaleBack();
					frontImage.scaleY = (_height - MENU_HEIGHT) / frontImage.height;
					frontImage.scaleX = (_height - MENU_HEIGHT) / frontImage.height;
					backImage.scaleY = (_height - MENU_HEIGHT) / backImage.height;
					backImage.scaleX = (_height - MENU_HEIGHT) / backImage.height;
					back.alpha = 0;
					bodyHolder.addChild(front);
					bodyHolder.addChild(back);
					break;
				case "Female":
					frontImage = new FemaleFront();
					backImage = new FemaleBack();
					frontImage.scaleY = (_height - MENU_HEIGHT) / frontImage.height;
					frontImage.scaleX = (_height - MENU_HEIGHT) / frontImage.height;
					backImage.scaleY = (_height - MENU_HEIGHT) / backImage.height;
					backImage.scaleX = (_height - MENU_HEIGHT) / backImage.height;
					back.alpha = 0;
					bodyHolder.addChild(front);
					bodyHolder.addChild(back);
					break;
			}
			front.addChild(frontImage);
			back.addChild(backImage);
			
			//draw side menu rectangle
			sideMenu = new Sprite();
			sideMenu.graphics.beginFill(0x000000);
			sideMenu.graphics.drawRect(0, 0, _width - front.width, _height - MENU_HEIGHT);
			sideMenu.graphics.endFill();
			sideMenu.x = _width - sideMenu.width;
			menuHolder.addChild(sideMenu);
			
			//draw bottom menu rectangle
			bottomMenu = new Sprite();
			bottomMenu.graphics.beginFill(0x000000);
			bottomMenu.graphics.drawRect(0,0,_width,MENU_HEIGHT);
			bottomMenu.graphics.endFill();
			bottomMenu.y = _height - bottomMenu.height;
			menuHolder.addChild(bottomMenu);
			
			bottomMenuOptions = new Sprite();
			bottomMenuOptions.alpha = 0;
			bottomMenu.addChild(bottomMenuOptions);
			
			//add bottom menu sliders and labels
			format = new TextFormat();
			format.color = 0xFFFFFF;
			format.size = 20;
			timeString = "hour";
			timeInt = 0;
			var bigLabel:TextFormat = new TextFormat();
			bigLabel.size = 30;
			bigLabel.color = 0xFFFFFF;
			infoLabel = new UILabelJT(bottomMenuOptions, 5, 5, timeInt + " " + timeString + "(s) of pain", bigLabel);
			lengthLabel = new UILabelJT(bottomMenuOptions, 5, infoLabel.y + infoLabel.height + 40, "Length:", format);
			painLength = new UISliderLA(bottomMenuOptions, lengthLabel.x + bottomMenu.width / 8, lengthLabel.y - lengthLabel.height / 2, bottomMenu.width / 2 - 15);
			painLength.value = 0;
			painLength.addEventListener(Event.CHANGE, painLengthChange);
			lengthLabelTime = new UILabelJT(bottomMenuOptions, 5, painLength.y + 75, "Time:", format);
			painLength2 = new UISliderLA(bottomMenuOptions, lengthLabelTime.x  + bottomMenu.width / 8, lengthLabelTime.y - lengthLabelTime.height / 2, bottomMenu.width / 2 - 15);
			painLength2.value = 0;
			painLength2.addEventListener(Event.CHANGE, painLength2Change);
			
			//add finish buttons
			finishBtn = new UIButtonMobile("Submit", 0x00FF00, 30, bottomMenu.width / 4 + 15, 85);
			finishBtn.addEventListener(UIButtonMobile.CLICKED, finishClicked);
			bottomMenuOptions.addChild(finishBtn);
			finishBtn.x = bottomMenu.width / 2 + finishBtn.width / 2 + 30;
			finishBtn.y = bottomMenu.height / 2 - finishBtn.height / 2;
			finishBtn.visible = false;
			
			selectIcon = new UILabelJT(this, 0, 0, "Drag pain icon to appropriate area", new TextFormat(null, 30, 0xFFFFFF));
			selectIcon.x = bottomMenu.width / 2 - selectIcon.width / 2;
			selectIcon.y = bottomMenu.y + (bottomMenu.height / 2 - selectIcon.height / 2);
			
			//add front / back buttons
			frontBtn = new UIButtonMobile("Front", 0x000000, 30, 0, 0, 0);
			frontBtn.addEventListener(UIButtonMobile.CLICKED, changeView);
			frontBtn.dim();
			menuHolder.addChild(frontBtn);
			backBtn = new UIButtonMobile("Back", 0x000000, 30, 0, 0, 0);
			backBtn.addEventListener(UIButtonMobile.CLICKED, changeView);
			backBtn.x = frontBtn.width;
			menuHolder.addChild(backBtn);
			
			rec = new Rectangle(-(_width - sideMenu.width), -40, _width - sideMenu.width - 80, _height - MENU_HEIGHT - 40);
			
			//add icon label
			iconLabel= new UILabelJT(sideMenu, 5, 5, "Icon:", format);
			
			//add placeholder sprites for icons
			burningPlace = new Sprite();
			sideMenu.addChild(burningPlace);
			burningPlace.x = sideMenu.width / 4 - 75 / 2;
			burningPlace.y = iconLabel.height + 15;
			cuttingPlace = new Sprite();
			sideMenu.addChild(cuttingPlace);
			cuttingPlace.x = sideMenu.width / 2 + (sideMenu.width / 4 - 75 / 2);
			cuttingPlace.y = iconLabel.height + 15;
			throbbingPlace = new Sprite();
			sideMenu.addChild(throbbingPlace);
			throbbingPlace.x = sideMenu.width / 4 - 75 / 2;
			throbbingPlace.y = burningPlace.y + 75 + 5;
			
			//add icons + slider
			var burningPain:PainIcon = new PainIcon(BurningPain, "Burning", rec);
			sideMenu.addChild(burningPain);
			burningPain.x = burningPlace.x;
			burningPain.y = burningPlace.y;
			var cuttingPain:PainIcon = new PainIcon(CuttingPain, "Cutting", rec);
			sideMenu.addChild(cuttingPain);
			cuttingPain.x = cuttingPlace.x;
			cuttingPain.y = cuttingPlace.y;
			var throbbingPain:PainIcon = new PainIcon(ThrobbingPain, "Throbbing", rec);
			sideMenu.addChild(throbbingPain);
			throbbingPain.x = throbbingPlace.x;
			throbbingPain.y = throbbingPlace.y;
			
			painScale = new UISliderLA(sideMenu, 0, sideMenu.height, sideMenu.height / 2);
			painScale.value = 0;
			painScale.rotation = -90;
			painScale.x = sideMenu.width / 2 - painScale.width / 2;
			painScale.y = painScale.y - 20;
			painScale.alpha = 0;
			painScale.visible = false;
			painScale.addEventListener(Event.CHANGE, painScaleChange);
			painLabel = new UILabelJT(sideMenu, 15, painScale.y - painScale.height - 40, "Pain Intensity: 0", format);
			painLabel.alpha = 0;
			painLabel.visible = false;
			
			//draw rectangle that holds icons
			sideMenu.graphics.beginFill(0x444444);
			sideMenu.graphics.drawRect(0, iconLabel.height + 5, _width - front.width, throbbingPain.y + throbbingPain.height);
			sideMenu.graphics.endFill();
			
			//add trash icon
			trashIcon = new TrashIcon();
			trashIcon.x = 5;
			trashIcon.y = front.height - trashIcon.height - 5;
			bodyHolder.addChild(trashIcon);
			
			//listen for icon dropped event
			addEventListener(IconDragEvent.DROP, iconDropped);
			
			//listen for new icon dragging event
			addEventListener(IconDragEvent.DRAG, newIconGrabbed);
			
			iconArray = new Array();
		}
		
		protected function newIconGrabbed(event:IconDragEvent):void
		{
			if (iconArray.length > 0){
				iconArray[iconIndex].stopGlow();
				
				//save pain in icon vars
				iconArray[iconIndex].painIntensity = (Math.round(10 *painScale.value));
				iconArray[iconIndex].painLength = (Math.round(30 * painLength.value));;
				iconArray[iconIndex].painTime = painLength2Change();
				//calculate x and y percent
				var dropPoint:Point = event.target.localToGlobal(new Point(0,0));  //global x and y of dropped icon
				iconArray[iconIndex].xPercent = dropPoint.x / front.width;
				iconArray[iconIndex].yPercent = dropPoint.y / front.height;
				
				//update pain intensity slider and label
				painLabel.text = "Pain Intensity: " + event.icon.painIntensity;
				painScale.value = event.icon.painIntensity / 10;
				
				//update pain length(number) and time(string) + info label
				painLength.value = event.icon.painLength / 30;
				painLength2.value = getPainValue(event.icon.painTime);
				
				//reset pain info label
				//                   comes in as number                         comes in as string
				infoLabel.text = event.icon.painLength + " " + event.icon.painTime + "(s) of pain";
				
			}
		}
		
		protected function finishClicked(event:Event):void
		{
			if (!dimBlack) {
				//dim everything else and disable mouse clicks
				dimBlack = new Sprite();
				dimBlack.graphics.beginFill(0x000000, .7);
				dimBlack.graphics.drawRect(0, 0, _width, _height);
				dimBlack.graphics.endFill();
				dimBlack.alpha = 0;
				addChild(dimBlack);
				TweenLite.to(dimBlack, .5, {alpha:1});
				
				comment = new TextField();
				comment.width = _width / 2;
				comment.height = _height / 4;
				comment.x = _width / 2 - comment.width / 2;
				comment.y = _height / 2 - comment.height / 2;
				comment.type = TextFieldType.INPUT;
				comment.background = true;
				comment.backgroundColor = 0xFFFFFF;
				comment.wordWrap = true;
				
				commentFormat = new TextFormat();
				commentFormat.size = 22;
				comment.setTextFormat(commentFormat);
				
				dimBlack.addChild(comment);
				
				//add comment label
				var commentLabel:UILabelJT = new UILabelJT(dimBlack, 0, 0, "Comments:", format);
				commentLabel.x = comment.x;
				commentLabel.y = comment.y - 30;
				
				//add back button
				var backCommentBtn:UIButtonMobile = new UIButtonMobile("Back", 0xFF0000, 30, comment.width / 2 - 5, 85);
				backCommentBtn.x = comment.x;
				backCommentBtn.y = comment.y + comment.height + 10;
				backCommentBtn.addEventListener(UIButtonMobile.CLICKED, backComment);
				dimBlack.addChild(backCommentBtn);
				
				//add save button
				var saveCommentBtn:UIButtonMobile = new UIButtonMobile("Finalize", 0x00FF00, 30, comment.width / 2 - 5, 85);
				saveCommentBtn.x = comment.x + comment.width - saveCommentBtn.width;
				saveCommentBtn.y = comment.y + comment.height + 10;
				saveCommentBtn.addEventListener(UIButtonMobile.CLICKED, saveComment);
				dimBlack.addChild(saveCommentBtn);
				
				//update comment size everytime a letter is entered
				comment.addEventListener(Event.CHANGE, updateTextFormat);
			} else {
				addChild(dimBlack);
				TweenLite.to(dimBlack, .5, {alpha:1});
			}
		}
		
		protected function backComment(event:Event):void
		{
			TweenLite.to(dimBlack, .5, {alpha:0, onComplete:killFade});
		}
		
		protected function saveComment(event:Event):void
		{
			TweenLite.to(dimBlack, .5, {alpha:0, onComplete:killBodyMap});
		}
		
		protected function killFade():void {
			this.removeChild(dimBlack);
		}
		
		protected function killBodyMap():void {
			this.parent.stage.setOrientation(StageOrientation.DEFAULT);
			this.parent.removeChild(this);
		}
		
		protected function updateTextFormat(event:Event):void
		{
			comment.setTextFormat(commentFormat);
		}
		
		protected function iconDropped(event:IconDragEvent):void
		{
			selectIcon.visible = false;
			//make options visible once first icon is dropped
			TweenLite.to(bottomMenuOptions, .5, {alpha:1});
			TweenLite.to(painLabel, .5, {alpha:1});
			TweenLite.to(painScale, .5, {alpha:1});
			finishBtn.visible = true;
			painScale.visible = true;
			painLabel.visible = true;
			
			if(event.icon.dropCount == 1) {
				//push into array and save index in icon class
				event.icon.index = iconArray.push(event.icon) - 1;
				if (frontBtn.isDimmed == true) {
					event.icon.iconSide = "Front";
				} else if (backBtn.isDimmed == true) {
					event.icon.iconSide = "Back";
				}
				switch(event.icon.type) {
					case "Burning":
						var burningPain:PainIcon = new PainIcon(BurningPain, "Burning", rec);
						burningPain.x = burningPlace.x;
						burningPain.y = burningPlace.y;
						sideMenu.addChild(burningPain);
						break;
					case "Cutting":
						var cuttingPain:PainIcon = new PainIcon(CuttingPain, "Cutting", rec);
						cuttingPain.x = cuttingPlace.x;
						cuttingPain.y = cuttingPlace.y;
						sideMenu.addChild(cuttingPain);
						break;
					case "Throbbing":
						var throbbingPain:PainIcon = new PainIcon(ThrobbingPain, "Throbbing", rec);
						throbbingPain.x = throbbingPlace.x;
						throbbingPain.y = throbbingPlace.y;
						sideMenu.addChild(throbbingPain);
						break;
				}
			}
			iconIndex = event.icon.index;
			
			//check if dropped icon is over the trash can
			if(trashIcon.hitTestObject(iconArray[iconIndex])) {
				//HIT
				sideMenu.removeChild(iconArray[iconIndex]);
				iconArray.splice(iconIndex, 1);
				for (var i:int = iconIndex; i < iconArray.length; i++) {
					iconArray[i].index = i;
				}
				
				//update iconIndex to one less than it was, accounting for the icon that was just deleted
				if (iconIndex == 0){
					iconIndex = 0;
				} else {
					iconIndex = iconIndex - 1;
				}
				
				if (iconArray.length > 0) {
					//make last item in array selected
					iconArray[iconIndex].startGlow();
					
					//update pain intensity slider and label
					painLabel.text = "Pain Intensity: " + iconArray[iconIndex].painIntensity;
					painScale.value = iconArray[iconIndex].painIntensity / 10;
					
					//update pain length(number) and time(string) + info label
					painLength.value = iconArray[iconIndex].painLength / 30;
					painLength2.value = getPainValue(iconArray[iconIndex].painTime);
					
					//reset pain info label
					//                   comes in as number                         comes in as string
					infoLabel.text = iconArray[iconIndex].painLength + " " + iconArray[iconIndex].painTime + "(s) of pain";
				} else {
					//reset all sliders and labels to 0, because the last icon on screen has been deleted
					painLabel.text = "Pain Intensity: 0";
					painScale.value = 0;
					painLength.value = 0;
					painLength2.value = 0;
					infoLabel.text = "0 hour(s) of pain";
				}
				
			} else {
				//NO HIT
			}
		}
		
		protected function painScaleChange(event:Event):void
		{
			painLabel.text = "Pain Intensity: " + (Math.round(10 * event.target.value));
		}
		
		protected function painLength2Change(event:Event=null):String
		{
			timeInt = (Math.round(30 * painLength.value));
			
			if (painLength2.value >= 0 && painLength2.value <= .2) {
				timeString = "hour";
				infoLabel.text = timeInt + " " + timeString + "(s) of pain";
			} else if (painLength2.value > .2 && painLength2.value <= .4) {
				timeString = "day";
				infoLabel.text = timeInt + " " + timeString + "(s) of pain";
			} else if (painLength2.value > .4 && painLength2.value <= .6) {
				timeString = "week";
				infoLabel.text = timeInt + " " + timeString + "(s) of pain";
			} else if (painLength2.value > .6 && painLength2.value <= .8) {
				timeString = "month";
				infoLabel.text = timeInt + " " + timeString + "(s) of pain";
			} else if (painLength2.value > .8 && painLength2.value <= 1) {
				timeString = "year";
				infoLabel.text = timeInt + " " + timeString + "(s) of pain";
			}
			return timeString;
		}
		
		private function getPainValue(s:String):Number {
			var value:Number;
			if (s == "hour") {
				value = 0;
			} else if (s == "day") {
				value = .3;
			} else if (s == "week") {
				value = .5;
			} else if (s == "month") {
				value = .7;
			} else if (s == "year") {
				value = .9;
			}
			return value;
		}
		
		protected function painLengthChange(event:Event):void
		{
			timeInt = (Math.round(30 * event.target.value));
			infoLabel.text = timeInt + " " + painLength2Change() + "(s) of pain";
		}
		
		protected function changeView(event:Event):void
		{
			switch(event.target.label) {
				case "Front":
					frontBtn.dim();
					backBtn.show();
					TweenLite.to(front, .5, {alpha:1});
					TweenLite.to(back, .5, {alpha:0});
					break;
				case "Back":
					backBtn.dim();
					frontBtn.show();
					TweenLite.to(front, .5, {alpha:0});
					TweenLite.to(back, .5, {alpha:1});
					break;
			}
			for (var i:int = 0; i < iconArray.length; i++) 
			{
				if (iconArray[i].iconSide != event.target.label) {
					TweenLite.to(iconArray[i], .3, {alpha:0, onComplete:fadeOutIcons, onCompleteParams:[i]});
				} else {
					iconArray[i].visible = true;
					TweenLite.to(iconArray[i], .3, {alpha:1});
				}
			}
			
		}
		
		private function fadeOutIcons(_i:int):void {
			iconArray[_i].visible = false;
		}
	}
}