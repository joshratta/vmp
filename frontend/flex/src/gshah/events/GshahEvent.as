package gshah.events
{
	import flash.events.Event;
	
	public class GshahEvent extends Event
	{
		public static const GSHAH_COMPLETE:String = "gshahComplete";
		public static const GSHAH_START:String = "gshahStart";
		public static const GSHAH_END:String = "gshahEnd";
		public static const GSHAH_SNAPSHOT:String = "gshahSnapshot";

		public var data:Object;
		
		public function GshahEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this.data=data;
		}
		
		public override function clone():Event
		{
			return new GshahEvent(type, data, bubbles, cancelable);
		}
		
		
	}
}