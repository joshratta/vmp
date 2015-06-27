package gshah.components.convertes
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import spark.components.RichText;
	
	public class RichTextToBitmapConverter implements ISpriteToBitmapConverter
	{
		public function RichTextToBitmapConverter(richText:RichText, cb:Function=null)
		{
			_richText=richText;
			callBack=cb;
		}		
		private var _richText:RichText;
		
		private var _callBack:Function;
		public function set callBack(value:Function):void
		{
			_callBack=value;
		}
		
		public function startConversion(rect:Rectangle, start:int, end:int=-1, delta:int=1):void
		{
			
			_templateRect=rect;
			_currentFrame=start+1;
			while(_currentFrame<end+2)
			{
				_currentFrame++;

				var bmpData:BitmapData = new BitmapData(templateRect.width, templateRect.height,true,0xffffff);
				bmpData.draw(_richText);
				
				var ba:ByteArray = bmpData.getPixels(new Rectangle(0,0,templateRect.width, templateRect.height));
				ba.position=0;
				if(_callBack!=null)
				{
					_callBack(ba);
				}

			}
			
		}
		private var _templateRect:Rectangle;
		
		public function get templateRect():Rectangle
		{
			return _templateRect;
		}
		private var _currentFrame:int;
		public function get currentFrame():int
		{
			return _currentFrame;
		}
	}
}