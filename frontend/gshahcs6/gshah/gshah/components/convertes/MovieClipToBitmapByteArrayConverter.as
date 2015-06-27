package gshah.components.convertes
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * This MovieClipToBitmapByteArrayConverter helps to convert
	 * <code>flash.display.MovieClip</code> to <code>flash.display.BitmapData</code>
	 * and returns it as <code>flash.utils.ByteArray</code>
	 * 
	 */
	public class MovieClipToBitmapByteArrayConverter
	{
		private var source:MovieClip = null;
		private var _count:int = 1;
		private var _lastFramePlayed:Number = 0;
										
		private var _bitmapData:BitmapData = null;
				
		private var resultData:ByteArray;
		
		private var parent:DisplayObjectContainer;
		
		private var stage:Stage;

		private var callBack:Function;
		
		private var templateRect:Rectangle;
				
		/**
		 * Framerate for the conversion process is 100
		 */
		public static const WORK_FRAMERATE:int=100;
		
		/**
		 * 
		 * @param source is the conversion's target 
		 * 
		 */
		public function MovieClipToBitmapByteArrayConverter(source:MovieClip)
		{
			this.source = source;
			this.parent = source.parent;
		}
		
		private static var converter:MovieClipToBitmapByteArrayConverter;
		
		/**
		 * Executes the conversion of source and delivers results to callback
		 * @param source is the conversion's target 
		 * @param callBack must be <code>function(resultData:ByteArray):void</code>
		 * @param templateRect is <code>flash.geom.Rectangle</code> 
		 * that defines area of the source's farmes for the conversion
		 * 
		 */
		public static function convert(source:MovieClip, callBack:Function, templateRect:Rectangle):void
		{
			converter=new MovieClipToBitmapByteArrayConverter(source);
			converter.startConversion(callBack, templateRect);
		}
		private function showDisplayAlert():void
		{
			(new NativeAlert).alert('The source must be placed in display container!');
		}
		
		private var oldFrameRate:int;
		/**
		 * Executes the conversion of source and delivers results to callback
		 * @param callBack is <code>function(resultData:ByteArray):void</code>
		 * @param templateRect is <code>flash.geom.Rectangle</code> 
		 * that defines area of the source's farmes for the conversion
		 * 
		 */
		public function startConversion(callBack:Function, templateRect:Rectangle):void
		{
			this.callBack = callBack;
			this.templateRect = templateRect;
			resultData = new ByteArray();
			if(parent==null)
			{
				showDisplayAlert();
				return;
			}
			//var owner:DisplayObject=FlexGlobals.topLevelApplication as DisplayObject;
			
			/*if(owner==null)
			{
				showDisplayAlert();
				return;
			}*/
			
			stage=parent.stage;
			
			if(stage==null)
			{
				showDisplayAlert();
				return;
			}
						
			oldFrameRate=stage.frameRate;
			stage.frameRate=WORK_FRAMERATE;
			
			source.gotoAndStop(0);
			
			source.addEventListener(Event.ENTER_FRAME, source_enterFrameHandler);
			
			source.play();
								
		}
		
		protected function source_enterFrameHandler(event:Event):void
		{
			if (parent.numChildren > 0) 
			{
				var bitmapData:BitmapData	= new BitmapData(960,540,true,0);
				
				var matrix:Matrix	= new Matrix();
				matrix.tx	= 0;
				matrix.ty	= 0;
				
				bitmapData.draw(parent,matrix);
				
				convertBitmapToByteArray(bitmapData);
				
				if (source.currentFrame == source.totalFrames) 
				{
					source.removeEventListener(Event.ENTER_FRAME, source_enterFrameHandler);
					this.stage.frameRate=oldFrameRate;
					resultData.position = 0;

					if(callBack!=null)
					{
						callBack(resultData);
					}
				}
			}
		}
		
		protected function onMCEnterFrameHandler(event:Event):void
		{
			if (_lastFramePlayed != source.currentFrame && _count < source.totalFrames) 
			{
				_lastFramePlayed = source.currentFrame;
				_count+=1;
				
				if (source.currentFrame < source.totalFrames) 
				{
					convertMovieClipToBitmap();
				}  
				trace("counter: " + _count);
				
			} 
			else if (_lastFramePlayed == source.totalFrames) 
			{
				source.removeEventListener(Event.ENTER_FRAME, onMCEnterFrameHandler);
			}
		}
		
		public function convertMovieClipToBitmap():void
		{
			if (source!=null) {				
				var _bmpData:BitmapData = new BitmapData(source.width, source.height);
				_bmpData.draw(source);
				convertBitmapToByteArray(_bmpData);			
			}
			
		}
		
		public function convertBitmapToByteArray(inputBitmap:BitmapData):void
		{
			var rectCopy:Rectangle = new Rectangle(templateRect.x, templateRect.y, templateRect.width, templateRect.height);
			var bmptData:BitmapData = new BitmapData(rectCopy.width, rectCopy.height);
			bmptData.copyPixels(inputBitmap, rectCopy, new Point(0,0));
			
			var byteArr:ByteArray = bmptData.getPixels(bmptData.rect);
			
			var ba:ByteArray = bmptData.getPixels(new Rectangle(0,0,rectCopy.width, rectCopy.height));
			ba.position=0;

			resultData.writeBytes(ba);
			ba.position=0;
		}
		
	}
}