package application.managers.components
{
	[Bindable]
	public class UndoRedoManagerItem
	{
		public var type:String;
		private var undoActions:Array;
		private var redoActions:Array;

		public function UndoRedoManagerItem(_type:String,_undoActions:Array,_redoActions:Array)
		{
			type=_type;
			undoActions=_undoActions;
			redoActions=_redoActions;
		}
		
		public function undo():void
		{
			for each (var action:Function in undoActions) 
			{
				action();
			}
			
		}
		
		public function redo():void
		{
			for each (var action:Function in redoActions) 
			{
				action();
			}
			
		}
	}
}