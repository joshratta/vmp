package application.components
{
	import flash.display.BlendMode;
	
	import mx.core.UIComponent;
	
	public class ResizeButton extends UIComponent
	{
		public function ResizeButton(empty:Boolean=false,half:Boolean=false)
		{
			super();
			super.width=super.height=10;
			this.empty=empty;
			this.half=half;

			if(!empty)
			{
				addChild(new ResizeButton(true,true));
			}
			build();
		}
		private var empty:Boolean;
		private var half:Boolean;
		override public function set height(value:Number):void
		{
			super.height = value;
			build();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			build();
		}
		
		private var _fillColor:uint=0xbebfbf;

		public function get fillColor():uint
		{
			return _fillColor;
		}

		public function set fillColor(value:uint):void
		{
			_fillColor = value;
			build();
		}
		
		
		private function build():void
		{
			var radius:Number=Math.min(width,height)/2;
			graphics.beginFill(fillColor);
			if(half)
			{
				graphics.drawCircle(radius,radius,radius/2);
			}
			else
			{
				graphics.drawCircle(radius,radius,radius);
			}
			graphics.endFill();
			if(empty)
			{
				blendMode=BlendMode.ERASE;
			}
			else
			{
				blendMode=BlendMode.LAYER;
			}
		}
	}
}