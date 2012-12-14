/* AS3
	Copyright 2008 findsubstance;
*/
package events 
{
	
	/**
	 *	CustomEvent;
	 *
	 *	@langversion ActionScript 3.0;
	 *	@playerversion Flash 9.0;
	 *
	 *	@author shaun.tinney@findsubstance.com;
	 *	@since  02.13.2008;
	 */
	
	import flash.display.*;
	import flash.events.*;
	
	public class XMLEvent extends Event 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const ON_XML_UPLOADED : String = 'onXmlUploaded';
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function XMLEvent ( inType : String = ON_XML_UPLOADED, inParams : Object = null ) 
		{
			super( inType, true, true );
			
			m_type = inType;
			m_params = inParams;
		}
		
		//--------------------------------------
		//  CLASS VARIABLES
		//--------------------------------------

		private var m_type : String = ON_XML_UPLOADED;
		private var m_params : Object = new Object();

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get params () : Object 
		{
			return m_params;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public override function clone () : Event
		{
			return new XMLEvent( m_type, m_params );
		}

		public override function get type () : String
		{
			return m_type;
		}
	}
}