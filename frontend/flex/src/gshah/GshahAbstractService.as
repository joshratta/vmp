package gshah
{
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	import gshah.utils.GshahUtils;

	
	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	[Event(name="gshahError", type="gshah.events.GshahErrorEvent")]
	[Event(name="gshahStart", type="gshah.events.GshahEvent")]
	[Event(name="gshahEnd", type="gshah.events.GshahEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class GshahAbstractService extends EventDispatcher
	{
		
		/**
		 * Instance of <code>gshah.GshahSettings</code> with all necessary properties about output video stream
		 */		
		[Bindable]
		public var settings:GshahSettings;
		
		protected var helper:GshahUtils;
		
		[Bindable]
		public var running:Boolean;
		
		public function GshahAbstractService()
		{
		
		}
	}
}