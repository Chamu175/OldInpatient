/* AS3
	Copyright 2008 findsubstance;
*/
package files
{
	
	/**
	 *	FileManager;
	 *
	 *	@langversion ActionScript 3.0;
	 *	@playerversion Flash 9.0;
	 *
	 *	@author shaun.tinney@findsubstance.com;
	 *	@since  02.28.2008;
	 */
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import events.*;
	import flash.utils.ByteArray;
	
	public class FileManager extends Sprite 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const ON_PROGRESS : String = 'onProgress';
		public static const ON_UPLOAD_ERROR : String = 'onUploadError';
		public static const ON_IMAGE_UPLOADED : String = 'onImageUploaded';
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function FileManager ( inUploadPHP : String, inUploadPath : String ) 
		{
			super();
			
			//the url to the php file that will be handling the actual saving of the file
			m_uploadURL = new URLRequest( inUploadPHP + '?path=' + inUploadPath );

			m_file = new FileReference();
			m_download = new FileReference();
            
			configureListeners( m_file, uploadSelectHandler );
			
			// simple listener for download complete;
			m_download.addEventListener( Event.SELECT, downloadCompleteHandler );
			
		}
		
		//--------------------------------------
		//  CLASS VARIABLES
		//--------------------------------------
		
		// display items;

		// vars;
		public var m_fileName : String;
		private var m_uploadURL : URLRequest;
		private var m_downloadURL : URLRequest;
		private var m_download : FileReference;
        private var m_file : FileReference;
		public var _loaderInfo:LoaderInfo;
		public var xmlName:String;
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public function browse () : void
		{
			//opens file browser
			m_file.browse( getImageTypes() );
		}
		
		//in original example, download is used to download image back from server.  
		//we don't use this, we keep original image on stage and use it after it is uploaded
		public function download ( inURL : String, inName : String ) : void
		{
			m_downloadURL = new URLRequest( inURL )
			m_fileName = inName;
			
			m_download.download( m_downloadURL, m_fileName );
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		*	handlers for file upload ( complete set );	
		**/
		
		private function uploadSelectHandler ( e : Event ) : void 
		{
            var file:FileReference = FileReference( e.target );
			
			m_fileName = file.name;
			file.addEventListener(Event.COMPLETE, loadCompleteHandler);
    		file.load();
        }
		
		private function loadCompleteHandler(event:Event) :void {
			dispatchEvent(new Event("FileLoading", true));
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fileDataUploaded);
			loader.loadBytes(event.target.data);
		}
		
		private function fileDataUploaded(event:Event) :void {
			_loaderInfo = (event.target as LoaderInfo);
			dispatchEvent(new Event("FileSelected", true));
		}
		
		public function uploadFile() :void {
			//file.upload(m_uploadURL);
			//file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadComplete);
		}
		
		private function uploadComplete(e:DataEvent):void {
			//trace(e.data);
		}
		
		//dispatches event that shows percent loaded
		private function progressHandler ( e : ProgressEvent ) : void 
		{
            var file : FileReference = FileReference( e.target );
			dispatchEvent( new CustomEvent( ON_PROGRESS, { percent : normalize( e.bytesLoaded / e.bytesTotal ) } ) );
        }
		
        private function uploadCompleteDataHandler ( e : DataEvent ) : void 
		{
			dispatchEvent( new CustomEvent( ON_IMAGE_UPLOADED, { fileName : m_fileName } ) );
        }
        
        private function ioErrorHandler ( e : IOErrorEvent ) : void 
		{
			dispatchError( e );
        }       

		private function securityErrorHandler ( e : SecurityErrorEvent) : void 
		{			
			dispatchError( e );
        }

		private function openHandler ( e : Event ) : void {};
		
		private function cancelHandler ( e : Event ) : void {};

        private function completeHandler ( e : Event ) : void {};

		private function httpStatusHandler ( e : HTTPStatusEvent ) : void {};
		
		/**
		*	handler for file download;
		**/
		private function downloadCompleteHandler ( e : Event ) : void
		{
			trace( 'file download complete;' );
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	
		private function dispatchError ( e : * ) : void
		{
			trace( 'ERROR: ' + e );
		}	
		
		private function configureListeners ( inDispatcher : IEventDispatcher, inSelectHandler : Function ) : void 
		{
            inDispatcher.addEventListener( Event.CANCEL, cancelHandler );
            inDispatcher.addEventListener( Event.COMPLETE, completeHandler );
            inDispatcher.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
            inDispatcher.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            inDispatcher.addEventListener( Event.OPEN, openHandler );
            inDispatcher.addEventListener( ProgressEvent.PROGRESS, progressHandler );
            inDispatcher.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
            inDispatcher.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler );
			inDispatcher.addEventListener( Event.SELECT, inSelectHandler );
        }

		//array of allowed image types (filters)
		private function getImageTypes () : Array
		{
			return new Array( new FileFilter( "Images (*.jpg, *.jpeg, *.png)", "*.jpg;*.jpeg;*.png" ) );
		}

		private function normalize ( inValue : Number ) : Number
		{
			var v : Number = inValue;
			
			if ( v > 1 ) v = 1;
			if ( v < 0 ) v = 0;
			
			v = Number( v.toFixed( 3 ) );
			
			return v;
		}
		
		public function uploadImage(imageByte:ByteArray, _state:String):void {
			var urlRequest : URLRequest = new URLRequest();
			//url of php file that will handle actual saving
			urlRequest.url = "http://wdmdsrv1.uwsp.edu/MobileUWSPApp/image.php";
			urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			
			if (_state == 'Map') {
				var postVariables:Object = {'Map':'yes'};
				urlRequest.data = UploadPostHelper.getPostData(m_fileName, imageByte, postVariables); //here is where the magic happens, filedata will be the name to retrieve the file
				urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			} else if (_state == 'QR') {
				var postVariables2:Object = {'QR':'yes'};
				urlRequest.data = UploadPostHelper.getPostData(m_fileName, imageByte, postVariables2); //here is where the magic happens, filedata will be the name to retrieve the file
				urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			}
			 
			//from here it is just a normal URLLoader
			var _pictureUploader:URLLoader = new URLLoader();
			_pictureUploader.dataFormat = URLLoaderDataFormat.BINARY;
			_pictureUploader.addEventListener( Event.COMPLETE, _onUploadComplete, false, 0, true );
			_pictureUploader.load( urlRequest );
		}
		
		//sends xml variable to image.php
		public function uploadXML (xml:ByteArray, filename:String):void {
			xmlName = filename;
			
			var urlRequest : URLRequest = new URLRequest();
			urlRequest.url = "http://wdmdsrv1.uwsp.edu/MobileUWSPApp/image.php";
			urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			
			var postVariables:Object = {'xmlfile':'yes'};
			urlRequest.data = UploadPostHelper.getPostData(filename, xml, postVariables); //here is where the magic happens, filedata will be the name to retrieve the file
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			
			var _xmlUploader:URLLoader = new URLLoader();
			_xmlUploader.dataFormat = URLLoaderDataFormat.BINARY;
			_xmlUploader.addEventListener( Event.COMPLETE, _onXMLUploaded, false, 0, true );
			_xmlUploader.load( urlRequest );
		}
		
		private function _onXMLUploaded(event:Event):void {
			dispatchEvent( new XMLEvent( XMLEvent.ON_XML_UPLOADED, { fileName : xmlName } ) );
		}
		
		private function _onUploadComplete(event:Event):void {
			dispatchEvent( new CustomEvent( CustomEvent.CUSTOM_EVENT, { fileName : m_fileName } ) );
		}
	}
}