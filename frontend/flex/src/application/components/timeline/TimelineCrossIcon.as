package application.components.timeline
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	
	public class TimelineCrossIcon extends UIComponent
	{
		
		private var _fillColors:Array=[0x686868, 0xe8e8e8, 0x787878, 0xf0f0f0, 0x888888, 0xffffff];
		
		public var timeline:TimelineBorderContainer;
		
		public function get fillColors():Array
		{
			return _fillColors;
		}
		
		private var playing:Boolean;
		
		public function set fillColors(value:Array):void
		{
			if(_fillColors.length==6)
			{
				_fillColors = value;
				build();
			}
			
		}
		
		private var _over:Boolean;
		
		private function get over():Boolean
		{
			return _over;
		}
		
		private function set over(value:Boolean):void
		{
			if(_over!=value)
			{
				_over = value;
				build();
			}
			
		}
		
		private var _click:Boolean;
		
		public function get click():Boolean
		{
			return _click;
		}
		
		public function set click(value:Boolean):void
		{
			if(_click!=value)
			{
				_click = value;
				build();
			}
			
		}
		
		
		private var _lineWeight:int=3;
		
		public function get lineWeight():int
		{
			return _lineWeight;
		}
		
		public function set lineWeight(value:int):void
		{
			_lineWeight = value;
			build();
		}
		
		
		public function TimelineCrossIcon()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			click=false;
		}		
		
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			click=true;
		}		
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			over=false;
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			over=true;
		}
		
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
		
		private function build():void
		{
			graphics.clear();
			var cathetus:Number=lineWeight/Math.SQRT2;
			var matrix:Matrix = new Matrix();  
			matrix.createGradientBox(width,height,0,0,0); 
			graphics.beginGradientFill(GradientType.LINEAR,[fillColors[click?4:(over?2:0)],fillColors[click?5:(over?3:1)]],[1,1],[0,255],matrix);

			graphics.moveTo(0,cathetus);
			graphics.lineTo(cathetus,0);
			graphics.lineTo(width/2,(height-lineWeight)/2);
			graphics.lineTo(width-cathetus,0);
			graphics.lineTo(width,cathetus);
			graphics.lineTo((width+lineWeight)/2,height/2);
			graphics.lineTo(width,height-cathetus);
			graphics.lineTo(width-cathetus,height);
			graphics.lineTo(width/2,(height+lineWeight)/2);
			graphics.lineTo(cathetus,height);
			graphics.lineTo(0,height-cathetus);
			graphics.lineTo((width-lineWeight)/2,height/2);
			graphics.lineTo(0,cathetus);
			graphics.endFill();
			
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
	}
}