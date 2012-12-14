package customClasses
{
	import Sections.ChangeInAuth.*;
	import Sections.ChildNeuroQuestion.*;
	import Sections.CommercialInsuranceWaiver.*;
	import Sections.ConsentEval.*;
	import Sections.ConsentTreatMinor.*;
	import Sections.CurrentHealthAssess.*;
	import Sections.CurrentMeds.*;
	import Sections.Drawer.*;
	import Sections.ElbowSurvey.*;
	import Sections.Form2.*;
	import Sections.InformedConsPatientCare.*;
	import Sections.InjuryQuestionnaire.*;
	import Sections.MedAssistancePaymentAgreement.*;
	import Sections.NewPatientInfo.*;
	import Sections.PatientHealthHistory.*;
	import Sections.PatientHealthHistory2.*;
	import Sections.PatientPain.*;
	import Sections.ReqNonCovServices.*;
	import Sections.ShoulderSurvey.*;
	import Sections.Urology.*;
	
	import com.danielfreeman.extendedMadness.*;
	import com.danielfreeman.madcomponents.*;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	/*import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.config.*;
	import mx.messaging.messages.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import mx.utils.ObjectProxy;*/

	
	
	public class PatientFormWireframe extends Sprite
	{
		
		/*registerClassAlias("flex.messaging.messages.RemotingMessage", RemotingMessage);
		registerClassAlias("flex.messaging.messages.CommandMessage",CommandMessage);
		registerClassAlias("flex.messaging.messages.AcknowledgeMessage",
			AcknowledgeMessage);
		registerClassAlias("flex.messaging.messages.ErrorMessage", ErrorMessage);
		registerClassAlias("DSC", CommandMessageExt);
		registerClassAlias("DSK", AcknowledgeMessageExt);
		registerClassAlias("flex.messaging.io.ArrayList", ArrayList);
		registerClassAlias("flex.messaging.config.ConfigMap", ConfigMap);
		registerClassAlias("flex.messaging.io.ArrayCollection", ArrayCollection);
		registerClassAlias("flex.messaging.io.ObjectProxy", ObjectProxy);
		
		// You may want to register pub/sub and other rpc message types too...
		registerClassAlias("flex.messaging.messages.HTTPMessage", HTTPRequestMessage);
		registerClassAlias("flex.messaging.messages.SOAPMessage", SOAPMessage);
		registerClassAlias("flex.messaging.messages.AsyncMessage", AsyncMessage);
		registerClassAlias("DSA", AsyncMessageExt);
		registerClassAlias("flex.messaging.messages.MessagePerformanceInfo",
			MessagePerformanceInfo);*/
		
		
		//TODO: TRY to figure out a better config file
		//////////////////////////// DATA FOR BOTH APPLICATIONS ////////////////////////////
		protected static const DATA:XML = <data>
											<item label="Minor Consent"/>
											<item label="Medical Assistance Payment Agreement"/>
											<item label="Shoulder Survey"/>
											<item label="Toggle Help"/>
										  </data>;
		//////////////////////////////////// END DATA //////////////////////////////////////////////	
		
		/*<item label="Patient Information"/>
			<item label="Form2"/>
			<item label="Patient Health History"/>
			<item label="Injury Questionnaire"/>
			<item label="Medical Assistance Payment Agreement"/>
			<item label="Request For Non-Covered Services"/>
			<item label="Commercial Insurance Waiver Notice"/>
			<item label="Minor Consent"/>
			<item label="Informed Consent"/>
			<item label="Change in Authorization"/>
			<item label="Current Medications"/>
			<item label="Consent for Evaluation"/>
			<item label="Child Neuropsychological History Questionnaire"/>
			<item label="Current Health Assessment"/>
			<item label="Patient Health History 2"/>
			<item label="Patient Pain Questionnaire"/>
			<item label="Elbow Survey"/>
			<item label="Urology"/>
			<item label="Toggle Help" />
			<item label="Speech" />
			<item label="Shoulder Survey" />*/
		
		/////////////////////////////Navigation///////////////////////////////////////////////
		
		protected static const NEW_PATIENT_INFO_NAV:XML =
			<navigation title="New Patient Information" background="#FFFFFF" colour="#666677" id="newPatientInfoNav">
				{PatientInfo.LAYOUT}
				{InsurCardHoldInfo.LAYOUT4}
				{DisclosePHI.LAYOUT2}
				{AdvCarePlan.LAYOUT3}
			</navigation>;
		
		protected static const FORM2_NAV:XML =
			<navigation title="Form2" background="#FFFFFF" colour="#666677" id="form2Nav">
				{Form2Sec1.LAYOUT5}
				{Form2Sec2.LAYOUT6}
			</navigation>;
			
		protected static const PATIENT_HEALTH_HISTORY_NAV:XML = 
			<navigation title="Patient Health History" background="#FFFFFF" colour="#666677" id="patientHealthHistoryNav">
				{PatientInfoHist.LAYOUT7}
				{CurrentIllnessOrComplaint.LAYOUT8}
				{PersonalMedHistory.LAYOUT9}
				{SurgicalHistory.LAYOUT10}
				{SocialHistory.LAYOUT11}
				{FamilyHistory.LAYOUT12}
				{ReviewOfSystems.LAYOUT13}
				{ExtraAndSignature.LAYOUT14}
			</navigation>;
				
		protected static const INJURY_QUESTIONNAIRE_NAV:XML = 
			<navigation title="Injury Questionnaire" background="#FFFFFF" colour="#666677" id="injuryQuestionnaireNav">
				{Questionnaire.LAYOUT15}
		</navigation>;
		
		protected static const MED_ASSISTANCE_PAY_NAV:XML = 
			<navigation title="Medical Assistance Payment Agreement" background="#FFFFFF" colour="#666677" id="medAssistancePaymentNav">
			{MedAssistPayAgreement.LAYOUT17}
		</navigation>;
		
		protected static const REQ_NON_COVERED_NAV:XML = 
			<navigation title="Request For Non-Covered Services" background="#FFFFFF" colour="#666677" id="reqNonCoveredNav">
			{ReqNonCoveredServices.LAYOUT18}
		</navigation>;
		
		protected static const COMMERCIAL_INSURANCE_NAV:XML = 
			<navigation title="Commercial Insurance Waiver Notice" background="#FFFFFF" colour="#666677" id="commercialInsuranceNav">
			{CommercialInsuranceWaiverNotice.LAYOUT19}
		</navigation>;
		
		protected static const MINOR_CONSENT_NAV:XML = 
			<navigation title="Minor Consent" background="#FFFFFF" colour="#666677" id="minorConsentNav">
			{ChangeInAuthorization.LAYOUT22}
		</navigation>;
		
		protected static const INFORMED_CONSENT_NAV:XML = 
			<navigation title="Informed Consent" background="#FFFFFF" colour="#666677" id="informedConsentNav">
			{ConsentTreatmentMinor.LAYOUT20}
		</navigation>;
		
		protected static const CHANGE_IN_AUTH_NAV:XML = 
			<navigation title="Change in Authorization" background="#FFFFFF" colour="#666677" id="changeInAuthNav">
			{InformedConsentPatientCare.LAYOUT21}
		</navigation>;
		
		protected static const CURRENT_MEDS_NAV:XML = 
			<navigation title="Current Medication" background="#FFFFFF" colour="#666677" id="currentMedsNav">
			{CurrentMedicationList.LAYOUT22}
		</navigation>;
		
		protected static const CONSENT_EVAL_NAV:XML = 
			<navigation title="Consent for Evaluation and/or Treatment" background="#FFFFFF" colour="#666677" id="consentEvalNav">
			{ConsentEvaluation.LAYOUT23}
		</navigation>;
		
		protected static const CHILD_NEURO_NAV:XML = 
			<navigation title="Child/Adolescent Neuropsychological History Questionnaire" background="#FFFFFF" colour="#666677" id="childNeuroNav">
			{ChildNeurologicalQuestionnaire.LAYOUT24}
			{ChildNeurologicalQuestionnaire2.LAYOUT25}
			{ChildNeurologicalQuestionnaire3.LAYOUT26}
			{ChildNeurologicalQuestionnaire4.LAYOUT27}
			{ChildNeurologicalQuestionnaire5.LAYOUT28}
			{ChildNeurologicalQuestionnaire6.LAYOUT29}
			{ChildNeurologicalQuestionnaire7.LAYOUT30}
			{ChildNeurologicalQuestionnaire8.LAYOUT31}
			{ChildNeurologicalQuestionnaire9.LAYOUT32}
			{ChildNeurologicalQuestionnaire10.LAYOUT33}
			{ChildNeurologicalQuestionnaire11.LAYOUT34}
			{ChildNeurologicalQuestionnaire12.LAYOUT35}
			{ChildNeurologicalQuestionnaire13.LAYOUT36}
			{ChildNeurologicalQuestionnaire14.LAYOUT37}
		</navigation>;
			
		protected static const CUR_HEALTH_NAV:XML = 
			<navigation title="Current Health Assessment" background="#FFFFFF" colour="#666677" id="curHealthNav">
			{CurrentHealthAssessment.LAYOUT38}
		</navigation>;
		
		protected static const PAT_HEALTH_2_NAV:XML = 
			<navigation title="Patient Health History" background="#FFFFFF" colour="#666677" id="patHealth2Nav">
			{PatHealthHis.LAYOUT39}
			{PatientHealthHistory2.LAYOUT70}
		</navigation>;
			
		protected static const PAT_PAIN_NAV:XML = 
			<navigation title="Patient Pain Questionnaire" background="#FFFFFF" colour="#666677" id="patPainNav">
			{PatientPainQuestionnaire1.LAYOUT60}
			{PatientPainQuestionnaire2.LAYOUT61}
			{PatientPainQuestionnaire3.LAYOUT62}
		</navigation>;
			
		protected static const ELBOW_NAV:XML = 
		<navigation title="Elbow Survey" background="#FFFFFF" colour="#666677" id="elbowNav">
			{ElbowSurvey1.LAYOUT64}
			{ElbowSurvey2.LAYOUT65}
			{ElbowSurvey3.LAYOUT66}
		</navigation>;
			
		protected static const UROLOGY_NAV:XML = 
		<navigation title="Urology Patient History" background="#FFFFFF" colour="#666677" id="urologyNav">
			{UrologyPatientHistory1.LAYOUT67}
			{UrologyPatientHistory2.LAYOUT68}
		</navigation>;
			
		protected static const SHOULDER_NAV:XML = 
		<navigation title="Shoulder Survey" background="#FFFFFF" colour="#666677" id="shoulderNav">
			{ShoulderSurvey.LAYOUT40}
			{ShoulderSurveyMobility.LAYOUT41}
		</navigation>;
	
		protected static const DRAWER_NAV:XML =
			<navigation id="drawerNav">
				{Drawer.LAYOUT16}
			</navigation>;
			
		
		protected static const CALLOUT_LAYOUT:XML = 
			<vertical alignH="fill" width="200" height="150" colour="#DD9999">
        		<label>A feeling of worry, nervousness, or unease, typically about an imminent event or something with an uncertain outcome.</label>
				<button colour="#669966" id="closeHelp">Ok</button>
			</vertical>;
		
		/////////////////////////////End navigation//////////////////////////////////////////
		
		/////////////////////////// TABLET XML DEFINITION //////////////////////////////////	
		// List can also be masked for a wrapping effect
		//protected static var SPLITVIEW:XML; --uncomment
		
		protected static const SPLITVIEW:XML = 
						<columns stageColour="#00FF00" id="myCols" gapH="4" widths="25%, 75%" background="#707449" border="false">
					   		<vertical id="myScroll" background="#E4D1B0">
								<list id="myList" colour="#c10000" autoLayout="true">
									<search colour="#D66821" field="label"/>
									{DATA}
									<label id="label" alignH="fill"/>
								</list>
							</vertical>
							<pages id="myForms">
								{MINOR_CONSENT_NAV}
								{MED_ASSISTANCE_PAY_NAV}
								{SHOULDER_NAV}
								{DRAWER_NAV}
							</pages>
						</columns>;

								/*{NEW_PATIENT_INFO_NAV}
								{FORM2_NAV}
								{PATIENT_HEALTH_HISTORY_NAV}
								{INJURY_QUESTIONNAIRE_NAV}
								{MED_ASSISTANCE_PAY_NAV}
								{REQ_NON_COVERED_NAV}
								{COMMERCIAL_INSURANCE_NAV}
								{MINOR_CONSENT_NAV}
								{INFORMED_CONSENT_NAV}
								{CHANGE_IN_AUTH_NAV}
								{CURRENT_MEDS_NAV}
								{CONSENT_EVAL_NAV}
								{CHILD_NEURO_NAV}
								{CUR_HEALTH_NAV}
								{PAT_HEALTH_2_NAV}
								{PAT_PAIN_NAV}
								{ELBOW_NAV}
								{UROLOGY_NAV}
								{DRAWER_NAV}
								{SHOULDER_NAV}*/
		
		
				
		protected static var FORMS:XML = new XML();
		protected static var currentDept:XML = new XML();
		private var XMLURLRequest:URLRequest = new URLRequest("config.xml");
		private var XMLURLLoader:URLLoader = new URLLoader(XMLURLRequest);	
		///private var pagesXML:XML = new XML(<pages id="myForms"/>); --uncomment
		//will get forms from config file depending on which department the tablet is in
		
		protected var _form:UIPages;
		protected var _list:UIList;
		protected var _navigation:UINavigation;
		
		protected var callout:UIDropWindow;
		protected var _anxietyLabel:UILabel;
		protected var _anxietyHelp:UIButton;
		protected var _anxietyHelpClose:UIButton;
		private var _closeDrawer:UIButton;
		private var helpToggle:Boolean = false;
		
		/////////////////////////// END TABLET ///////////////////////////////////////////////
		
		
		///////////////////////////// INDEPENDENT CLASS VARS //////////////////////////////////	
		protected var _resY:int = Capabilities.screenResolutionX;
		protected var _resX:int = Capabilities.screenResolutionY;
		protected var _dpi:int = Capabilities.screenDPI;
		//private var RO:RemoteObject = new RemoteObject("ColdFusion");
		private var acData:Array;
		
		
		private var lastName:UIInput;
		
		///////////////////////////// END CLASS VARS //////////////////////////////////////////
		
		
		//////////////////////////// CONSTRUCTOR /////////////////////////////////////////////	
		public function PatientFormWireframe(screen:Sprite = null) {
			
			if (screen){
				screen.addChild(this);
			}
			
			trace("Screen Resolution is " + _resX + "x" + _resY + " at " + _dpi + "ppi");
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//XMLURLLoader.addEventListener("complete", xmlLoaded); --uncomment
			initializeTablet();
			
			//starts coldfusion process
			creationCompleteHandler();
			
			lastName = UIInput(UI.findViewById("txtLastName"));
		}
		
		
		
		private function connectAMF():void {
			//amfChannel.enableSmallMessages = false;
			//cs.addChannel(amfChannel);
			/*consumer.channelSet = cs;
			consumer.subscribe();
			producer.channelSet = cs;*/
		}
		
		protected function openCallout(event:Event):void
		{
			//gives error type conversion with Static Object error...
			//var callout:UIDropWindow = UIe.showCallOut(CALLOUT_LAYOUT, 400, 200);
			callout = UIDropWindow(UIe.showCallOut(CALLOUT_LAYOUT, 400, 200));
			
			//MadComponents buttons x and y come in as 0...
			trace(_anxietyHelp.x);
			trace(_anxietyHelp.y);
			
			//need to add listener to window??
			_anxietyHelpClose = UIButton(callout.findViewById("closeHelp"));
			_anxietyHelpClose.addEventListener(UIButton.CLICKED, closeCallout);
			
		}
		
		protected function closeCallout(event:Event):void
		{
			_anxietyHelpClose.removeEventListener(UIButton.CLICKED, closeCallout);
			callout.destructor();
			UI.windowLayer.removeChild(callout);
		}
		
		private function xmlLoaded(event:Event):void
		{
			FORMS = XML(XMLURLLoader.data);
			currentDept = XML(FORMS.Department.(@name == "Cardiothoracic Surgery"));
			var myXMLArray:Array = new Array();
			for each(var xml:XML in currentDept.navigation)
			{
				switch(xml.toString())
				{
					case "newPatientInfoNav":
						myXMLArray.push(<navigation title="New Patient Information" background="#FFFFFF" colour="#666677" id="newPatientInfoNav">
							{PatientInfo.LAYOUT}
							{InsurCardHoldInfo.LAYOUT4}
							{DisclosePHI.LAYOUT2}
							{AdvCarePlan.LAYOUT3}
							</navigation>);
						break;
					case "form2Nav":
						myXMLArray.push(<navigation title="Form2" background="#FFFFFF" colour="#666677" id="form2Nav">
							{Form2Sec1.LAYOUT5}
							{Form2Sec2.LAYOUT6}
							</navigation>);
						break;
				}
			}
			
			
			while(myXMLArray.length > 0)
			{
				//pagesXML.appendChild(XML(myXMLArray.shift())); --uncomment
			}
			
			//trace("pages: " + pagesXML);
			
			/*SPLITVIEW= <columns stageColour="#A15D6F" id="myCols" gapH="4" widths="20%, 55%" background="#707449">
					   		<vertical id="myScroll" background="#E4D1B0">
								<list id="myList" colour="#c10000" autoLayout="true">
									<search colour="#D66821" field="label"/>
									{DATA}
									<label id="label" alignH="fill"/>
								</list>
							</vertical>
							{pagesXML}
						</columns>;
			--uncomment
			*/ 
							
							
			//initializeTablet(); --uncomment
			//TODO: to get back to normal: splitview goes up above, as protected static const
			//return pages underneath vertical
			//return nav views under pages
			//uncomment the initializeTablet in constuctor, and comment out xmlloaded
			//trace("Data loaded. " + currentDept.navigation);
		}
		
		/////////////////////// TABLET ////////////////////////////////
		private function initializeTablet():void
		{
			
			// Create the main UI or "Landing Page"
			UIe.activate(this);
			UI.create(this, SPLITVIEW);
			
			//trace("Splitview" + SPLITVIEW);
			
			// Initialize "views"
			//var patientInfo:frm_New_Patient_Info_PatientInfo = new frm_New_Patient_Info_PatientInfo();
			//PatientInfo.initialize();
			//frm_New_Patient_Info_DisclosePHI.initialize();
			//frm_New_Patient_Info_AdvCarePlan.initialize();
			//frm_New_Patient_Info_InsurCardHoldInfo.initialize();  
			
			// Add the list 
			_list = UIList(UI.findViewById("myList"));
			
			
			// Add the pages component
			_form = UIPages(UI.findViewById("myForms"));
			//trace("forms: " + SPLITVIEW);
			//trace("nav id: " + currentDept.navigation[0].attribute("id"));
			_navigation = UINavigation(UI.findViewById("minorConsentNav"));
			//trace(_navigation);
			setNavigation();
			
			
			_anxietyHelp = UIButton(UI.findViewById("histAnxietyHelp"));
			_closeDrawer = UIButton(UI.findViewById("closeDrawerBtn"));
				
			
			trace(_anxietyHelp);
			addEventListeners();
		}
		
		private function addEventListeners():void
		{
			_list.addEventListener(UIList.CLICKED, changePage);
			//_anxietyHelp.addEventListener(UIButton.CLICKED, openCallout);
			_closeDrawer.addEventListener(UIButton.CLICKED, closeDrawer);
			
			//throws null error...
			//_anxietyHelpClose.addEventListener(UIButton.CLICKED, closeCallout);
		}		
		
		protected function closeDrawer(event:Event):void
		{
			_form.goToPage(3, UIPages.DRAWER_DOWN);
			helpToggle = !helpToggle;
		}
		
		protected function changePage(event:Event):void
		{
			
			// TODO: holder page @ index 0 in DATA constant so first page is 1 and second is two. Holder will have a cool logo or something
			var index:int = _list.index;
			if(index == 0){
				_navigation = UINavigation(UI.findViewById("minorConsentNav"));
				setNavigation();
				_form.goToPage(0,UIPages.SLIDE_RIGHT);
			} else if (index == 1){
				_navigation = UINavigation(UI.findViewById("medAssistancePaymentNav"));
				setNavigation();
				_form.goToPage(1,UIPages.SLIDE_RIGHT);
			} else if (index == 2){
				_navigation = UINavigation(UI.findViewById("shoulderNav"));
				setNavigation();
				_form.goToPage(2,UIPages.SLIDE_RIGHT);
			} else if (index == 3){
				if (helpToggle == true) {
					//closing drawer
					helpToggle = false;
					_form.goToPage(3,UIPages.DRAWER_DOWN);
					//openDrawer();
				} else if (helpToggle == false) {
					//opening drawer
					helpToggle = true;
					_form.goToPage(3,UIPages.DRAWER_UP);
				}
			}
			
			// Navigation logic
			/*if(index == 0){
				_navigation = UINavigation(UI.findViewById("newPatientInfoNav"));
				setNavigation();
				_form.goToPage(0,UIPages.SLIDE_RIGHT);
			} else if (index == 1){
				_navigation = UINavigation(UI.findViewById("form2Nav"));
				setNavigation();
				_form.goToPage(1,UIPages.SLIDE_RIGHT);
			} else if (index == 2){
				_navigation = UINavigation(UI.findViewById("patientHealthHistoryNav"));
				setNavigation();
				_form.goToPage(2,UIPages.SLIDE_RIGHT);
			} else if (index == 3){
				_navigation = UINavigation(UI.findViewById("injuryQuestionnaireNav"));
				setNavigation();
				_form.goToPage(3,UIPages.SLIDE_RIGHT);
			} else if (index == 4){
				_navigation = UINavigation(UI.findViewById("medAssistancePaymentNav"));
				setNavigation();
				_form.goToPage(4,UIPages.SLIDE_RIGHT);
			} else if (index == 5){
				_navigation = UINavigation(UI.findViewById("reqNonCoveredNav"));
				setNavigation();
				_form.goToPage(5,UIPages.SLIDE_RIGHT);
			} else if (index == 6){
				_navigation = UINavigation(UI.findViewById("commercialInsuranceNav"));
				setNavigation();
				_form.goToPage(6,UIPages.SLIDE_RIGHT);
			} else if (index == 7) {
				_navigation = UINavigation(UI.findViewById("minorConsentNav"));
				setNavigation();
				_form.goToPage(7,UIPages.SLIDE_RIGHT);
			} else if (index == 8) {
				_navigation = UINavigation(UI.findViewById("informedConsentNav"));
				setNavigation();
				_form.goToPage(8,UIPages.SLIDE_RIGHT);
			} else if (index == 9) {
				_navigation = UINavigation(UI.findViewById("changeInAuthNav"));
				setNavigation();
				_form.goToPage(9,UIPages.SLIDE_RIGHT);
			} else if (index == 10) {
				_navigation = UINavigation(UI.findViewById("currentMedsNav"));
				setNavigation();
				_form.goToPage(10,UIPages.SLIDE_RIGHT);
			} else if (index == 11) {
				_navigation = UINavigation(UI.findViewById("consentEvalNav"));
				setNavigation();
				_form.goToPage(11,UIPages.SLIDE_RIGHT);
			} else if (index == 12) {
				_navigation = UINavigation(UI.findViewById("childNeuroNav"));
				setNavigation();
				_form.goToPage(12,UIPages.SLIDE_RIGHT);
			} else if (index == 13) {
				_navigation = UINavigation(UI.findViewById("curHealthNav"));
				setNavigation();
				_form.goToPage(13,UIPages.SLIDE_RIGHT);
			} else if (index == 14) {
				_navigation = UINavigation(UI.findViewById("patHealth2Nav"));
				setNavigation();
				_form.goToPage(14,UIPages.SLIDE_RIGHT);
			} else if (index == 15) {
				_navigation = UINavigation(UI.findViewById("patPainNav"));
				setNavigation();
				_form.goToPage(15,UIPages.SLIDE_RIGHT);
			} else if (index == 16) {
				_navigation = UINavigation(UI.findViewById("elbowNav"));
				setNavigation();
				_form.goToPage(16,UIPages.SLIDE_RIGHT);
			} else if (index == 17) {
				_navigation = UINavigation(UI.findViewById("urologyNav"));
				setNavigation();
				_form.goToPage(17,UIPages.SLIDE_RIGHT);
			} else if (index == 18) {
				//help mode toggled
				if (helpToggle == true) {
					//closing drawer
					helpToggle = false;
					_form.goToPage(18,UIPages.DRAWER_DOWN);
					//openDrawer();
				} else if (helpToggle == false) {
					//opening drawer
					helpToggle = true;
					_form.goToPage(18,UIPages.DRAWER_UP);
				}
			} else if (index == 19) {
				trace('native speech exension');
			} else if (index == 20) {
				trace('shoulder survey');
				_navigation = UINavigation(UI.findViewById("shoulderNav"));
				setNavigation();
				_form.goToPage(19,UIPages.SLIDE_RIGHT);
			}*/

		}
		
		private function setNavigation():void
		{
			_navigation.addEventListener(Event.CHANGE,navigatorChange);
			_navigation.navigationBar.rightArrow.visible = true;
			_navigation.navigationBar.rightArrow.addEventListener(MouseEvent.MOUSE_UP,gotoNextSection);
			_navigation.navigationBar.rightButton.addEventListener(UIButton.CLICKED,goBack);
		}		
		
		protected function gotoNextSection(event:Event):void {
			if (_navigation.pageNumber == 0) {
				//this is how to send data to db
				//insertNewPatient(lastName.text);
			}
			
			//InsurCardHoldInfo.initialize();  
			_navigation.nextPage(UIPages.SLIDE_LEFT);
			navigatorChange();
			
		}
		
		protected function navigatorChange(event:Event=null):void {
			var lastPage:Boolean = _navigation.pageNumber == _navigation.pages.length -1;
			_navigation.navigationBar.rightArrow.visible = !lastPage;
			_navigation.navigationBar.rightButton.visible = lastPage;
		}
		
		protected function goBack(event:Event):void {
			_navigation.previousPage(UIPages.SLIDE_RIGHT);
			navigatorChange();
		}
		
		protected function creationCompleteHandler():void
		{
			//RO.endpoint = "http://localhost:8501/flex2gateway";
			//RO.addEventListener(FaultEvent.FAULT, FaultEventError);      
			//RO.source = "Inpatient.formsCFCs.newPatientInformation";
			//RO.source = "Inpatient.formsCFCs.qrCode";
		}
		
		protected function insertNewPatient(lastNameIncoming:String):void{
			
			
			//(FIRSTNAME, LASTNAME, MI, SSN, RACE, DOB)
			var dob:Number = Date.parse("09/30/1989");
			//RO.insertPatientCommonInfo("Dan", lastNameIncoming, "J", "234-56-7890", "white", dob);
			trace("after insert patient");
		}
		
		
		/*protected function FaultEventError(e:FaultEvent):void {                 
			trace("Fault " +e.message.toString());
		}
		
		
		protected function button1_clickHandler(event:MouseEvent):void
		{
			RO.addEventListener(ResultEvent.RESULT, getPatientInfo_EventHandler);
			RO.getPatientCommonInfo(2);
		}
		
		protected function getPatientInfo_EventHandler(e:ResultEvent):void
		{
			//data from CF
			acData = e.result as Array;
			var fName:String;
			var lName:String;
			var ssn:String;
			//parses through data
			trace("length: " + acData.length);
			for (var i:int = 0; i < acData.length; i++) {                           
				//data returned
				fName = acData[i].FIRSTNAME;
				lName = acData[i].LASTNAME;
				ssn = acData[i].SSN;
				trace("firstname: " + fName + ", Lastname: " + lName + ", SSN: " + ssn);
			}
			
			/*     var child:Child = new Child(id, fName, mName, lName);
			
			trace(child.id, child.fname, child.mName, child.lName);
			//dispatch event back to Login
			this.dispatchEvent(new CustomEvent(CustomEvent.ON_LOADED, child)); */
			
		}*/
		////////////////////// END TABLET ////////////////////////////////
		
	}
}