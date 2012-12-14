package Sections.Admin
{
	public class AdminLayout
	{
		public static const ADMIN_LAYOUT_POPUP:XML =
							<vertical background="#DADED4" gapV="20">
								<group>
									<horizontal>
										<label><b>Pin:</b></label>
										<label id="pinNumber"></label>
									</horizontal>
								</group>
								<group>
									<vertical>
										<horizontal>
											<button id="adminImageBtn">Take Picture</button>
											<label id="uploadStatus"><font size="20">Not Uploaded</font></label>
										</horizontal>
										<image id="adminImage">400,300</image>
									</vertical>
								</group>
								<button id="adminReg" alignH="fill"><font size="25">Finish Registration</font></button>
							</vertical>;
		
		public static const ADMIN_POPUP:XML = 
			<vertical background="#C0C0C0" gapV="20">
				<label alignH="centre"><font size="30">Registration Almost Complete!</font></label>
				<label alignH="fill"><font size="22">Please hand tablet back to staff and await further instructions to finish your registration.</font></label>
				<button id="adminSignIn" alignH="fill" alignV="bottom"><font size="25">Admin Sign In</font></button>
			</vertical>;
		
		public static const ADMIN_LOGIN_POPUP:XML = 
			<vertical background="#C0C0C0" gapV="20">
				<label alignH="centre"><font size="30">Admin Login</font></label>
				<input alignH="fill" prompt="Password"></input>
				<columns widths="50%,50%" alignV="bottom">
					<button id="adminClose" alignH="fill"><font size="25">Close</font></button>
					<button id="adminSignIn" alignH="fill"><font size="25">Sign In</font></button>
				</columns>
			</vertical>;
	}
}