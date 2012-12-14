package Sections.callout
{
	import avmplus.getQualifiedClassName;
	
	import com.danielfreeman.extendedMadness.UICutCopyPaste;
	import com.danielfreeman.extendedMadness.UIDropWindow;
	
	import flash.geom.Point;

	public class Callout
	{
		[Embed(source="assets/hospitalHelper.png")]
		public static const avatarImg:Class;
		
		public static const TEXT:String = "Text";
		public static const VIDEO:String = "Video";
		public static const CALLOUT_LAYOUT_AVATAR_LEFT:XML = 
			<vertical width="310" height="240" background="#666677" autoLayout="true" arrowPosition="30">
				<image id="avatarHolder">{getQualifiedClassName(avatarImg)}</image>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		public static const CALLOUT_LAYOUT_AVATAR_MIDDLE:XML = 
			<vertical width="310" height="240" background="#666677" autoLayout="true" arrowPosition="190">
				<image id="avatarHolder">{getQualifiedClassName(avatarImg)}</image>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		public static const CALLOUT_LAYOUT_VIDEO_LEFT:XML = 
			<vertical width="395" height="335" background="#666677" autoLayout="true" arrowPosition="30">
				<image id="videoHolder">390,290</image>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		
		public static const CALLOUT_LAYOUT_VIDEO_MIDDLE:XML = 
			<vertical width="395" height="335" background="#666677" autoLayout="true" arrowPosition="190">
				<image id="videoHolder">390,290</image>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		
		public static const CALLOUT_LAYOUT_TEXT_SMALL:XML = 
			<vertical width="400" height="150" background="#666677" autoLayout="true" arrowPosition="30">
				<label id="helpText" alignH="fill"><font size="20" colour="#ffffff">Loading...</font></label>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		
		public static const CALLOUT_LAYOUT_TEXT_SMALL_MIDDLE:XML = 
			<vertical width="400" height="150" background="#666677" autoLayout="true" arrowPosition="190">
				<label id="helpText" alignH="fill"><font size="20" colour="#ffffff">Loading...</font></label>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		
		public static const CALLOUT_LAYOUT_TEXT_LARGE:XML = 
			<vertical width="395" height="290" background="#666677" autoLayout="true" arrowPosition="30">
				<label id="helpText" alignH="fill"><font size="20" colour="#ffffff">Loading...</font></label>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		
		public static const CALLOUT_LAYOUT_TEXT_LARGE_MIDDLE:XML = 
			<vertical width="395" height="290" background="#666677" autoLayout="true" arrowPosition="190">
				<label id="helpText" alignH="fill"><font size="20">Loading...</font></label>
				<button colour="#669966" id="closeCallout" alignH="fill" alignV="bottom">Close</button>
			</vertical>;
		
		public static const CALLOUT_DATA:XML = 
			<data arrowPosition="-30">
				<text/>
				<voice/>
				<video/>
				<avatar/>
			</data>;
	}
}