package application.events
{
	import flash.events.Event;
	
	public class TimelineEvent extends Event
	{
		public static const TIMELINE_WIDTH_CHANGE:String="timelineWidthChange";
		public static const RESIZE_WIDTH_CHANGE:String="resizeWidthChange";
		public static const CONTEINER_WIDTH_CHANGE:String="conteinerWidthChange";
		public static const SCROLL_POSITION_CHANGE:String="scrollPositionChange";
		public static const PLAYER_START:String="playerStart";
		public static const PLAYER_WILL_START:String="playerWillStart";
		public static const PLAYER_STOP:String="playerStop";
		public static const PLAYER_PAUSE:String="playerPause";
		public static const PLAYER_RESUME:String="playerResume";
		public static const RENDER_COMPLETE:String="renderComplete";
		public static const RESIZE_PREVIEW_CHANGE:String="resizePreviewChange";

		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}