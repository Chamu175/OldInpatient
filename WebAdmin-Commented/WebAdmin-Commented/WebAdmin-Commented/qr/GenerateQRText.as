package  qr {
	
	public class GenerateQRText {

		public function GenerateQRText() {
		}
		//store the qrString id as the name of the file 
		public function generatePatientQRText(fileName:String, qrText:String = "", imageName:String = "", audio:Boolean = false, video:Boolean = false) :String {
			var qrString:String = new String();
			qrString += "Patient";
			qrString += "," + fileName;
			if(imageName != "") {
				qrString += "," + "image";
			}
			else {
				qrString += "," + "none";
			}
			if(qrText != "") {
				qrString += "," + "text";
			}
			else {
				qrString += "," + "none";
			}
			if(audio) {
				qrString += "," + "audio";
			}
			else {
				qrString += "," + "none";
			}
			if(video) {
				qrString += "," + "video";
			}
			else {
				qrString += "," + "none";
			}
			//Patient,qrStringName,image,text,audio,video
			trace(qrString);
			return qrString;
		}
		
		public function generateDepartmentQRText(fileName:String, departmentName:String) :String {
			var qrString:String = new String();
			qrString += "Department";
			if(departmentName != "") {
				qrString += "," + departmentName;
			}
			//Department,departmentName
			trace(qrString);
			return qrString;
		}

	}
	
}
