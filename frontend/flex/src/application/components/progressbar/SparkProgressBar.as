// Not copyrighted.  Use it however you want.
package application.components.progressbar
{
	//import com.greensock.easing.Back;
	
	import application.components.progressbar.skins.ProgressBarSkin;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import spark.components.supportClasses.Range;
	
	/**
	 * A spark-based progress bar component.
	 */
	[Event(name="progressCompleted", type="flash.events.Event")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class SparkProgressBar extends Range
	{
		public function SparkProgressBar()
		{
			super();
			snapInterval = 0;
			minimum = 0;
			maximum = 100;
			this.setStyle('skinClass',application.components.progressbar.skins.ProgressBarSkin);
		}
		
		public static const EVENT_COMPLETED:String="progressCompleted";
		
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var percentLabel:String = "%";
		
		[Bindable]
		public var labelGap:Number = 3;
		
		[Bindable]
		public var displayProgress:Boolean=true;
		
		private var _eventSource:IEventDispatcher;
		
		/**
		 * An optional IEventDispatcher dispatching progress events.  The progress events will
		 * be used to update the <code>value</code> and <code>maximum</code> properties.
		 */
		[Bindable]
		public var isActive:Boolean;
		
		[Bindable]
		public function get eventSource():IEventDispatcher
		{
			return _eventSource;
		}
		
		/**
		 * @private
		 */
		public function set eventSource(value:IEventDispatcher):void
		{
			if (_eventSource != value)
			{
				removeEventSourceListeners();
				_eventSource = value;
				addEventSourceListeners();
			}
		}
		
		/**
		 * @private
		 * Removes listeners from the event source.
		 */
		protected function removeEventSourceListeners():void
		{
			if (eventSource)
			{
				eventSource.removeEventListener(ProgressEvent.PROGRESS, eventSource_progressHandler);
				isActive=false;
			}
		}
		
		/**
		 * @private
		 * Adds listeners to the event source.
		 */
		protected function addEventSourceListeners():void
		{
			if (eventSource)
			{
				eventSource.addEventListener(ProgressEvent.PROGRESS, eventSource_progressHandler);
				isActive=true;
			}
		}
		
		/**
		 * @private
		 * Updates the <code>value</code> and <code>maximum</code> properties when progress
		 * events are dispatched from the <code>eventSource</code>.
		 */
		
		protected function eventSource_progressHandler(event:ProgressEvent):void
		{
			value = event.bytesLoaded;
			maximum = event.bytesTotal;
			//trace((value/maximum*100).toFixed())
			if(value==maximum&&event.bytesLoaded==event.bytesTotal)
			{
				eventSource.addEventListener(Event.COMPLETE, eventSource_completeHandler);		
			}
			else
			{
				dispatchEvent(event);
			}
		}
		
		protected function eventSource_completeHandler(event:Event):void
		{
			removeEventListener(Event.COMPLETE, eventSource_completeHandler);
			dispatchEvent(new Event("progressCompleted"));
		}
		
		[Bindable]
		override public function get maximum():Number
		{
			return super.maximum;
		}
		override public function set maximum(value:Number):void
		{
			super.maximum = value;
		}
		
		[Bindable]
		override public function get minimum():Number
		{
			return super.minimum;
		}
		override public function set minimum(value:Number):void
		{
			super.minimum = value;
		}
		
	}
}