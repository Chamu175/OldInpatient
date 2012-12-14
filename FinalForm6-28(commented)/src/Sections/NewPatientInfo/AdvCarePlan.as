package Sections.NewPatientInfo
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	public class AdvCarePlan extends Sprite
	{
		public static const LAYOUT3:XML = <scrollVertical background="#DADED4" gapV="20">		
							<label alignH="fill"><b>Advanced Care Planning/Advanced Directive - only complete this section if the patient is over age 18</b></label>
							<label alignH="fill"><u>Advanced Care Planning</u>&nbsp;Preparing for how your health care treatment options will be addresse when you are unable to speak for yourself.  Advanced Directives (documents that speak for you) communicate with family & friends your preference for care.</label>
							<columns gapH="10" widths="50%, 50%">
								<vertical>
									<label alignH="fill"><u>Living Will</u>&nbsp;States what you want, but does not give anyone authority to make decisions on your behalf.</label>
								</vertical>
								<vertical>
									<touchLabel id="advLivingWill" alignH="ffill">Do you have a living will?</touchLabel>
									<horizontal>
										<radioButtonJT id="advCareLivingWillYes">Yes</radioButtonJT>
										<radioButtonJT id="advCareLivingWillNo">No</radioButtonJT>
									</horizontal>
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="50%, 50%">
								<vertical>
									<touchLabel id="advPowerAttorney" alignH="fill">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<u>Power of Attorney for Healthcare</u>&nbsp;A document in which you appoint an agent to make decisions regarding your care when you cannot make your own decisions</touchLabel>
								</vertical>
								<vertical>
									<label alignH="fill">Do you have a Power of Attorney for Healthcare?</label>
									<horizontal>
										<radioButtonJT id="advCarePowerAttorneyYes">Yes</radioButtonJT>
										<radioButtonJT id="advCarePowerAttorneyNo">No</radioButtonJT>
									</horizontal>
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="50%, 50%">
									<touchLabel id="advDocumentKept" alignH="fill">If you answered "Yes" to either of the above questions, please indicate where the document is kept below:</touchLabel>
									<input id="advCareDocumentKept" alignH="fill" prompt="Where document is kept"></input>
							</columns>
							<line></line>
							<columns gapH="10" widths="100%">
								<vertical>
									<touchLabel id="advPacket" alignH="fill">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you answered "No" to one or both of the above questions, would you like an&nbsp;<u>Advanced Care Planning</u>&nbsp; Packet?</touchLabel>
									<horizontal>
										<radioButtonJT id="advCarePlanningPacketYes">Yes</radioButtonJT>
										<radioButtonJT id="advCarePlanningPacketNo">No</radioButtonJT>
									</horizontal>
								</vertical>
							</columns>
							<line></line>
							<image>15</image>
							<label alignH="fill">I certify the information on this form is true to the best of my knowledge.  I accept responsibility for the medical charges incurred by the patient and agree to pay bills at time of service unless other arrangements are made.  I authorize my insurance claim to e paid directly to the clinic.  I further understand my health care insurance carrier or payer of my health benefits may pay less than the actual bill for services, and I am ultimately responsible for any balances.  I also understand I am responsible for all second opinion and pre-admission review requirements.  I acknowledge that BayCare Clinic has provided me with a copy of their Privacy Practices.</label>
							<image>15</image>
							<columns gapH="10" widths="50%, 50%">
								<vertical>
									<label id="planningSig" alignH="fill">Signature:</label>
									<input id="advCareSig" alignH="fill"></input>
								</vertical>
								<vertical>
									<label id="planningDate" alignH="fill">Date:</label>
									<input id="advCareSigDate" alignH="fill"></input>
								</vertical>
							</columns>
							<image>350</image>
				</scrollVertical>;
		
		
		public function AdvCarePlan()
		{
			super();
		}
	}
}