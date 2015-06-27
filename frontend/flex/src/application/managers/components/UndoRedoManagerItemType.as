package application.managers.components
{
	public class UndoRedoManagerItemType
	{
		public static const ADD:String='add';
		public static const REMOVE:String='remove';
		public static const LAYER:String='layer';
		public static const RESIZE:String='resize';
		public static const CUT:String='cut';
		public static const SPLIT:String='split';
		public static const TIMELINE:String='timeline';
		public static const FADE:String='fade';
		public static const GREENSCREEN:String='greenScreen';
		public static const VOLUME:String='volume';
		public static const VISIBLE:String='visible';
		public static const SADD:String='sadd';
		public static const SREMOVE:String='sremove';
		public static const TEXT:String='text';

		public function UndoRedoManagerItemType()
		{
			
		}
		
		public static function getLabel(type:String):String
		{
			switch(type)
			{
				case ADD:
				{
					return 'add item to timeline';
				}
					
				case REMOVE:
				{
					return 'remove item(s) from timeline';
				}
				case SADD:
				{
					return 'add item to library';
				}
					
				case SREMOVE:
				{
					return 'remove item from library';
				}
				case LAYER:
				{
					return 'change layers order';
				}
				case RESIZE:
				{
					return 'resize item';
				}
				case CUT:
				{
					return 'cut item';
				}	
				case SPLIT:
				{
					return 'split asset';
				}
				case TIMELINE:
				{
					return 'change timeline options';
				}
				case FADE:
				{
					return 'fade';
				}
				case GREENSCREEN:
				{
					return 'green screen effect';
				}
				case VOLUME:
				{
					return 'change sound level';
				}
				case VISIBLE:
				{
					return 'change visibility on preview';
				}
				case TEXT:
				{
					return 'text feature';
				}
			}
			return '';
		}
	}
}