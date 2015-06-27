package application.components.timeline
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	import application.managers.TimelineManager;
	
	import gshah.GshahVideoController;
	import gshah.icons.SeekerGrayIcon;
	
	public class TimelineSeeker extends UIComponent
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
		
		private var _drag:Boolean;
		
		public function get drag():Boolean
		{
			return _drag;
		}
		
		
		
		public function set drag(value:Boolean):void
		{
			if(_drag!=value)
			{
				_drag = value;
				if(_drag)
				{
					
					removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_UP, timeline_mouseUpHandler);
					FlexGlobals.topLevelApplication.addEventListener(MouseEvent.MOUSE_MOVE, timeline_mouseMoveHandler);
				}
				else
				{
					GshahVideoController.instance.seek((super.x+timeline.horizontalScrollPosition)*TimelineManager.instance.milisecondsPerPixel/1000);
					FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_UP, timeline_mouseUpHandler);
					FlexGlobals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_MOVE, timeline_mouseMoveHandler);
					addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					
				}
				build();
			}
			
		}
		
		[Bindable]
		public var cutting:Boolean;
		
		override public function set x(value:Number):void
		{
			super.x = value;
			if(cutter!=null&&!cutting)
			{
				cutter.x=value;
			}
		}
		
		
		private var _lineWeight:int=2;
		
		public function get lineWeight():int
		{
			return _lineWeight;
		}
		
		public function set lineWeight(value:int):void
		{
			_lineWeight = value;
			build();
		}
		
		private var icon:SeekerGrayIcon;

		public function TimelineSeeker()
		{
			super();
			icon=new SeekerGrayIcon;
			icon.scaleX=icon.scaleY=1.5;
			icon.x=-icon.width/2+3;
			addChild(icon);
						
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
		}
		
		[Bindable]
		public var scrollOffset:Number=100;
		
		
		private var _currentTime:Number=0;
		
		public function resetCurrentTime():void
		{
			var __currentTime:Number=_currentTime;
			_currentTime=0;
			currentTime=__currentTime;
		}
		
		[Bindable]
		public function get currentTime():Number
		{
			return _currentTime;
		}
		
		public function set currentTime(value:Number):void
		{
			if(_currentTime != value && ! drag)
			{
				_currentTime = value;
				var _x:Number=_currentTime*1000/TimelineManager.instance.milisecondsPerPixel;
				
				var _horizontalScrollPosition:Number=0;
				if(_x+scrollOffset>timeline.width)
				{
					_horizontalScrollPosition=_x+scrollOffset-timeline.width;
				}
				
				if(_horizontalScrollPosition<0)
				{
					_horizontalScrollPosition=0;
				}
				
				if(_horizontalScrollPosition>timeline.maxHorizontalScrollPosition)
				{
					_horizontalScrollPosition=timeline.maxHorizontalScrollPosition;
				}
				if(Math.abs(timeline.horizontalScrollPosition-_horizontalScrollPosition)>100)
				{
					timeline.horizontalScrollPosition=_horizontalScrollPosition;
				}
				else
				{
					_horizontalScrollPosition=timeline.horizontalScrollPosition;

				}
				x=_x-_horizontalScrollPosition;
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
			var p:Point=icon.globalToLocal(new Point(event.stageX,event.stageY));
			if(!cutting&&event.target!=icon.arrow)
			{
				cutting=true;
			}
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

		private var _cutterFillColors:Array=[0x006800, 0x00e800, 0x007800, 0x00f000, 0x008800, 0x00ff00];
		
		public function get cutterFillColors():Array
		{
			return _cutterFillColors;
		}
		
		public function set cutterFillColors(value:Array):void
		{
			if(_cutterFillColors.length==6)
			{
				_cutterFillColors = value;
				build();
			}
			
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
		
		[Bindable]
		public var cutter:TimelineCutter;
	}
}