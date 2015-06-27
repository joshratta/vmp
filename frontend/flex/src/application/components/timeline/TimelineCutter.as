package application.components.timeline
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	import application.managers.TimelineManager;
	
	import gshah.GshahVideoController;
	import gshah.icons.SeekerBlueIcon;
	
	public class TimelineCutter extends UIComponent
	{
		private var icon:SeekerBlueIcon;

		public function TimelineCutter()
		{
			super();
			icon=new SeekerBlueIcon;
			icon.scaleX=icon.scaleY=1.5;
			icon.x=-icon.width/2-4;
			addChild(icon);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
	
		private var _fillColors:Array=[0x054B54, 0x00BFCE, 0x054B54, 0x00CFCE, 0x054B54, 0x00DFCE];
		
		
		public function get fillColors():Array
		{
			return _fillColors;
		}
		
		public function set fillColors(value:Array):void
		{
			if(_fillColors.length==6)
			{
				_fillColors = value;
				build();
			}
			
		}
		
		public var timeline:TimelineBorderContainer;
		
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
		
	
		private var _drag:Boolean;
		
		public function get drag():Boolean
		{
			return _drag;
		}
		[Bindable]
		public var cutting:Boolean;
		
		
		
		public function set drag(value:Boolean):void
		{
			if(_drag!=value)
			{
				_drag = value;
				if(_drag)
				{
					if(!cutting)
					{
						cutting=true;
					}
					removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				
					FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_UP, timeline_mouseUpHandler);
					FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_MOVE, timeline_mouseMoveHandler);
				}
				else
				{
					FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_UP, timeline_mouseUpHandler);
					FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_MOVE, timeline_mouseMoveHandler);
					addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					if(TimelineManager.instance.cutChildX!=TimelineManager.instance.cutMainX)
					{
						GshahVideoController.instance.setHalt(TimelineManager.instance.cutChildX*TimelineManager.instance.milisecondsPerPixel/1000);

					}
					
				}
				build();
			}
			
		}
		protected function timeline_mouseUpHandler(event:MouseEvent):void
		{
			drag=false;
			
		}
		private var dragX:Number=0;
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			
			drag=true;
			dragX=timeline.mouseX+timeline.horizontalScrollPosition;
			
		}		
		
		protected function timeline_mouseMoveHandler(event:MouseEvent):void
		{
			
			var _x:Number=x+(timeline.mouseX+timeline.horizontalScrollPosition-dragX);
			if(_x<0)
			{
				_x=0;
			}
			x=_x;
			dragX=timeline.mouseX+timeline.horizontalScrollPosition;
			event.updateAfterEvent();
			
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

		private function build():void
		{
			graphics.clear();
			
			var lineWeight:Number=2;
			var matrix:Matrix = new Matrix();  
			matrix.createGradientBox(lineWeight,height,0,0,0); 
			
			graphics.beginGradientFill(GradientType.LINEAR,[fillColors[drag?4:(over?2:0)],fillColors[drag?5:(over?3:1)]],[1,1],[0,255],matrix);
			graphics.drawRect(-lineWeight/2, 0,lineWeight,height);
			graphics.endFill();
			
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
	}
}