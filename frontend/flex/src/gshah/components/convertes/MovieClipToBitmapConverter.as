package gshah.components.convertes
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import application.view.popups.GlamourAlert;
	
	/**
	 * 
	 * This MovieClipToBitmapByteArrayConverter helps to convert
	 * <code>flash.display.MovieClip</code> to <code>flash.display.BitmapData</code>
	 * and returns it as <code>flash.utils.ByteArray</code>
	 * 
	 */
	public class MovieClipToBitmapConverter implements ISpriteToBitmapConverter
	{
		private var source:MovieClip = null;
		
		private var parent:DisplayObjectContainer;
		
		private var stage:Stage;
		
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

		
		/**
		 * Framerate for the conversion process is 100
		 */
		public static const WORK_FRAMERATE:int=100;
		
		/**
		 * 
		 * @param source is the conversion's target 
		 * 
		 */
		public function MovieClipToBitmapConverter(source:MovieClip)
		{
			this.source = source;
			this.parent = source.parent;
			if(parent==null)
			{
				showDisplayAlert();
				return;
			}
			stage=parent.stage;
			
			if(stage==null)
			{
				showDisplayAlert();
				return;
			}
			
			oldFrameRate=stage.frameRate;
			stage.frameRate=WORK_FRAMERATE;
		}
		
		
		/**
		 * Executes the conversion of source and delivers results to callback
		 * @param source is the conversion's target 
		 * @param callBack must be <code>function(resultData:ByteArray):void</code>
		 * @param templateRect is <code>flash.geom.Rectangle</code> 
		 * that defines area of the source's farmes for the conversion
		 * 
		 */
		
		private var startFrame:int;
		
		private var endFrame:int;
		
		private var deltaFrame:int=1;
		
		private var paused:Boolean=false;
		
		public var frameSize:Number;
		
		private var _callBack:Function;

		public function set callBack(value:Function):void
		{
			_callBack = value;
		}

		
		private function showDisplayAlert():void
		{
			GlamourAlert.show("Input/output error! Check your files' location and security settings.");
		}
		
		public static var oldFrameRate:int=24;
		/**
		 * Executes the conversion of source and delivers results to callback
		 * @param callBack is <code>function(resultData:ByteArray):void</code>
		 * @param templateRect is <code>flash.geom.Rectangle</code> 
		 * that defines area of the source's farmes for the conversion
		 * 
		 */
		public function startConversion(templateRect:Rectangle, start:int, end:int=-1, delta:int=1):void
		{
			trace('Converting: '+templateRect.width+'x'+templateRect.height+' from '+(start+1));
			pause();
			this._templateRect = templateRect;
			this.startFrame=start+1;
			this.deltaFrame=delta;
			if(end==-1)
			{
				this.endFrame=source.totalFrames;
			}
			else
			{
				this.endFrame=Math.min(end+1,source.totalFrames);
			}
			
			isFirst=true;
			frameSize=templateRect.width*templateRect.height*4;

			_currentFrame=1;
			
			resume();
			
			source.gotoAndPlay(source.totalFrames);
			
		}
		
		private var isFirst:Boolean=true;
		
		protected function source_enterFrameHandler(event:Event):void
		{
			if (parent.numChildren > 0) 
			{
				if(currentFrame==source.currentFrame)
				{
					if(isFirst)
					{
						isFirst=false;
						_currentFrame=startFrame;
						source.gotoAndStop(currentFrame);
						return;
					}
					//trace((new Date).time+' '+currentFrame);
					
					_currentFrame+=deltaFrame;
					
					
					if (source.currentFrame == endFrame) 
					{
						if(deltaFrame>1)
						{
							convertMovieClipToBitmap();
						}
						pause();
					}
					else
					{
						source.gotoAndStop(currentFrame);
					}
					
					convertMovieClipToBitmap();
				}
			}
		}
		private function stop():void
		{
			pause();
			this.stage.frameRate=oldFrameRate;
		}
		public function convertMovieClipToBitmap():void
		{
			if (source!=null) {			
				
				var bmpData:BitmapData = new BitmapData(templateRect.width, templateRect.height,true,0xffffff);
				bmpData.draw(parent);
				
				var ba:ByteArray = bmpData.getPixels(new Rectangle(0,0,templateRect.width, templateRect.height));
				ba.position=0;
				if(_callBack!=null)
				{
					_callBack(ba);
				}
			}
			
		}
		
		
		public function pause():void
		{
			if(!paused)
			{
				paused=true;
				source.removeEventListener(Event.ENTER_FRAME, source_enterFrameHandler);
			}
			
		}
		
		public function resume():void
		{
			if(paused)
			{
				paused=false;
				source.addEventListener(Event.ENTER_FRAME, source_enterFrameHandler);
				
			}
			
		}
	}
}