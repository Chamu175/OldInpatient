package Sections.Popup
{
	public class PopupXML
	{
		public static const MESSAGE_POPUP:XML = 
			<vertical background="#C0C0C0" gapV="20">
				<label alignH="centre"><font size="30">Message Received From Staff</font></label>
				<vertical>
					<label alignH="fill"><font size="22">Message:</font></label>
					<label alignH="fill" id="messageReceived"><font size="22">Message</font></label>
				</vertical>
				<button id="messageClose" alignH="fill" alignV="bottom"><font size="25">Close</font></button>
			</vertical>;
		
		public static const LOGIN_CHOICE_POPUP:XML = 
			<vertical background="#C0C0C0" gapV="20">
				<label alignH="centre"><font size="30">Are you are new or existing patient?</font></label>
				<columns widths="50%,50%">
					<button id="newPatient" alignH="fill" alignV="fill"><font size="25">New Patient</font></button>
					<button id="existingPatient" alignH="fill" alignV="fill"><font size="25">Existing Patient</font></button>
				</columns>
			</vertical>;
		
		public static const SETTINGS_POPUP:XML = 
			<vertical background="#FFFFFF" gapV="20">
				<label><font size="20">Type of Help Preferred:</font></label>
				<image>20</image>
				<picker id="helpPicker" alignH="fill">
					<data>
						<Text />
						<Voice />
						<Video />
						<Avatar />
					</data>
				</picker>
				<columns widths="50%,50%" alignV="bottom">
					<button id="closeSettings" alignH="fill">Close</button>
					<button id="saveSettings" alignH="fill">Save Settings</button>
				</columns>
			</vertical>;
	}
}