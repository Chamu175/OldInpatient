package Sections.NewPatientInfo
{
	
	public class PatientInfo
	{
		
		public static const LAYOUT:XML = <scrollVertical background="#DADED4" gapV="20">	
							<label id="message0" alignH="fill"><b>Patient Information</b></label>
							<columns gapH="10" widths="30%, 30%, 10%, 30%">
								<vertical>
									<label alignH="fill" id="lastName">Last Name:</label>
									<input prompt="Last Name" alignH="fill" id="txtLastName"></input>
								</vertical>
								<vertical>
									<label alignH="fill">First Name:</label>
									<input prompt="First Name" alignH="fill" id="txtFirstName"></input>
								</vertical>
								<vertical>
									<label alignH="fill">MI:</label>
									<input prompt="MI" alignH ="fill" id="txtMI"></input>
								</vertical>
								<vertical>
									<label alignH="fill" id="ssn">Social Security Number:</label>
									<input prompt="SSN" alignH="fill" id="txtSSN"></input>							
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="60%, 20%, 10%, 10%">
								<vertical>
									<label alignH="fill">Street Address:</label>
									<input prompt="Street Address" alignH="fill" id="txtStreetAddress"></input>
								</vertical>
								<vertical>
									<label alignH="fill">City:</label>
									<input prompt="City" alignH="fill" id="txtCity"></input>
								</vertical>
								<vertical>
									<label alignH="fill">State:</label>
									<input prompt="State" alignH="fill" id="txtState"></input>
								</vertical>
								<vertical>
									<label alignH="fill">Zip:</label>
									<input prompt="Zip" alignH="fill" id="txtZip"></input>					
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="33.3%, 33.3%, 33.3%">
								<vertical>
									<touchLabel id="homePhone" alignH="fill">Home Phone:</touchLabel>
									<input prompt="Home Phone" alignH="fill" id="txtHomePh"></input>
								</vertical>
								<vertical>
									<label id="workPhone" alignH="fill">Work Phone:</label>
									<input prompt="Work Phone" alignH="fill" id="txtWorkPh"></input>
								</vertical>
								<vertical>
									<touchLabel id="cellPhone" alignH="fill">Cell Phone:</touchLabel>
									<input prompt="Cell Phone" alignH="fill" id="txtCellPh"></input>
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="33.3%, 33.3%, 33.3%">
								<vertical>
									<touchLabel id="primaryPhysician" alignH="fill">Primary/Family Physician Name:</touchLabel>
									<input prompt="Primary Physician Name" alignH="fill" id="txtFamPhysician"></input>
								</vertical>
								<vertical>
									<touchLabel id="email" alignH="fill">E-Mail Address:</touchLabel>
									<input prompt="E-mail Address" alignH="fill" id="txtEmail"></input>
								</vertical>
								<vertical>
									<touchLabel id="dob" alignH="fill">Date of Birth:</touchLabel>
									<input prompt="DOB" alignH="fill" id="txtDOB"></input>
								</vertical>
							</columns>
							<line></line>
							<columns gapH="10" widths="50%, 50%">
								<vertical>
									<touchLabel id="emergencyContact" alignH="fill">Emergency Contact/Relationship to Patient:</touchLabel>
									<input prompt="Emergency Contact/Relation" alignH="fill" id="txtEmergContactInfo"></input>
								</vertical>
								<vertical>
									<touchLabel id="emergencyContactPhone" alignH="fill">Emergency Contact Phone:</touchLabel>
									<input prompt="Emergency Contact Phone" alignH="fill" id="txtEmergContactPh"></input>
								</vertical>
							</columns>
							<line></line>
							<vertical>
								<touchLabel id="race" alignH="left">Race:</touchLabel>
								<radioButtonJT id="radWhite">White</radioButtonJT>
								<radioButtonJT id="radAsian">Asian</radioButtonJT>
								<radioButtonJT id="radBlack">Black</radioButtonJT>
								<radioButtonJT id="radDeclined">Declined</radioButtonJT>
								<radioButtonJT id="radHispanic">Hispanic</radioButtonJT>
								<radioButtonJT id="radAmerIndian">American Indian</radioButtonJT>
								<radioButtonJT id="radAlaskan">Alaskan</radioButtonJT>
								<radioButtonJT id="radOther">Other</radioButtonJT>
							</vertical>
							<image>350</image>
				</scrollVertical>;
	}
}