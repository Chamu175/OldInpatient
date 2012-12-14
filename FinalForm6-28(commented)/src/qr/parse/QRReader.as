package qr.parse
{
	import com.google.zxing.BarcodeFormat;
	import com.google.zxing.BinaryBitmap;
	import com.google.zxing.BufferedImageLuminanceSource;
	import com.google.zxing.DecodeHintType;
	import com.google.zxing.MultiFormatReader;
	import com.google.zxing.Result;
	import com.google.zxing.client.result.ParsedResult;
	import com.google.zxing.client.result.ResultParser;
	import com.google.zxing.common.GlobalHistogramBinarizer;
	import com.google.zxing.common.flexdatatypes.HashTable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	
	public class QRReader extends Sprite
	{
		private var myReader:MultiFormatReader;
		private var fileRef:FileReference;
		
		private var _qrText:Array;
		
		public function QRReader()
		{
			super();
			myReader = new MultiFormatReader();
		}

		public function get qrText():Array
		{
			return _qrText;
		}

		private function decodeBitmapData(bmpd:BitmapData, width:int, height:int):void
		{
			// create the container to store the image data in
			var lsource:BufferedImageLuminanceSource = new BufferedImageLuminanceSource(bmpd);
			// convert it to a binary bitmap
			var bitmap:BinaryBitmap = new BinaryBitmap(new GlobalHistogramBinarizer(lsource));
			var ht:HashTable = new HashTable();
			ht.Add(DecodeHintType.POSSIBLE_FORMATS,BarcodeFormat.QR_CODE);
			ht.Add(DecodeHintType.TRY_HARDER, true); 
			// get all the hints
			var res:Result = null;
			try
			{
				// try to decode the image
				res = myReader.decode(bitmap);
			}
			catch(e:Error) 
			{
				// failed
			}
			
			// did we find something?
			if (res == null)
			{
				// no : we could not detect a valid barcode in the image
				dispatchEvent(new Event("ReadFailure", true));
			}
			else
			{
				// yes : parse the result
				var parsedResult:ParsedResult = ResultParser.parseResult(res);
				
				var _text:Object = new Object();
				_text.result = parsedResult.getDisplayResult();
				_qrText = new ParseQRResult().parse(_text);
				//trace(_qrText);
				dispatchEvent(new Event("ReadSuccess", true));
			}
		}
		
		public function decodeSnapshot(_image:Bitmap):void
		{
			var image:Bitmap = _image;
			// try to decode the current snapshpt
			var bmd:BitmapData = new BitmapData(image.width, image.height);
			bmd.draw(image);
			this.decodeBitmapData(bmd, image.width, image.height);
			
		}
	}
}