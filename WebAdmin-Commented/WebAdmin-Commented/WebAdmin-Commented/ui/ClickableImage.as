//receives an image and url, and when clicked, opens browser to that url

package ui {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import gs.TweenFilterLite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class ClickableImage extends Sprite {
		
		private var clickurl:String;
		
		public function ClickableImage(inImage : Bitmap, url:String) {
			super();
			
			this.buttonMode = true;
			clickurl = url;
			
			this.addChild( inImage );
			
			this.addEventListener( MouseEvent.CLICK, handleMouseAction );
			this.addEventListener( MouseEvent.MOUSE_OVER, handleMouseOver );
			this.addEventListener( MouseEvent.MOUSE_OUT, handleMouseOut );

			this.alpha = 0;
			
			TweenFilterLite.to( this, .5, { alpha : 1 } );
		}
		
		private function handleMouseAction ( e : MouseEvent ) : void
		{			
			var url:URLRequest = new URLRequest(clickurl);
			navigateToURL(url, "_blank");
		}
		
		private function handleMouseOver( e : MouseEvent ) : void
		{			
			TweenFilterLite.to( this, .5, { alpha : .6 } );
		}
		
		private function handleMouseOut ( e : MouseEvent ) : void
		{			
			TweenFilterLite.to( this, .5, { alpha : 1 } );
		}

	}
	
}
