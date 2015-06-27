package gshah.events
{
	
	import flash.events.Event;
	import gshah.errors.GshahError;
	
	public class GshahErrorEvent extends Event
	{
		public static const GSHAH_ERROR:String = "gshahError";
		public var fault:GshahError;
		
		public function GshahErrorEvent(fault:GshahError, type:String=GshahErrorEvent.GSHAH_ERROR, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.fault=fault;
		}
		
		public override function clone():Event
		{
			return new GshahErrorEvent(fault, type, bubbles, cancelable);
		}
		
		
	}
}