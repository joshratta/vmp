package gshah.events
{
	import flash.events.Event;
	
	public class GshahAssetEvent extends Event
	{
		public static const SOURCE_CHANGE:String = "sourceChange";
		public static const PREVIEW_CHANGE:String = "previewChange";
		public static const METADATA_CHANGE:String = "metadataChange";


		public function GshahAssetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new GshahAssetEvent(type, bubbles, cancelable);
		}
		
		
	}
}