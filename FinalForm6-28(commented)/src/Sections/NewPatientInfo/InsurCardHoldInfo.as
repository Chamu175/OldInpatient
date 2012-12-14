package Sections.NewPatientInfo
{
	import com.danielfreeman.madcomponents.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	public class InsurCardHoldInfo extends Sprite
	{
		public static const LAYOUT4:XML = <scrollVertical background="#DADED4" gapV="20">											
							<label id="message0" alignH="fill"><b>Insurance Card Holder Information</b></label>
							<checkBoxJT id="sameAsPatient">Same as patient</checkBoxJT>
							<columns gapH="10" widths="40%, 40%, 20%">
								<vertical>
									<touchLabel id="insLastName" alignH="fill">Last Name:</touchLabel>
									<input prompt="Last Name" alignH="fill" id="txtInsuranceLastName"></input>
								</vertical>
								<vertical>
									<touchLabel id="insFirstName" alignH="fill">First Name:</touchLabel>
									<input prompt="First Name" alignH="fill" id="txtInsuranceFirstName"></input>
								</vertical>
								<vertical>
									<touchLabel id="insMiddleInitial" alignH="fill">MI:</touchLabel>
									<input prompt="MI" alignH ="fill" id="txtInsuranceMI"></input>
								</vertical>
							</columns>
							<line></line>
							<columns widths="50%,50%" gapH="10">
								<vertical>
									<touchLabel id="insSSN" alignH="fill">SSN:</touchLabel>
									<input prompt="SSN" alignH="fill" id="txtInsuranceSSN"></input>							
								</vertical>
								<vertical>
									<touchLabel id="insDOB" alignH="fill">Date of Birth:</touchLabel>
									<input prompt="DOB" alignH="fill" id="txtInsuranceDOB"></input>							
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="30%,70%">
								<vertical>
									<touchLabel id="insSex" alignH="fill">Sex:</touchLabel>
									<horizontal>
										<radioButtonJT id="radInsuranceMale">Male</radioButtonJT>
										<radioButtonJT id="radInsuranceFemale">Female</radioButtonJT>
									</horizontal>
								</vertical>
								<vertical>
									<touchLabel id="insStreetAddress" alignH="fill">Home Address (if different from patient):</touchLabel>
									<input prompt="Home Address" alignH="fill" id="txtInsuranceStreetAddress"></input>
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="25%, 20%, 20%, 35%">
								<vertical>
									<touchLabel id="insCity" alignH="fill">City:</touchLabel>
									<input prompt="City" alignH="fill" id="txtInsuranceCity"></input>
								</vertical>
								<vertical>
									<touchLabel id="insState" alignH="fill">State:</touchLabel>
									<input prompt="State" alignH="fill" id="txtInsuranceState"></input>
								</vertical>
								<vertical>
									<touchLabel id="insZip" alignH="fill">Zip:</touchLabel>
									<input prompt="Zip" alignH="fill" id="txtInsuranceZip"></input>					
								</vertical>
								<vertical>
									<touchLabel id="insPatientRelationship" alignH="fill">Relationship to Patient:</touchLabel>
									<input prompt="Relationship to Patient" alignH="fill" id="txtInsuranceRelationship"></input>					
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="30%, 30%, 40%">
								<vertical>
									<touchLabel id="insHomePhone" alignH="fill">Home Phone:</touchLabel>
									<input prompt="Home Phone" alignH="fill" id="txtInsuranceHomePh"></input>
								</vertical>
								<vertical>
									<touchLabel id="insWorkPhone" alignH="fill">Work Phone:</touchLabel>
									<input prompt="Work Phone" alignH="fill" id="txtInsuranceWorkPh"></input>
								</vertical>
								<vertical>
									<touchLabel id="insEmployerName" alignH="fill">Employer's name, who provides coverage (if applicable):</touchLabel>
									<input prompt="Employer's name" alignH="fill" id="txtInsuranceEmpName"></input>
								</vertical>
							</columns>
							<image>350</image>
				</scrollVertical>;
		
		
		protected static var _message:UILabel;
	}
}