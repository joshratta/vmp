package application.components.timeline
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.core.UIComponent;
	
	import application.view.renderers.TimelineBitmapDataItemRenderer;
	
	public class TimelineWaveFormUI extends UIComponent
	{
		public function TimelineWaveFormUI()
		{
			super();
		}
		
		private var _volume:Number=100;
		
		public function set volume(value:Number):void
		{
			if(_volume!=value)
			{
				_volume = value;
				build();
			}
		}
		
		override public function set height(value:Number):void
		{
			if(height!=value)
			{
				super.height = value;
				build();
			}
		}
		
		override public function set width(value:Number):void
		{
			if(width!=value)
			{
				super.width = value;
				build();
			}
		}
		
		private var _data:ByteArray;
		
		public function set data(value:Object):void
		{
			if(_data!=value)
			{
				_data=value as ByteArray;
				build();
			}
		}
		
		public var o:TimelineBitmapDataItemRenderer;
		
		private function build():void
		{
			graphics.clear();

			if(_data!=null)
			{
				var w:int=_data.length/(height+1)/4;
				
				graphics.beginFill(0xffffff);
				
				_data.endian=Endian.LITTLE_ENDIAN;
				_data.position=0;
				for (var i:int = 0; i < w; i++) 
				{
					try
					{
						var h:int=_data.readInt();
					} 
					catch(error:Error) 
					{
						break
					}
					
					
					h=Math.abs(h/32768*height*_volume/100);
					graphics.drawRect(i,height-h,1,h);
					
				}
				graphics.endFill();
				
			}
			
		}
	}
}