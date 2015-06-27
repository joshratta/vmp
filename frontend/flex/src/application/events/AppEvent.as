package application.events {
	import flash.events.Event;
	public class AppEvent extends Event {
		

		public var data:*;
		
		public static const IMPORT_MEDIA:String = "IMPORT_MEDIA";
		public static const ADD_FILE_BOX_TO_LIST:String = "ADD_FILE_BOX_TO_LIST";
		public static const REMOVE_FILE_BOX_FROM_LIST:String = "REMOVE_FILE_BOX_FROM_LIST";
		public static const FILE_BOX_START_DRAG:String = "FILE_BOX_START_DRAG";
		public static const FILE_BOX_STOP_DRAG:String = "FILE_BOX_STOP_DRAG";
		public static const ADD_ELEMENT_TO_TIMELINE:String = "ADD_ELEMENT_TO_TIMELINE";
		public static const RESIZE_PREVIEW_ELEMENT:String = "RESIZE_PREVIEW_ELEMENT";
		public static const YOU_TUBE_POPOUT:String = "YouTubePopUp";
		
		public function AppEvent (type:String, params1:Object=null, bubbles:Boolean = false, cancelable:Boolean = false) {
			// constructor code
			super(type, bubbles, cancelable);
           
            this.data = params1;

		}

	}
	
}
