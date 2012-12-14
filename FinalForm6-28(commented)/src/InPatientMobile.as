package
{
	import Sections.Admin.AdminLayout;
	import Sections.Login.LoginXML;
	import Sections.NewPatientInfo.*;
	import Sections.Popup.PopupXML;
	import Sections.callout.Callout;
	
	import bodyMap.BodyMap;
	
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	import com.jontetzlaff.tts.TextToSpeech;
	
	import customClasses.*;
	
	import customMadness.*;
	
	import events.CustomIndexEvent;
	import events.FMSMessageEvent;
	import events.LabelTouchEvent;
	import events.QRDataEvent;
	
	import files.FileManager;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	
	import qr.PatientQR;
	import qr.camera.CustomCamera;
	import qr.events.CameraImageEvent;
	import qr.fms.FMSHandler;
	
	public class InPatientMobile extends Sprite
	{		
		
		/********QR STUFF*******/
		private var cameraBtn:UIButton;
		private var _settingsPopUp:UIWindow; 
		private var messagePopup:UIWindow;
		private var fms:FMSHandler;
		
		/*************FORM STUFF********************/
		protected static const DATA:XML = <data>
											<group label="Forms">
												<item label="New Patient Info"/>
												<item label="Body Map"/>
											</group>
											<group label="Settings">
												<item label="Settings"/>
											</group>
										  </data>;
		
		protected static const NEW_PATIENT_NAV:XML = 
			<navigation title="New Patient Information" background="#FFFFFF" colour="#666677" id="newPatientNav">
				{PatientInfo.LAYOUT}
				{InsurCardHoldInfo.LAYOUT4}
				{DisclosePHI.LAYOUT2}
				{AdvCarePlan.LAYOUT3}
			</navigation>;
			
		protected static const SPLITVIEW:XML = 
			<columns stageColour="#FFFFFF" id="myCols" gapH="4" widths="20%, 80%" background="#707449" border="false">
				<vertical id="myScroll" background="#E4D1B0">
					<dividedList id="myList" colour="#D66821" highlightPressed="true">
							{DATA}
						<label id="label" alignH="fill"/>
					</dividedList>
				</vertical>
				<pages id="myForms">
						{NEW_PATIENT_NAV}
						</pages>
					</columns>;
		
		protected var _form:UIPages;
		protected var _list:UIDividedList;
		protected var _navigation:UINavigation;
		private var helpToggle:Boolean = false;
		protected var _mapHolder:UIImage;
		private var calloutLabel:UILabel;
		private var closeCallout:UIButton;
		private var callout:UIDropWindow;
		private var helpLabel:UILabel;
		
		private var gateway:NetConnection;
		private var responder:Responder;
	
		private var selectResponderN1:Responder;
		private var selectResponderHelp:Responder;
		
		//N1 variables
		private var txtLastName:UIInputJT;
		private var txtFirstName:UIInputJT;
		private var txtMI:UIInputJT;
		private var txtSSN:UIInputJT;
		private var txtStreetAddress:UIInputJT;
		private var txtCity:UIInputJT;
		private var txtState:UIInputJT;
		private var txtZip:UIInputJT;
		private var txtHomePh:UIInputJT;
		private var txtWorkPh:UIInputJT;
		private var txtCellPh:UIInputJT;
		private var txtFamPhysician:UIInputJT;
		private var txtEmail:UIInputJT;
		private var txtDOB:UIInputJT;
		private var txtEmergContactInfo:UIInputJT;
		private var txtEmergContactPh:UIInputJT;
		private var radAsian:UIRadioButtonJT;
		private var radBlack:UIRadioButtonJT;
		private var radDeclined:UIRadioButtonJT;
		private var radHispanic:UIRadioButtonJT;
		private var radAmerIndian:UIRadioButtonJT;
		private var radAlaskan:UIRadioButtonJT;
		private var radOther:UIRadioButtonJT;
		private var radWhite:UIRadioButtonJT;
		private var txtInsuranceLastName:UIInputJT;
		private var txtInsuranceFirstName:UIInputJT;
		private var txtInsuranceMI:UIInputJT;
		private var txtInsuranceSSN:UIInputJT;
		private var txtInsuranceDOB:UIInputJT;
		private var radInsuranceMale:UIRadioButtonJT;
		private var radInsuranceFemale:UIRadioButtonJT;
		private var txtInsuranceStreetAddress:UIInputJT;
		private var txtInsuranceCity:UIInputJT;
		private var txtInsuranceState:UIInputJT;
		private var txtInsuranceZip:UIInputJT;
		private var txtInsuranceRelationship:UIInputJT;
		private var txtInsuranceHomePh:UIInputJT;
		private var txtInsuranceWorkPh:UIInputJT;
		private var txtInsuranceEmpName:UIInputJT;
		private var discloseFirst1:UIInputJT;
		private var discloseLast1:UIInputJT;
		private var discloseRelationship1:UIInputJT;
		private var discloseFirst2:UIInputJT;
		private var discloseLast2:UIInputJT;
		private var discloseRelationship2:UIInputJT;
		private var discloseAuthorize:UICheckBoxJT;
		private var disclosePassword:UIInputJT;
		private var advCareLivingWillYes:UIRadioButtonJT;
		private var advCareLivingWillNo:UIRadioButtonJT;
		private var advCarePowerAttorneyYes:UIRadioButtonJT;
		private var advCarePowerAttorneyNo:UIRadioButtonJT;
		private var advCareDocumentKept:UIInputJT;
		private var advCarePlanningPacketYes:UIRadioButtonJT;
		private var advCarePlanningPacketNo:UIRadioButtonJT;
		private var advCareSig:UIInputJT;
		private var advCareSigDate:UIInputJT;
		private var sameAsPatient:UICheckBoxJT;

		private var selectedText:String;
		private var vidHolder2:UIImage;

		private var calloutMenu:CalloutHelpMenu;
		private var stageHeight:int;
		private var stageWidth:int;
		private var clickPoint:Point;

		private var currentLabel:UITouchLabel;
		private var avatar:Avatar;
		private var avatarHolder:UIImage;
		private var pinInput:UIPassword;
		private var loginBtn:UIButton;

		private var qrData:Array;
		private var patientData:Array;
		private var part1:UILabelJT;
		private var part2:UILabelJT;
		
		private var saveSettings:UIButton;//                                     added
		private var closeSettings:UIButton;//                                     added
		private var helpPicker:UIPicker;//                                     added
		private var helpType:int = 0;
		private var _uiHolder:Sprite;
		private var messageLabel:UILabelJT;
		private var closeMessage:UIButton;
		private var adminPopup:UIWindow;
		private var adminLoginPopup:UIWindow;

		private var adminSignIn:UIButton;
		private var choiceLogin:UIWindow;
		private var newPatient:Boolean = false;
		private var fieldArray4:Array;
		private var patientID:uint;
		private var userImage:Bitmap;
		private var finalAdminPopup:UIWindow;
		private var pinString:String;
		private var uploadStatus:UILabelJT;
		private var patientInfoArray:Array;
		private var calloutArray:Array = [];
		private var tts:TextToSpeech;
		private var _speechRunning:Boolean = false;

		private var processing:UILabel;
		
		public function InPatientMobile(screen:Sprite = null)
		{
			if (screen)
				screen.addChild(this);
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.autoOrients = false;
			
			this.needsSoftKeyboard = true;
			
			//addEventListener(FocusEvent.FOCUS_IN, inputFocusIn);
			
			initApp();
		}
		
		public function get speechRunning():Boolean
		{
			return _speechRunning;
		}

		public function set speechRunning(value:Boolean):void
		{
			_speechRunning = value;
			if(!value)
				dispatchEvent(new Event("SPEECH_CHANGED"));
		}

		private function initApp() :void {
			_uiHolder = UIeJT.createCustom(this, LoginXML.LOGIN_NAVIGATOR);
			
			choiceLogin = UI.createPopUp(PopupXML.LOGIN_CHOICE_POPUP, 500,300);
			UI.hidePopUp(choiceLogin);
			UI.showPopUp(choiceLogin);
			var newPatient:UIButton = UIButton(choiceLogin.findViewById("newPatient"));
			newPatient.addEventListener(UIButton.CLICKED, newPatientForms);
			var existingPatient:UIButton = UIButton(choiceLogin.findViewById("existingPatient"));
			existingPatient.addEventListener(UIButton.CLICKED, function():void{UI.hidePopUp(choiceLogin);});
			
			_navigation = UINavigation(UI.findViewById("QRnavigation"));
			_navigation.navigationBar.rightButton.visible = false;
			
			part1 = UILabelJT(UI.findViewById("part1"));
			part2 = UILabelJT(UI.findViewById("part2"));
			pinInput = UIPassword(UI.findViewById("pinInput"));
			loginBtn = UIButton(UI.findViewById("pinEnter"));
			cameraBtn = UIButton(UI.findViewById("cameraBtn"));
			cameraBtn.addEventListener(UIButton.CLICKED, startCamera);
			
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			
			//setup responders
			gateway = new NetConnection();
			selectResponderN1 = new Responder(selectN1Success, selectN1Fault);
			gateway.objectEncoding = 0;
		}
		
		protected function newPatientForms(event:Event):void
		{
			//skip login process and give patient forms
			newPatient = true;
			fms = new FMSHandler(390, 290, stage.stageWidth, stage.stageHeight);
			fms.addEventListener("Connected", removeBusyCursor);
			fms.addEventListener("ConnectFailed", retryConnection);
			fms.addEventListener(FMSMessageEvent.MESSAGE, recieveAndDisplayMessage);
			fms.x = fms.y = 0;
			//loads forms for patient
			LoadForms();
		}
		
		protected function inputFocusOut(event:FocusEvent):void
		{
			//tween stage back down after focus is lost
			TweenLite.to(_uiHolder, .2, {y:0}); 
			removeEventListener(FocusEvent.FOCUS_OUT, inputFocusOut);
		}
		
		protected function inputKeyboardRetract(event:SoftKeyboardEvent):void
		{
			//keyboard is hidden by user
			TweenLite.to(_uiHolder, .2, {y:0}); 
			removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, inputKeyboardRetract);
		}
		
		protected function inputFocusIn(event:FocusEvent):void
		{
			//tween
			try {
				var input:UIBlueText = UIBlueText(event.target);
				clickPoint = event.target.localToGlobal(new Point(0,0));
				if(clickPoint.y > stage.stageHeight / 2) {
					this.requestSoftKeyboard();
					TweenLite.to(_uiHolder, .3, {delay:.4, y:event.target.y - stage.stageHeight / 3});
					addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, inputKeyboardRetract);
					addEventListener(FocusEvent.FOCUS_OUT, inputFocusOut);
				}
			}
			catch(e:Error) {
				//not an input, do nothing
			}
		}
		
		protected function resetLogin(event:Event):void
		{
			_navigation.navigationBar.rightButton.visible = false;
			_navigation.navigationBar.rightButton.removeEventListener(UIButton.CLICKED, resetLogin);
			part1.htmlText = "<font color='#333333'><b>Part 1</b></font>";
			part2.htmlText = "<font color='#c0c0c0'>Part 2</font>";
			cameraBtn.addEventListener(UIButton.CLICKED, startCamera);
			loginBtn.removeEventListener(UIButton.CLICKED, pinEntered);
		}
		
		private function startCamera(event:Event):void
		{
			part1.htmlText = "<font color='#333333'><b>Part 1</b></font>"
				
			var qrCamera:PatientQR = new PatientQR(stage);
			qrCamera.addEventListener(QRDataEvent.CUSTOM_EVENT, goToResult);
			qrCamera.addEventListener("ReadFailure", popupError);
			qrCamera.addEventListener("CaptureCanceled", hideActivity);
			addChild(qrCamera);
			UI.showActivityIndicator();
		}
		
		protected function hideActivity(event:Event):void
		{
			UI.hideActivityIndicator();
		}
		
		protected function popupError(event:Event):void
		{
			UI.hideActivityIndicator();
			part1.htmlText = "<font color='#FF0000'><b>Part 1 - Error reading QR</b></font>";
		}
		
		//close popups
		protected function closePopup(event:Event):void
		{
			UI.hidePopUp(messagePopup);
		}
		
		protected function goToResult(event:QRDataEvent):void
		{
			UI.hideActivityIndicator();
			qrData = event.data;
			
			if(qrData[0] == "Patient" && qrData.length == 3) {
				part1.htmlText = "<font color='#c0c0c0'>Part 1 - Completed</font>";
				part2.htmlText = "<font color='#333333'><b>Part 2</b></font>";
				
				loginBtn.addEventListener(UIButton.CLICKED, pinEntered);
				cameraBtn.removeEventListener(UIButton.CLICKED, startCamera);
				_navigation.navigationBar.rightButton.visible = true;
				_navigation.navigationBar.rightButton.addEventListener(UIButton.CLICKED, resetLogin);
			}
			else {
				part1.htmlText = "<font color='#FF0000'><b>Part 1 - Incorrect QR</b></font>";
			}
		}
		
		protected function pinEntered(event:Event):void {
			UI.showActivityIndicator();
			gateway.connect("http://wdmdsrv1.uwsp.edu/flashservices/gateway/");
			var responderPin:Responder = new Responder(onPinResult, onPinFault);
			gateway.call("Inpatient.Inpatient_Main.forms.loginWithPin", responderPin, pinInput.text, qrData[2].toString());
		}
		
		private function onPinResult(event:Object):void
		{
			UI.hideActivityIndicator();
			if(event.serverInfo.initialData.length > 0) {
				patientData = event.serverInfo.initialData;
				
				fms = new FMSHandler(390, 290, stage.stageWidth, stage.stageHeight, qrData[2]);
				fms.addEventListener("Connected", removeBusyCursor);
				fms.addEventListener("ConnectFailed", retryConnection);
				fms.addEventListener(FMSMessageEvent.MESSAGE, recieveAndDisplayMessage);
				fms.x = fms.y = 0;
				
				LoadForms();
			}
			else {
				part2.htmlText = "<font color='#FF0000'><b>Part 2 - Incorrect Login</b></font>";
			}
		}
		
		protected function recieveAndDisplayMessage(event:FMSMessageEvent):void
		{
			closeMessage.addEventListener(UIButton.CLICKED, closePopup);
			messageLabel.text = event.message;
			UI.showPopUp(messagePopup);
		}
		
		private function onPinFault(event:Object):void
		{
			trace("fail");
		}
		
		private function LoadForms():void {
			_uiHolder = UIeJT.createCustom(this, SPLITVIEW);
			
			if(newPatient) {
				adminPopup = UI.createPopUp(AdminLayout.ADMIN_POPUP, 500, 300);
				adminLoginPopup = UI.createPopUp(AdminLayout.ADMIN_LOGIN_POPUP, 500, 300);
				UI.hidePopUp(adminPopup);
				UI.hidePopUp(adminLoginPopup);
			}
			else {
				UI.dimUI();
				UI.showActivityIndicator();
				
				messagePopup = UI.createPopUp(PopupXML.MESSAGE_POPUP, 400.0, 250.0);
				messageLabel = UILabelJT(messagePopup.findViewById("messageReceived"));
				closeMessage = UIButton(messagePopup.findViewById("messageClose"));
				UI.hidePopUp(messagePopup);
			}
			
			_list = UIDividedList(UI.findViewById("myList"));
			
			// Add the pages component
			_form = UIPages(UI.findViewById("myForms"));
			_navigation = UINavigation(UI.findViewById("newPatientNav"));
			//_navigation = UINavigation(UI.findViewById("splashNav"));
			setNavigation();
			
			_list.addEventListener(UIList.CLICKED, changePage);
			
			//add listener for touched field
			addEventListener(LabelTouchEvent.CUSTOM_EVENT, labelTouch);
			
			var timer:Timer = new Timer(50, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, addHelpMenu);
			timer.start();
			
			//regular definition callout
			callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_VIDEO_LEFT, 400, 200));
			closeCallout = UIButton(callout.findViewById("closeCallout"));
			closeCalloutEvent();
			
			//N1 variables
			txtLastName = UIInputJT(UI.findViewById("txtLastName"));
			txtFirstName = UIInputJT(UI.findViewById("txtFirstName"));
			txtMI = UIInputJT(UI.findViewById("txtMI"));
			txtSSN = UIInputJT(UI.findViewById("txtSSN"));
			
			txtStreetAddress = UIInputJT(UI.findViewById("txtStreetAddress"));
			txtCity = UIInputJT(UI.findViewById("txtCity"));
			txtState = UIInputJT(UI.findViewById("txtState"));
			txtZip = UIInputJT(UI.findViewById("txtZip"));
			txtHomePh = UIInputJT(UI.findViewById("txtHomePh"));
			txtWorkPh = UIInputJT(UI.findViewById("txtWorkPh"));
			txtCellPh = UIInputJT(UI.findViewById("txtCellPh"));
			txtFamPhysician = UIInputJT(UI.findViewById("txtFamPhysician"));
			txtEmail = UIInputJT(UI.findViewById("txtEmail"));
			txtDOB = UIInputJT(UI.findViewById("txtDOB"));
			txtEmergContactInfo = UIInputJT(UI.findViewById("txtEmergContactInfo"));
			txtEmergContactPh = UIInputJT(UI.findViewById("txtEmergContactPh"));
			radAsian = UIRadioButtonJT(UI.findViewById("radAsian"));
			radBlack = UIRadioButtonJT(UI.findViewById("radBlack"));
			radDeclined = UIRadioButtonJT(UI.findViewById("radDeclined"));
			radHispanic = UIRadioButtonJT(UI.findViewById("radHispanic"));
			radAmerIndian = UIRadioButtonJT(UI.findViewById("radAmerIndian"));
			radAlaskan = UIRadioButtonJT(UI.findViewById("radAlaskan"));
			radOther = UIRadioButtonJT(UI.findViewById("radOther"));
			radWhite = UIRadioButtonJT(UI.findViewById("radWhite"));
			txtInsuranceLastName = UIInputJT(UI.findViewById("txtInsuranceLastName"));
			txtInsuranceFirstName = UIInputJT(UI.findViewById("txtInsuranceFirstName"));
			txtInsuranceMI = UIInputJT(UI.findViewById("txtInsuranceMI"));
			txtInsuranceSSN = UIInputJT(UI.findViewById("txtInsuranceSSN"));
			txtInsuranceDOB = UIInputJT(UI.findViewById("txtInsuranceDOB"));
			radInsuranceMale = UIRadioButtonJT(UI.findViewById("radInsuranceMale"));
			radInsuranceFemale = UIRadioButtonJT(UI.findViewById("radInsuranceFemale"));
			txtInsuranceStreetAddress = UIInputJT(UI.findViewById("txtInsuranceStreetAddress"));
			txtInsuranceCity = UIInputJT(UI.findViewById("txtInsuranceCity"));
			txtInsuranceState = UIInputJT(UI.findViewById("txtInsuranceState"));
			txtInsuranceZip = UIInputJT(UI.findViewById("txtInsuranceZip"));
			txtInsuranceRelationship = UIInputJT(UI.findViewById("txtInsuranceRelationship"));
			txtInsuranceHomePh = UIInputJT(UI.findViewById("txtInsuranceHomePh"));
			txtInsuranceWorkPh = UIInputJT(UI.findViewById("txtInsuranceWorkPh"));
			txtInsuranceEmpName = UIInputJT(UI.findViewById("txtInsuranceEmpName"));
			discloseFirst1 = UIInputJT(UI.findViewById("discloseFirst1"));
			discloseLast1 = UIInputJT(UI.findViewById("discloseLast1"));
			discloseRelationship1 = UIInputJT(UI.findViewById("discloseRelationship1"));
			discloseFirst2 = UIInputJT(UI.findViewById("discloseFirst2"));
			discloseLast2 = UIInputJT(UI.findViewById("discloseLast2"));
			discloseRelationship2 = UIInputJT(UI.findViewById("discloseRelationship2"));
			discloseAuthorize = UICheckBoxJT(UI.findViewById("authAuthorize"));
			disclosePassword = UIInputJT(UI.findViewById("disclosePassword"));
			advCareLivingWillYes = UIRadioButtonJT(UI.findViewById("advCareLivingWillYes"));
			advCareLivingWillNo = UIRadioButtonJT(UI.findViewById("advCareLivingWillNo"));
			advCarePowerAttorneyYes = UIRadioButtonJT(UI.findViewById("advCarePowerAttorneyYes"));
			advCarePowerAttorneyNo = UIRadioButtonJT(UI.findViewById("advCarePowerAttorneyNo"));
			advCareDocumentKept = UIInputJT(UI.findViewById("advCareDocumentKept"));
			advCarePlanningPacketYes = UIRadioButtonJT(UI.findViewById("advCarePlanningPacketYes"));
			advCarePlanningPacketNo = UIRadioButtonJT(UI.findViewById("advCarePlanningPacketNo"));
			advCareSig = UIInputJT(UI.findViewById("advCareSig"));
			advCareSigDate = UIInputJT(UI.findViewById("advCareSigDate"));
			
			if(!newPatient) {
				txtLastName.text = patientData[0][2];
				txtFirstName.text = patientData[0][1];
				txtMI.text = patientData[0][3];
				txtSSN.text = patientData[0][4];
				if (patientData[0][5] == 0) {
					radWhite.state = true;
				} else if (patientData[0][5] == 1) {
					radAsian.state = true;
				}else if (patientData[0][5] == 2) {
					radBlack.state = true;
				}else if (patientData[0][5] == 3) {
					radDeclined.state = true;
				}else if (patientData[0][5] == 4) {
					radHispanic.state = true;
				}else if (patientData[0][5] == 5) {
					radAmerIndian.state = true;
				}else if (patientData[0][5] == 6) {
					radAlaskan.state = true;
				}else if (patientData[0][5] == 7) {
					radOther.state = true;
				}
				txtDOB.text = patientData[0][6];
			}
			
			sameAsPatient = UICheckBoxJT(UI.findViewById("sameAsPatient"));
			sameAsPatient.addEventListener(Event.CHANGE, copyPatientInfo);
			
			tts = new TextToSpeech();
			tts.addEventListener("SPEECH_STARTED", speechProcessing);
			tts.addEventListener("SPEECH_FINISHED", stopAvatar);
			
			//   SELECT FORMS FROM DB
			gateway.connect("http://wdmdsrv1.uwsp.edu/flashservices/gateway/");
			
			//example
			if(!newPatient)
				gateway.call("Inpatient.Inpatient_Main.forms.getNewPatientInfo", selectResponderN1, int(patientData[0][0]), 1);
			
			// Prod server: http://wdmdsrv1.uwsp.edu/flex2gateway/
			// http://wdmdsrv1.uwsp.edu/flashservices/gateway/
			// Prod server: Inpatient.Inpatient_Main.forms
			
			// Localhost: http://localhost:8501/flashservices/gateway/
			// Localhost: Inpatient.inpatient.forms.getChangeAuthInfo
			// Localhost: Inpatient.inpatient.forms.getMedAssistPay
			
			vidHolder2 = UIImage(callout.findViewById("videoHolder"));
			vidHolder2.addChild(fms);
		}
		
		protected function speechProcessing(event:Event):void
		{
			speechRunning = true;
		}
		
		protected function copyPatientInfo(event:Event):void
		{
			//user CHECKS checkbox
			if (sameAsPatient.state == true) {
				txtInsuranceLastName.text = txtLastName.text;
				txtInsuranceFirstName.text = txtFirstName.text;
				txtInsuranceMI.text = txtMI.text;
				txtInsuranceSSN.text = txtSSN.text;
				txtInsuranceStreetAddress.text = txtStreetAddress.text;
				txtInsuranceCity.text = txtCity.text;
				//user UNCHECKS checkbox
			} else if (sameAsPatient.state == false) {
				txtInsuranceLastName.text = "";
				txtInsuranceFirstName.text = "";
				txtInsuranceMI.text = "";
				txtInsuranceSSN.text = "";
				txtInsuranceStreetAddress.text = "";
				txtInsuranceCity.text = "";
			}
		}
		
		protected function addHelpMenu(event:TimerEvent):void
		{
			calloutMenu = new CalloutHelpMenu(["Text", "Voice", "Video", "Avatar"]);
			calloutMenu.x = stage.stageWidth - calloutMenu.width / 4;
			calloutMenu.y = stage.stageHeight - calloutMenu.height;
			addChild(calloutMenu);
			calloutMenu.addEventListener(Event.CHANGE, updateSettings);
		}
		
		protected function updateSettings(event:Event):void
		{
			helpType = calloutMenu.index;
		}
		
		protected function labelTouch(event:LabelTouchEvent):void
		{
			//setup responders
			selectResponderHelp = new Responder(selectHelpSuccess, selectHelpFault);
			gateway.call("Inpatient.Inpatient_Main.forms.getHelpCaptions", selectResponderHelp, event.target.id);
			
			
			closeCalloutEvent();
			clickPoint = event.target.localToGlobal(new Point(0,0));
			currentLabel = UITouchLabel(event.target);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, hideCallout);
		}
		
		private function selectHelpFault(event:Object):void
		{
			var pointOffset:int = currentLabel.height + 26;
			if(clickPoint.x + callout.width >= stage.stageWidth) {
				callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_SMALL_MIDDLE, 400, 200));
				
				helpLabel = UILabel(callout.findViewById("helpText"));
				helpLabel.text = "Looks like there was a problem getting the help text.";
				
				closeCallout = UIButton(callout.findViewById("closeCallout"));
				closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
				callout.x = stage.stageWidth - callout.width - 20;
				callout.y = clickPoint.y + pointOffset;
			}
			else {
				callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_SMALL, 400, 200));
				
				helpLabel = UILabel(callout.findViewById("helpText"));
				helpLabel.text = "Looks like there was a problem getting the help text.";
				
				closeCallout = UIButton(callout.findViewById("closeCallout"));
				closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
				callout.x = clickPoint.x + 8;
				callout.y = clickPoint.y + pointOffset;
			}
		}
		
		//successful call to db which grabs help text for callout
		private function selectHelpSuccess(event:Object):void
		{
			var helpText:String = event['HELP_TEXT'];
			helpType = calloutMenu.index;
			
			var pointOffset:int = currentLabel.height + 26;
			
			if(helpType == 0) {  //text selected
				if(clickPoint.x + callout.width + 25 >= stage.stageWidth) {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_SMALL_MIDDLE, 400, 200));
					
					helpLabel = UILabel(callout.findViewById("helpText"));
					helpLabel.text = helpText;
					
					if(helpLabel.height > 96) {
						closeCalloutEvent();
						callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_LARGE_MIDDLE, 400, 200));
						
						helpLabel = UILabel(callout.findViewById("helpText"));
						helpLabel.text = helpText;
					}
					
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = stage.stageWidth - callout.width - 20;
					callout.y = clickPoint.y + pointOffset;
				}
				else {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_SMALL, 400, 200));
					
					helpLabel = UILabel(callout.findViewById("helpText"));
					helpLabel.text = helpText;
					
					if(helpLabel.height > 96) {
						closeCalloutEvent();
						callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_LARGE, 400, 200));
						
						helpLabel = UILabel(callout.findViewById("helpText"));
						helpLabel.text = helpText;
					}
					
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = clickPoint.x + 8;
					callout.y = clickPoint.y + pointOffset;
				}
			} else if(helpType == 1) {  //voice selected
				//display text and read it off
				if(clickPoint.x + callout.width + 25 >= stage.stageWidth) {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_SMALL_MIDDLE, 400, 200));
					
					helpLabel = UILabel(callout.findViewById("helpText"));
					helpLabel.text = helpText;
					
					if(helpLabel.height > 96) {
						closeCalloutEvent();
						callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_LARGE_MIDDLE, 400, 200));
						
						helpLabel = UILabel(callout.findViewById("helpText"));
						helpLabel.text = helpText;
					}
					
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = stage.stageWidth - callout.width - 20;
					callout.y = clickPoint.y + pointOffset;
				}
				else {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_SMALL, 400, 200));
					
					helpLabel = UILabel(callout.findViewById("helpText"));
					helpLabel.text = helpText;
					
					if(helpLabel.height > 96) {
						closeCalloutEvent();
						callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_TEXT_LARGE, 400, 200));
						
						helpLabel = UILabel(callout.findViewById("helpText"));
						helpLabel.text = helpText;
					}
					
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = clickPoint.x + 8;
					callout.y = clickPoint.y + pointOffset;
				}
				
				tts.speak(helpLabel.text);
			} else if(helpType == 2) {  //video selected
				//show video help
				if(clickPoint.x + callout.width + 25 >= stage.stageWidth) {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_VIDEO_MIDDLE, 400, 200));
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = stage.stageWidth - callout.width - 20;
					callout.y = clickPoint.y + pointOffset;
				}
				else {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_VIDEO_LEFT, 400, 200));
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = clickPoint.x + 8;
					callout.y = clickPoint.y + pointOffset;
				}
				
				if(!fms) {
					fms = new FMSHandler(390, 290, stage.stageWidth, stage.stageHeight, qrData[2]);
					fms.addEventListener("Connected", removeBusyCursor);
					fms.addEventListener("ConnectFailed", retryConnection);
					vidHolder2 = UIImage(callout.findViewById("videoHolder"));
					fms.x = fms.y = 0;
					vidHolder2.addChild(fms);
					UI.showActivityIndicator();
				}
				else {
					var vidHolder2:UIImage = UIImage(callout.findViewById("videoHolder"));
					fms.x = fms.y = 0;
					vidHolder2.addChild(fms);
					fms.playVideo("HelpVideos/" + currentLabel.id + "Video");
				}
			} else if(helpType == 3) {  //avatar selected
				//show avatar help
				if(clickPoint.x + callout.width + 25 >= stage.stageWidth) {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_AVATAR_MIDDLE, 400, 200));
					
					avatar = new Avatar();
					avatarHolder = UIImage(callout.findViewById("avatarHolder"));
					avatarHolder.addChild(avatar);
					avatar.startTalking();
					
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = stage.stageWidth - callout.width - 20;
					callout.y = clickPoint.y + pointOffset;
				}
				else {
					callout = UIDropWindow(UIe.showCallOut(Callout.CALLOUT_LAYOUT_AVATAR_LEFT, 400, 200));
					
					avatar = new Avatar();
					avatarHolder = UIImage(callout.findViewById("avatarHolder"));
					avatarHolder.addChild(avatar);
					avatar.startTalking();
					
					closeCallout = UIButton(callout.findViewById("closeCallout"));
					closeCallout.addEventListener(UIButton.CLICKED, closeCalloutEvent);
					callout.x = clickPoint.x + 8;
					callout.y = clickPoint.y + pointOffset;
				}
				tts.addEventListener("SPEECH_FINISHED", stopAvatar);
				tts.speak(helpText);
			}
			calloutArray.push(callout);
			showHelpCallout();
		}
		
		protected function stopAvatar(event:Event):void
		{
			if(avatar)
				avatar.idle();
			//tts.removeEventListener("SPEECH_FINISHED", stopAvatar);
			speechRunning = false;
		}
		
		protected function hideCallout(event:MouseEvent):void
		{
			closeCalloutEvent();
		}
		
		protected function closeCalloutEvent(event:Event = null):void
		{
			closeCallout.removeEventListener(UIButton.CLICKED, closeCalloutEvent);
			if(fms && fms.videoPlaying) {
				fms.video.stopVideo();
				fms.removeVideo();
			}
			for (var i:int = 0; i < calloutArray.length; i++) 
			{
				calloutArray[i].visible = false;
			}
			
			callout.visible = false;
		}
		
		protected function retryConnection(event:Event):void
		{
			//net connection failed
			fms = new FMSHandler(390, 290, stage.stageWidth, stage.stageHeight, qrData[2]);
			vidHolder2 = UIImage(callout.findViewById("videoHolder"));
			fms.x = fms.y = 0;
			vidHolder2.addChild(fms);
		}
		
		//fms has connected - add listeners to buttons - go to proper page
		protected function removeBusyCursor(event:Event):void
		{
			fms.removeEventListener("Connected", removeBusyCursor);
			fms.removeEventListener("ConnectFailed", retryConnection);
		}
		
		private function selectN1Fault(event:Object):void
		{
			UI.unDimUI();
			UI.hideActivityIndicator();
		}
		
		private function selectN1Success(event:Object):void
		{
			txtStreetAddress.text = event['STREETADDRESS_PATIENT'];
			txtCity.text = event['CITY_PATIENT'];
			txtState.text = event['STATE_PATIENT'];
			txtZip.text = event['ZIP_PATIENT'];
			txtHomePh.text = event['HOMEPHONE_PATIENT'];
			txtWorkPh.text = event['WORKPHONE_PATIENT'];
			txtCellPh.text = event['CELLPHONE_PATIENT'];
			txtFamPhysician.text = event['PRIMARYPHYSICIANNAME'];
			txtEmail.text = event['EMAIL'];
			txtEmergContactInfo.text = event['ICE_NAMERELATIONSHIP'];
			txtEmergContactPh.text = event['ICE_PHONE'];
			txtInsuranceLastName.text = event['LASTNAME_INSHOLDER'];
			txtInsuranceFirstName.text = event['FIRSTNAME_INSHOLDER'];
			txtInsuranceMI.text = event['MI_INSHOLDER'];
			txtInsuranceSSN.text = event['SSN_INSHOLDER'];
			txtInsuranceDOB.text = event['DOB_INSHOLDER'];
			if (event['SEX_INSHOLDER'] == 0) {
				radInsuranceMale.state = true;
			} else if (event['SEX_INSHOLDER'] == 1) {
				radInsuranceFemale.state = false;
			}
			txtInsuranceStreetAddress.text = event['STREETADDRESS_INSHOLDER'];
			txtInsuranceCity.text = event['CITY_INSHOLDER'];
			txtInsuranceState.text = event['STATE_INSHOLDER'];
			txtInsuranceZip.text = event['ZIP_INSHOLDER'];
			txtInsuranceRelationship.text = event['RELATIONSHIPTOPATIENT_INSHOLDER'];
			txtInsuranceHomePh.text = event['HOMEPHONE_INSHOLDER'];
			txtInsuranceWorkPh.text = event['WORKPHONE_INSHOLDER'];
			txtInsuranceEmpName.text = event['EMPLOYERSNAME_INSHOLDER'];
			discloseFirst1.text = event['FIRSTNAME_DISCLOSER1'];
			discloseLast1.text = event['LASTNAME_DISCLOSER1'];
			discloseRelationship1.text = event['RELATIONSHIP_DISCLOSER1'];
			discloseFirst2.text = event['FIRSTNAME_DISCLOSER2'];
			discloseLast2.text = event['LASTNAME_DISCLOSER2'];
			discloseRelationship2.text = event['RELATIONSHIP_DISCLOSER2'];
			/*if (event['AUTHORIZERELEASE'] == 0) {
				discloseAuthorize.state = false;
			} else if (event['AUTHORIZERELEASE'] == 1) {
				discloseAuthorize.state = true;
			}*/
			disclosePassword.text = event['PHIPASSWORD'];
			if (event['LIVINGWILL'] == 0) {
				advCareLivingWillNo.state = true;
			} else if (event['LIVINGWILL'] == 1) {
				advCareLivingWillYes.state = true;
			}
			//trace(event['POWEROFATTORNEY']);
			if (event['POWEROFATTORNEY'] == 0) {
				advCarePowerAttorneyNo.state = true;
			} else if (event['POWEROFATTORNEY'] == 1) {
				advCarePowerAttorneyYes.state = true;
			}
			advCareDocumentKept.text = event['DOCUMENTKEPT'];
			if (event['ADVANCEDCAREPACKET'] == 0) {
				advCarePlanningPacketNo.state = true;
			} else if (event['ADVANCEDCAREPACKET'] == 1) {
				advCarePlanningPacketYes.state = true;
			}
			
			UI.unDimUI();
			UI.hideActivityIndicator();
		}
		
		private function sendForms():void {
			
			var index:int = _list.index;
			
			//ChangeInAuthorization
			var commonArray:Array = new Array();
			var commonInfo:Object = new Object();
			
			patientInfoArray = new Array();
			
			commonInfo = new Object();
			commonInfo.field = "ID_DATE"
			commonInfo.value = 1;
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "FIRSTNAME"
			commonInfo.value = txtFirstName.text;
			patientInfoArray.push(txtFirstName.text);
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "LASTNAME"
			commonInfo.value = txtLastName.text;
			patientInfoArray.push(txtLastName.text);
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "MI"
			commonInfo.value = txtMI.text;
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "SSN"
			commonInfo.value = txtSSN.text;
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "RACE"
			if(radWhite.state == true) 
				commonInfo.value = 0;
			else if(radAsian.state == true) 
				commonInfo.value = 1;
			else if(radBlack.state == true) 
				commonInfo.value = 2;
			else if(radDeclined.state == true) 
				commonInfo.value = 3;
			else if(radHispanic.state == true) 
				commonInfo.value = 4;
			else if(radAmerIndian.state == true) 
				commonInfo.value = 5;
			else if(radAlaskan.state == true) 
				commonInfo.value = 6;
			else if(radOther.state == true) 
				commonInfo.value = 7;
			else 
				commonInfo.value = 8;
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "DOB"
			commonInfo.value = txtSSN.text;
			commonArray.push(commonInfo);
			
			//Populating N1 array with fields/values
			fieldArray4 = new Array();
			var field4:Object = new Object();
			
			if(!newPatient) {
				field4.field = "ID_PATIENT";
				field4.value = int(qrData[1]);
				fieldArray4.push(field4);
			}
			
			field4 = new Object();
			field4.field = "STREETADDRESS_PATIENT";
			field4.value = txtStreetAddress.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "CITY_PATIENT";
			field4.value = txtCity.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "STATE_PATIENT";
			field4.value = txtState.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "ZIP_PATIENT";
			field4.value = txtZip.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "HOMEPHONE_PATIENT";
			field4.value = txtHomePh.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "WORKPHONE_PATIENT";
			field4.value = txtWorkPh.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "CELLPHONE_PATIENT";
			field4.value = txtCellPh.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "PRIMARYPHYSICIANNAME";
			field4.value = txtFamPhysician.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "EMAIL";
			field4.value = txtEmail.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "ICE_NAMERELATIONSHIP";
			field4.value = txtEmergContactInfo.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "ICE_PHONE";
			field4.value = txtEmergContactPh.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "LASTNAME_INSHOLDER";
			field4.value = txtInsuranceLastName.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "FIRSTNAME_INSHOLDER";
			field4.value = txtInsuranceFirstName.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "MI_INSHOLDER";
			field4.value = txtInsuranceMI.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "SSN_INSHOLDER";
			field4.value = txtInsuranceSSN.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "DOB_INSHOLDER";
			field4.value = txtInsuranceDOB.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "SEX_INSHOLDER";
			if (radInsuranceMale.state == true) {
				field4.value = 0;
			} else if (radInsuranceFemale.state == true) {
				field4.value = 1;
			}
			else {
				field4.value = 3;
			}
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "STREETADDRESS_INSHOLDER";
			field4.value = txtInsuranceStreetAddress.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "CITY_INSHOLDER";
			field4.value = txtInsuranceCity.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "STATE_INSHOLDER";
			field4.value = txtInsuranceState.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "ZIP_INSHOLDER";
			field4.value = txtInsuranceZip.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "RELATIONSHIPTOPATIENT_INSHOLDER";
			field4.value = txtInsuranceRelationship.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "HOMEPHONE_INSHOLDER";
			field4.value = txtInsuranceHomePh.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "WORKPHONE_INSHOLDER";
			field4.value = txtInsuranceWorkPh.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "EMPLOYERSNAME_INSHOLDER";
			field4.value = txtInsuranceEmpName.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "LASTNAME_DISCLOSER1";
			field4.value = discloseLast1.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "FIRSTNAME_DISCLOSER1";
			field4.value = discloseFirst1.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "RELATIONSHIP_DISCLOSER1";
			field4.value = discloseRelationship1.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "LASTNAME_DISCLOSER2";
			field4.value = discloseLast2.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "FIRSTNAME_DISCLOSER2";
			field4.value = discloseFirst2.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "RELATIONSHIP_DISCLOSER2";
			field4.value = discloseRelationship2.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "AUTHORIZERELEASE";
			if (discloseAuthorize.state == true) {
				field4.value = 1;
			} else if (discloseAuthorize.state == false) {
				field4.value = 0;
			}
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "PHIPASSWORD";
			field4.value = disclosePassword.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "LIVINGWILL";
			if (advCareLivingWillYes.state == true) {
				field4.value = 1;
			} else if (advCareLivingWillNo.state == true) {
				field4.value = 0;
			}
			else {
				field4.value = 3;
			}
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "POWEROFATTORNEY";
			if (advCarePowerAttorneyYes.state == true) {
				field4.value = 1;
			} else if (advCarePowerAttorneyNo.state == true) {
				field4.value = 0;
			}
			else {
				field4.value = 3;
			}
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "DOCUMENTKEPT";
			field4.value = advCareDocumentKept.text;
			fieldArray4.push(field4);
			
			field4 = new Object();
			field4.field = "ADVANCEDCAREPACKET";
			if (advCarePowerAttorneyYes.state == true) {
				field4.value = 1;
			} else if (advCarePlanningPacketNo.state == true) {
				field4.value = 0;
			}
			else {
				field4.value = 3;
			}
			fieldArray4.push(field4);
			
			//make call to database here
			gateway = new NetConnection();
			responder = new Responder(insertResult, FaultEventError);
			gateway.objectEncoding = 0;
			
			gateway.connect("http://wdmdsrv1.uwsp.edu/flashservices/gateway/");
			//insert statement that works!
			//gateway.call("Inpatient.Inpatient_Main.forms.insertPatientInfo", responder, fieldArray4, "TB_NEW_PATIENT_INFO", 1);
			//update statement that works!
			if(!newPatient)
				gateway.call("Inpatient.Inpatient_Main.forms.updateNewPatientInfo", responder, int(qrData[1]), 1, fieldArray4, "tb_new_patient_info");
			else 
				gateway.call("Inpatient.Inpatient_Main.forms.insertPatientInfo", new Responder(newPatientResult,newPatientFault), commonArray, "tb_patient_common");
		
		}
		private function newPatientResult(event:Object):void
		{
			patientID = uint(event);
			
			//add newly created ID to fieldArray at beginning
			field = new Object();
			field.field = "ID_DATE";
			field.value = 1;
			fieldArray4.unshift(field);
			
			var field:Object = new Object();
			field.field = "ID_PATIENT";
			field.value = patientID;
			fieldArray4.unshift(field);
			
			UI.hidePopUp(adminLoginPopup);
			finalAdminPopup = UI.createPopUp(AdminLayout.ADMIN_LAYOUT_POPUP, 550, 500);
			UI.hidePopUp(finalAdminPopup);
			UI.showPopUp(finalAdminPopup);
			var adminImageBtn:UIButton = UIButton(finalAdminPopup.findViewById("adminImageBtn"));
			var pinLabel:UILabelJT = UILabelJT(finalAdminPopup.findViewById("pinNumber"));
			
			//create pin
			pinString = "";
			for (var j:int = 0; j < 4; j++) 
			{
				pinString += Math.round(9 * Math.random());
			}
			
			pinLabel.text = pinString;
			
			adminImageBtn.addEventListener(UIButton.CLICKED, startAdminCamera);
			
			gateway.call("Inpatient.Inpatient_Main.forms.insertPatientInfo", responder, fieldArray4, "tb_new_patient_info");
		}
		
		protected function finishAdminProcess(event:Event):void
		{
			var commonArray:Array = new Array();
			var commonInfo:Object = new Object();
			
			commonInfo = new Object();
			commonInfo.field = "PIN"
			commonInfo.value = pinString;
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "RFID"
			commonInfo.value = "10057";
			patientInfoArray.push("10057");
			commonArray.push(commonInfo);
			
			commonInfo = new Object();
			commonInfo.field = "IMAGE_URL"
			commonInfo.value = "http://wdmdsrv1.uwsp.edu/MobileUWSPApp/imagedownload.php?name=" + patientID + "UserImage.jpg";
			patientInfoArray.push("http://wdmdsrv1.uwsp.edu/MobileUWSPApp/imagedownload.php?name=" + patientID + "UserImage.jpg");
			commonArray.push(commonInfo);
			
			gateway.call("Inpatient.Inpatient_Main.forms.updateNewPatientInfo", new Responder(finalAdminResult, finalAdminFault), patientID, 1, commonArray, "tb_patient_common");
			UI.hidePopUp(finalAdminPopup);
			UI.showActivityIndicator();
		}
		
		private function finalAdminFault(event:Object):void
		{
			//loop over fault structure
			for (var i:String in event) {
				trace (i + ": " + event[i]);
			}
		}
		
		private function finalAdminResult(event:Object):void
		{
			UI.hideActivityIndicator();
			UI.hidePopUp(finalAdminPopup);
			fms.addUser(patientInfoArray[0], patientInfoArray[1], patientInfoArray[2], "Entry", patientInfoArray[3]);
			//initApp();
			//UIeJT.redraw();
			//removeChild(calloutMenu);
		}
		
		protected function startAdminCamera(event:Event):void
		{
			uploadStatus = UILabelJT(finalAdminPopup.findViewById("uploadStatus"));
			var camera:CustomCamera = new CustomCamera(400);
			camera.addEventListener(CameraImageEvent.IMAGE_EVENT, sendImage);
			uploadStatus.text = "Not Uploaded";
		}
		
		//send image to database for storage
		protected function sendImage(event:CameraImageEvent):void
		{
			uploadStatus.text = "Uploading...";
			userImage = event.image;
			var file:FileManager = new FileManager("tmp/" + patientID + "UserImage.jpg", "http://wdmdsrv1.uwsp.edu/MobileUWSPApp/image.php");
			file.addEventListener("ImageUploaded", uploadComplete);
			file.addEventListener("UploadFail", uploadFail);
			file.saveImage(event.image.bitmapData);
			file.upload();
			UI.showActivityIndicator();
		}
		
		//image has succesfully uploaded
		//put taken image into the proper place in the UI
		protected function uploadComplete(event:Event):void
		{
			uploadStatus.text = "Upload finished";
			UI.hideActivityIndicator();
			var adminImage:UIImage = UIImage(finalAdminPopup.findViewById("adminImage"));
			adminImage.addChild(userImage);
			
			var adminFinish:UIButton = UIButton(finalAdminPopup.findViewById("adminReg"));
			adminFinish.addEventListener(UIButton.CLICKED, finishAdminProcess);
		}
		
		//image has failed to upload
		protected function uploadFail(event:Event):void
		{
			uploadStatus.text = "Upload Failed";
			UI.hideActivityIndicator();
		}
		
		private function newPatientFault(event:Object):void
		{
			//loop over fault structure
			for (var i:String in event) {
				trace (i + ": " + event[i]);
			}
		}
		
		protected function insertResult(event:Object):void
		{
			//trace("cfc result" + ": " + event.toString());
			trace('full form success');
		}
		
		protected function FaultEventError(event:Object):void
		{
			//loop over fault structure
			for (var i:String in event) {
				trace (i + ": " + event[i]);
			}
		}
		
		protected function sendFormsData(event:Event):void
		{
			trace('hit done');
		}
		
		protected function showHelpCallout():void
		{
			callout.visible = true;
		}
		
		private function setNavigation():void
		{
			_navigation.addEventListener(Event.CHANGE,navigatorChange);
			_navigation.navigationBar.rightArrow.visible = true;
			_navigation.navigationBar.rightArrow.addEventListener(MouseEvent.MOUSE_UP,gotoNextSection);
		}	
		
		protected function gotoNextSection(event:Event):void {
			_navigation.nextPage(UIPages.SLIDE_LEFT);
			navigatorChange();
		}
		
		protected function navigatorChange(event:Event=null):void {
			var lastPage:Boolean = _navigation.pageNumber == _navigation.pages.length -1;
			_navigation.navigationBar.rightArrow.visible = !lastPage;
			_navigation.navigationBar.rightButton.visible = lastPage;
			if(newPatient)
				_navigation.navigationBar.rightButton.addEventListener(MouseEvent.MOUSE_UP, showAdminPopup);
			else {
				//add listener here for when existing patient has completed forms
				_navigation.navigationBar.rightButton.addEventListener(UIButton.CLICKED,sendFormData);
			}
		}
		
		protected function showAdminPopup(event:MouseEvent):void
		{
			UI.showPopUp(adminPopup);
			adminSignIn = UIButton(adminPopup.findViewById("adminSignIn"));
			adminSignIn.addEventListener(UIButton.CLICKED, showAdminSignIn);
		}
		
		protected function showAdminSignIn(event:Event):void
		{
			UI.hidePopUp(adminPopup);
			adminSignIn.removeEventListener(UIButton.CLICKED, showAdminSignIn);
			
			UI.showPopUp(adminLoginPopup);
			adminSignIn = UIButton(adminLoginPopup.findViewById("adminSignIn"));
			var closeAdminSign:UIButton = UIButton(adminLoginPopup.findViewById("adminClose"));
			closeAdminSign.addEventListener(UIButton.CLICKED, function():void{UI.hidePopUp(adminLoginPopup);});
			adminSignIn.addEventListener(UIButton.CLICKED, adminNewPatient);
		}
		
		protected function adminNewPatient(event:Event):void
		{
			//create new patient page
			adminSignIn.removeEventListener(UIButton.CLICKED, adminNewPatient);
			sendForms();
		}
		
		protected function sendFormData(event:Event):void {
			//Send forms to database
			sendForms();
		}
		
		//list in splitview has been clicked
		protected function changePage(event:Event):void
		{
			var index:int = _list.index;
			if(index == 0 && _list.group == 0){
				_navigation = UINavigation(UI.findViewById("newPatientNav"));
				setNavigation();
				_form.goToPage(0,UIPages.SLIDE_RIGHT);
			} else if (index == 1 && _list.group == 0){
				if(!speechRunning) {
			  		stage.setOrientation(StageOrientation.ROTATED_LEFT);
			  
				    var timer:Timer = new Timer(500, 1);
				    timer.addEventListener(TimerEvent.TIMER_COMPLETE, createBodyMap);
				    timer.start();
				}
				else {
					addEventListener("SPEECH_CHANGED", runBodyMap);
					UI.dimUI();
					processing = new UILabel(this, 0, 0, "Waiting for Text To Speech Engine...", new TextFormat(null, 30, 0xFFFFFF));
					processing.x = stage.stageWidth / 2 - processing.width / 2;
					processing.y = stage.stageHeight / 2 - processing.height / 2;
				}
			} else if (index == 0 && _list.group == 1) {                                                    //added 6/7/2012
				UI.dimUI();
				_settingsPopUp = UI.createPopUp(PopupXML.SETTINGS_POPUP, 350, 290);
				
				helpPicker = UIPicker(_settingsPopUp.findViewById("helpPicker"));
				helpPicker.index = helpType;
				saveSettings = UIButton(_settingsPopUp.findViewById("saveSettings"));
				saveSettings.addEventListener(UIButton.CLICKED, saveSetting);
				closeSettings = UIButton(_settingsPopUp.findViewById("closeSettings"));
				closeSettings.addEventListener(UIButton.CLICKED, endSettings);
			}
		}
		
		protected function runBodyMap(event:Event):void
		{
			stage.setOrientation(StageOrientation.ROTATED_LEFT);
			
			var timer:Timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, createBodyMap);
			timer.start();
		}
		
		protected function createBodyMap(event:TimerEvent):void
		{
			var map:BodyMap = new BodyMap(stage.stageWidth, stage.stageHeight);
			addChild(map);
			UI.unDimUI();
			if(processing.stage)
				removeChild(processing);
		}
		
		protected function endSettings(event:Event):void                                //added 6/7/2012
		{
			UI.hidePopUp(_settingsPopUp);
		}
		
		protected function saveSetting(event:Event):void                                //added 6/7/2012
		{
			//add actual settings saving
			helpType = helpPicker.index;
			calloutMenu.index = helpType;
			
			UI.hidePopUp(_settingsPopUp);
		}
		
		protected function checkBoxChanged2(event:Event):void
		{
			var input:UIInputJT = UIInputJT(UI.findViewById("medAssistNonCoveredServ2"));
			var label:UILabel = UILabel(UI.findViewById("medAssistedNonCoveredServLab2"));
			if(event.currentTarget.state) {
				label.visible = true;
				input.visible = true;
			}
			else {
				label.visible = false;
				input.visible = false;
			}
		}
		
		protected function checkBoxChanged(event:Event):void
		{
			var input:UIInputJT = UIInputJT(UI.findViewById("medAssistNonCoveredServ1"));
			var label:UILabel = UILabel(UI.findViewById("medAssistedNonCoveredServLab"));
			if(event.currentTarget.state) {
				label.visible = true;
				input.visible = true;
			}
			else {
				label.visible = false;
				input.visible = false;
			}
		}
		
	}
}