package customClasses
{
	import avmplus.getQualifiedClassName;
	
	import com.danielfreeman.madcomponents.*;
	
	import events.QRDataEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import qr.PatientQR;
	
	public class QRView extends Sprite
	{

/*		[Embed(source="assets/tester.png")]
		private static const QRPIC:Class;
		[Embed(source="assets/testerSmall.png")]
		private static const QRPIC2:Class;
		
		put in QR_VIEW
		<image id="qrBaseImage">{getQualifiedClassName(QRPIC)}</image>
		*/
		
		private var cameraBtn:UIButton;
		
		protected static const QR_VIEW:XML = 
			<vertical background="#CCCCFF,#FFFFFF" gapV="20">
				<label alignH="centre" id="qrLabel"><font size="22">Find a QR code and snap a picture.</font></label>
				<horizontal alignH="centre" gapH="20">
					<vertical>
						<label width="160"><font size="18">Tips for QR Codes:</font></label>
						<label width="160">-Make sure the QR code looks like the one on the right.</label>
						<label width="160">-Make sure the QR code takes up a good portion of the image.</label>
						<label width="160">-The image should be clear and not blurry.</label>
					</vertical>

				</horizontal>
				<button id="cameraBtn" alignH="centre" alt="true" width="200"><font size="20">Camera</font></button>
			</vertical>;
		
		public static const NAVIGATOR:XML = <navigation id="navigation" leftArrow="Back">
			{QR_VIEW}
		</navigation>;
		
		public function QRView(screen:Sprite=null)
		{
			if (screen)
				screen.addChild(this);
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//UI.create(this, NAVIGATOR);
			
			cameraBtn = UIButton(UI.findViewById("cameraBtn"));
			cameraBtn.addEventListener(UIButton.CLICKED, startCamera);
			
		}
		
		private function startCamera(event:Event):void
		{
			var qrCamera:PatientQR = new PatientQR(stage);
			//qrCamera.addEventListener("ImageLoaded", setImage);
			qrCamera.addEventListener(QRDataEvent.CUSTOM_EVENT, goToResult);
			qrCamera.addEventListener("ReadFailure", popupError);
			qrCamera.addEventListener("CaptureCanceled", hideActivity);
			UI.showActivityIndicator();
		}
		
		protected function hideActivity(event:Event):void
		{
			UI.hideActivityIndicator();
		}
		
		protected function popupError(event:Event):void
		{
			trace("error");
		}
		
		protected function goToResult(event:QRDataEvent):void
		{
			UI.hideActivityIndicator();
		}
	}
}