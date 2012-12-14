package Sections.Login
{
	import avmplus.getQualifiedClassName;

	public class LoginXML
	{
		[Embed(source="assets/tester.png")]
		private static const QRPIC:Class;
		
		public static const LOGIN_VIEW:XML =
			<columns widths="50%,50%" background="#DADED4" gapH="20">
				<vertical autoLayout="true">
					<label id="part1"><font size="30"><b>Part 1</b></font></label>
					<line></line>
					<vertical alignV="centre" gapV="20" autoLayout="true">
						<label alignH="fill" id="qrLabel"><font size="22">Find the QR located on your medical card and snap a picture.</font></label>
						<horizontal alignH="centre" gapH="20">
							<vertical>
								<label width="160"><font size="20">Tips for QR Codes:</font></label>
								<label width="160"><font size="18">-Make sure the QR code looks like the one on the right.</font></label>
								<label width="160"><font size="18">-Make sure the QR code takes up a good portion of the image.</font></label>
								<label width="160"><font size="18">-The image should be clear and not blurry.</font></label>
							</vertical>
							<image id="qrBaseImage">{getQualifiedClassName(QRPIC)}</image>
						</horizontal>
						<button id="cameraBtn" alignH="centre" alt="true" width="200"><font size="20">Camera</font></button>
					</vertical>
				</vertical>
				<vertical autoLayout="true">
					<label id="part2"><font size="30" color="#C0C0C0">Part 2</font></label>
					<line></line>
					<vertical alignV="centre" alignH="centre" width="300" gapV="10" autoLayout="true">
						<label alignH="centre">Enter your pin below:</label>
						<password alignH="fill" id="pinInput"></password>
						<button id="pinEnter" width="150" alignH="centre" alt="true"><font size="20">Login</font></button>
					</vertical>
				</vertical>
			</columns>
		
		public static const QR_ERROR_POPUP:XML = 
			<vertical background="#CCCCFF,#FFFFFF" gapV="15" autoLayout="true">
				<label alignH="centre"><font size="22">Error</font></label>
				<label alignH="centre" width="330" id="errorText"><font size="18">Looks like there was an error reading the QR code! Please try again.</font></label>
				<button id="closeError" alignH="centre">Close</button>
			</vertical>;
		
		public static const LOGIN_NAVIGATOR:XML = <navigation id="QRnavigation" rightButton="Restart" title="User Login" colour="#666677" background="#fffff">
			{LoginXML.LOGIN_VIEW}
		</navigation>;
	}
}