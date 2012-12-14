package Sections.NewPatientInfo
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	public class DisclosePHI extends Sprite
	{
		public static const LAYOUT2:XML = <scrollVertical background="#DADED4" gapV="20">		
							<label alignH="fill"><b>Authorization to Disclose Protected Health Information (PHI) - only complete this section if the patient is over age 18</b></label>
							<label id="message0" alignH="fill">The purpose of the Notice of Privacy Practices is to describe to you how Bay Care Clinic may use and disclose your protected health information, certain restrictions on the use and disclosure of your healthcare information and your rights regarding protected health information.  BayCare Clinic will not make any unapproved disclosure of your PHI without your wirtten authorization*.  I hereby agree to permit BayCare Clinic to disclose my medical and billing protected health information to the following: (Example: spouse, friend, relative, etc.  This does not apply to other physicians, insurance carriers, or attorneys).</label>
							<columns gapH="10" widths="33.3%, 33.3%, 33.3%">
								<vertical>
									<touchLabel id="authFirstName" alignH="fill">First Name:</touchLabel>
									<input prompt="First Name" alignH="fill" id="discloseFirst1"></input>
								</vertical>
								<vertical>
									<touchLabel id="authLastName" alignH="fill">Last Name:</touchLabel>
									<input prompt="Last Name" alignH="fill" id="discloseLast1"></input>
								</vertical>
								<vertical>
									<touchLabel id="authRelationship" alignH="fill">Relationship:</touchLabel>
									<input prompt="Relationship" alignH="fill" id="discloseRelationship1"></input>
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="33.3%, 33.3%, 33.3%">
								<vertical>
									<label alignH="fill">First Name:</label>
									<input prompt="First Name" alignH="fill" id="discloseFirst2"></input>
								</vertical>
								<vertical>
									<label alignH="fill">Last Name:</label>
									<input prompt="Last Name" alignH="fill" id="discloseLast2"></input>
								</vertical>
								<vertical>
									<label alignH="fill">Relationship:</label>
									<input prompt="Relationship" alignH="fill" id="discloseRelationship2"></input>
								</vertical>
							</columns>
							<line></line>
							<image>5</image>
							<checkBoxJT id="authAuthorize">I do not authorize the release of my medical or billing information.</checkBoxJT>
							<image>5</image>
							<line></line>
							<columns gapH="10" widths="50%">
								<vertical>
									<touchLabel id="authPassword" alignH="fill">Password:</touchLabel>
									<input prompt="Optional" alignH="fill" id="disclosePassword"></input>
								</vertical>
							</columns>
							<label alignH="fill">*This consent is subject to the provisions outlined in our Notice of Privacy Practices and includes any BayCare Clinic provider(s).  This consent is valid indefinitely unless amended or revoked.</label>
							<image>350</image>
				</scrollVertical>;
	}
}