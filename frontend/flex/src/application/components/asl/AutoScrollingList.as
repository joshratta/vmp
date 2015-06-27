package application.components.asl
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.List;
	
	import flashx.textLayout.container.ScrollPolicy;
		
	
	public class AutoScrollingList extends List
	{
		
		
		private const scrollSpeed:Number = 0.5;
		// Define the variable to hold the current gradient fill colors.
		[Bindable]
		public var fillScrollerAreaColor:uint = 0x777777;
		
		private var _isHorizontal:Boolean=false; 
		[Bindable]
		public function get isHorizontalScroll():Boolean {
			
			return _isHorizontal;
		}
		public function set isHorizontalScroll(value:Boolean):void {
			if(value){
				this.setStyle('horizontalScrollPolicy', ScrollPolicy.OFF);
				if(scrollerBoundsOuter)
				{
					this.setStyle('skinClass', AutoScrollingListSkin2Horizontal);
				}
				else
				{
					this.setStyle('skinClass', AutoScrollingListSkinHorizontal);
				}
			}
			else
			{
				this.setStyle('verticalScrollPolicy', ScrollPolicy.OFF);
				if(scrollerBoundsOuter)
				{
					this.setStyle('skinClass', AutoScrollingListSkin2);
				}
				else
				{
					this.setStyle('skinClass', AutoScrollingListSkin);
				}
			}
			_isHorizontal = value;
		}
		
		private var _scrollerEnabled:Boolean = true;
		
		private var _time:Date;

		[Bindable]
		public function get time():Date
		{
			return _time;
		}

		public function set time(value:Date):void
		{
			_time = value;
			(this.dataProvider as ArrayCollection).refresh();
		}

		/**
		 * On mouse over top scroller zone height in pixels. Default 90.
		 */
		public function get scrollerEnabled():Boolean
		{
			return _scrollerEnabled;
		}
		/**
		 * @private
		 */
		[Bindable]
		public function set scrollerEnabled(value:Boolean):void
		{
			_scrollerEnabled = value;
			if(_scrollerEnabled == true)
			{
				
				if(!this.hasEventListener(MouseEvent.MOUSE_OVER))
					this.addEventListener(MouseEvent.MOUSE_OVER, scroller_mouseOver);
				if(!this.hasEventListener(MouseEvent.MOUSE_OUT))
					this.addEventListener(MouseEvent.MOUSE_OUT, scroller_mouseOut);
				
				this.setStyle('verticalScrollPolicy', ScrollPolicy.OFF);
			}
			else
			{
				if(this.hasEventListener(MouseEvent.MOUSE_OVER))
					this.removeEventListener(MouseEvent.MOUSE_OVER, scroller_mouseOver);
				if(this.hasEventListener(MouseEvent.MOUSE_OUT))
					this.removeEventListener(MouseEvent.MOUSE_OUT, scroller_mouseOut);
				
				this.setStyle('verticalScrollPolicy', ScrollPolicy.AUTO);
			}
		}
		
		/**
		 * On mouse over top scroller zone height in pixels. Default 60.
		 */
		[Bindable]
		public var scrollerTopAreaHeight:Number = 60;
		/**
		 * On mouse over bottom scroller zone height in pixels. Default 60.
		 */
		[Bindable]
		public var scrollerBottomAreaHeight:Number = 60;
		
		/**
		 * On mouse over left scroller zone height in pixels. Default 60.
		 */
		[Bindable]
		public var scrollerLeftAreaHeight:Number = 60;
		/**
		 * On mouse over right scroller zone height in pixels. Default 60.
		 */
		[Bindable]
		public var scrollerRightAreaHeight:Number = 60;
		
		
		/**
		 * Draw autoscroller area rectangles.
		 */
		[Bindable]
		public var enabledAutoScrollerBounds:Boolean = true;
		
		private var _scrollerBoundsOuter:Boolean = true;
		[Bindable]
		/**
		 * Draw autoscroller area outer of List.
		 */
		public function get scrollerBoundsOuter():Boolean
		{
			return _scrollerBoundsOuter;
		}
		
		/**
		 * @private
		 */
		public function set scrollerBoundsOuter(value:Boolean):void
		{
			_scrollerBoundsOuter = value;
			
			if(_isHorizontal){
				if(scrollerBoundsOuter)
				{
					this.setStyle('skinClass', AutoScrollingListSkin2Horizontal);
				}
				else
				{
					this.setStyle('skinClass', AutoScrollingListSkinHorizontal);
				}
			}
			else
			{
				if(scrollerBoundsOuter)
				{
					this.setStyle('skinClass', AutoScrollingListSkin2);
				}
				else
				{
					this.setStyle('skinClass', AutoScrollingListSkin);
				}
			}
		}
		
		public function AutoScrollingList()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_OVER, scroller_mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, scroller_mouseOut);
			//_isHorizontal = this.layout == HorizontalLayout;
			if(_isHorizontal){
				this.setStyle('horizontalScrollPolicy', ScrollPolicy.OFF);
				if(scrollerBoundsOuter)
				{
					this.setStyle('skinClass', AutoScrollingListSkin2Horizontal);
				}
				else
				{
					this.setStyle('skinClass', AutoScrollingListSkinHorizontal);
				}
			}
			else
			{
				this.setStyle('verticalScrollPolicy', ScrollPolicy.OFF);
				if(scrollerBoundsOuter)
				{
					this.setStyle('skinClass', AutoScrollingListSkin2);
				}
				else
				{
					this.setStyle('skinClass', AutoScrollingListSkin);
				}
			}
		}
		
		
		
		private function scroller_mouseOver(e:MouseEvent):void 
		{
			//CursorManager.removeAllCursors();                    // Remove all previous Cursors
			
			if (this.mouseY > (this.height - scrollerBottomAreaHeight)) 
			{
				//CursorManager.setCursor(downCursorSymbol);     // Down Cursor
			} 
			else if (this.mouseY < scrollerTopAreaHeight) 
			{
				//CursorManager.setCursor(upCursorSymbol);     // Up Cursor
			}
			// Scroll as its Mouse Overed
			this.addEventListener(Event.ENTER_FRAME, scrollViaY);
		}
		private function scroller_mouseOut(e:MouseEvent):void 
		{
			//CursorManager.removeAllCursors();
			this.removeEventListener(Event.ENTER_FRAME, scrollViaY);
		}
		
		private function scrollViaY(e:Event):void 
		{
			if(_isHorizontal) {
				if (this.mouseX > (this.width - scrollerRightAreaHeight)) {
					// location of mouse in the bottom (red) area // Down hover || Scroll Up
					this.layout.horizontalScrollPosition += (this.mouseX - (this.width - scrollerRightAreaHeight))*scrollSpeed;
				}
				else if (this.mouseX < scrollerLeftAreaHeight) {   // location of the mouse in the top (red) area // Up Hover || Scroll Down
					this.layout.horizontalScrollPosition += (this.mouseX - scrollerLeftAreaHeight)*scrollSpeed;
				}
			}
			else {
				if (this.mouseY > (this.height - scrollerBottomAreaHeight)) {
					// location of mouse in the bottom (red) area // Down hover || Scroll Up
					this.layout.verticalScrollPosition += (this.mouseY - (this.height - scrollerBottomAreaHeight))*scrollSpeed;
				}
				else if (this.mouseY < scrollerTopAreaHeight) {   // location of the mouse in the top (red) area // Up Hover || Scroll Down
					this.layout.verticalScrollPosition += (this.mouseY - scrollerTopAreaHeight)*scrollSpeed;
				}
			}
		}
	}
	
	
}