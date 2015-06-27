package application.components.msl
{
	import flash.events.MouseEvent;
	
	import spark.components.List;
	
	public class MultiSelectionList extends List
	{
		public function MultiSelectionList()
		{
			super();
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void {
			event.ctrlKey = true;
			super.item_mouseDownHandler(event);
		}

	}
}