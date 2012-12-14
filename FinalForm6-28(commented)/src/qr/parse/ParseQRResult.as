package qr.parse
{
	public class ParseQRResult
	{
		private var qr:Array = new Array();
		public function ParseQRResult()
		{
		}
		public function parse(qrText:Object) :Array {
			qr = qrText.result.split(",");
			return qr;
		}
	}
}