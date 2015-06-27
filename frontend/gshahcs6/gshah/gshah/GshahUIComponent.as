package gshah
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import gshah.components.convertes.MovieClipToBitmapByteArrayConverter;
	import gshah.utils.FfmpegVideoUtils;
	import gshah.utils.NativeProcessUtils;
	
	import mx.core.ByteArrayAsset;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.LoaderInfo;
	import gshah.components.convertes.ImageToBitmapByteArrayConverter;
	
	/**
	 * The GshahUIComponent is UIComponent that helps to connect user interface
	 * with settings (an instance of <code>gshah.GshahSettings</code>) and 
	 * overlay (an instance of <code>gshah.IGshahAnimationController</code>) and shows preview of the overlay.
	 * It does allmost everything to montage your input file and overlay
	 * 
	 */
	public class GshahUIComponent extends MovieClip
	{
		
		/**
		 * @private 
		 * Storage for the overlay property
		 */
		private var _overlay:IGshahAnimationController;
		
		/**
		 * @private 
		 * Storage for the animationScale property
		 */
		private var _animationScale:Number=0.5;	
		
		/**
		 * Scale of the input overlay animation.
		 * @default 0.5
		 */
		
		/**
		 *  Native path for input overlay animation
		 */
		private var overlayPath:String=''; 
		
		public static var instanceCount:int=0;
		
		/**
		 * <b>Required!</b> An instance of any class implements <code>gshah.IGshahAnimationController</code>
		 */
		public function get overlay():IGshahAnimationController
		{
			return _overlay;
		}
		
		
		
		public function set overlay(value:IGshahAnimationController):void
		{
			if(_overlay!=value)
			{
				_overlay = value;
				putContent();
			}
			
		}
		
		[Bindable]
		public function get animationScale():Number
		{
			return _animationScale;
		}
		
		public function set animationScale(value:Number):void
		{
			if(!isNaN(_animationScale)&&_animationScale>0&&_animationScale!=value)
			{
				_animationScale = value;
				if(_overlay!=null&&_overlay.content!=null)
				{
					_overlay.content.scaleX=_overlay.content.scaleY=_animationScale;
					_overlay.content.x = -_overlay.contentPaddingLeft*_animationScale;
					_overlay.content.y = -_overlay.contentPaddingTop*_animationScale;
				}
			}
		}
		
		
		/**
		 * 
		 * @param overlay is an instance of any class implements <code>gshah.IGshahAnimationController</code>. <b>Required!</b> 
		 * 
		 */		
		public function GshahUIComponent(overlay:IGshahAnimationController=null)
		{
			this.overlay=overlay;
			
		}
		
		
		/**
		 *@private 
		 * Adds overlay's content to container and sets it's scale
		 */
		private function putContent():void
		{
			if(numChildren>0)
			{
				for (var i:int = 0; i < numChildren; i++) 
				{
					if(getChildIndex(getChildAt(i))!=-1)
					{
						removeChildAt(i);
					}
					
				}
				
			}
			if(_overlay!=null&&_overlay.content!=null)
			{
				_overlay.content.scaleX=_overlay.content.scaleY=animationScale;
				_overlay.content.x = -_overlay.contentPaddingLeft*animationScale;
				_overlay.content.y = -_overlay.contentPaddingTop*animationScale;
				addChild(_overlay.content);
				
			}
		}
		/**
		 *@private 
		 * Changes the isReady property according to the settings
		 */
		protected function startConvertIfReady():void 
		{
			for each (var l:XML in paramsXml.animation.logo) 
			{
				if(!l.hasOwnProperty('@complete'))
				{
					return;
				}
			}
			MovieClipToBitmapByteArrayConverter.convert(_overlay.content,onConversionComplete,new Rectangle(0,0,_overlay.contentWidth*animationScale,_overlay.contentHeight*animationScale));
		}
		
		/**
		 * Sets overlay's logo from path
		 */	
		private function setLogoFile(xml:XML):void
		{
			var imageFile:File = new File(xml.toString());
			var imageLoader:Loader = new Loader(); 
			var urlReq :URLRequest = new URLRequest(imageFile.url);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
				function(e:Event):void
				{
					var image:Bitmap = new Bitmap(e.target.content.bitmapData); 
					_overlay.setLogo(image, int(xml.@id.toString()));
					xml.@complete=1;
					startConvertIfReady();
				}
			);
			imageLoader.load(urlReq);
		}
		
		private var convertCallBack:Function;
		
		[Bindable]
		private var paramsXml:XML;
		
		/**
		 * Begins conversion
		 */
		public function startConvert(callBack:Function, xml:XML,previewScale:Number):void
		{
			
			convertCallBack=callBack;
			paramsXml=xml;
			if(paramsXml.hasOwnProperty('animation'))
			{
				animationScale=Math.round(paramsXml.animation.@scale*previewScale*10)/10;
				for each (var t:XML in paramsXml.animation.text) 
				{
					setOverlayText(t.toString(),int(t.@id.toString()));
				}
				for each (var l:XML in paramsXml.animation.logo) 
				{
					setLogoFile(l);
				}
				startConvertIfReady();
			}
			else
			{
				var imageFile:File = new File(paramsXml.image.toString());
				var imageLoader:Loader = new Loader(); 
				var urlReq :URLRequest = new URLRequest(imageFile.url);
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
					function(e:Event):void
					{
						var contentLoaderInfo:LoaderInfo=e.target as LoaderInfo;					
						paramsXml.@contentWidth=contentLoaderInfo.width;
						paramsXml.@contentHeight=contentLoaderInfo.height;
						
						var scale:Number=1;
						if(paramsXml.image.hasOwnProperty('@scale'))
						{
							scale=paramsXml.image.@scale;
						}
						else if(paramsXml.hasOwnProperty("@width")&&paramsXml.hasOwnProperty("@height"))
						{
							scale=Math.round(Math.min(paramsXml.@width/paramsXml.@contentWidth,paramsXml.@height/paramsXml.@contentHeight)*10)/10;
							if(paramsXml.@width/paramsXml.@contentWidth>scale)
							{
								paramsXml.@x=(-scale*paramsXml.@contentWidth+int(paramsXml.@width))/2+int(paramsXml.@x);
							}
							else if(paramsXml.@height/paramsXml.@contentHeight>scale)
							{
								paramsXml.@y=(-scale*paramsXml.@contentHeight+int(paramsXml.@height))/2+int(paramsXml.@y);
							}
						}
						
						paramsXml.image.@scale=scale;
				
						onConversionComplete(ImageToBitmapByteArrayConverter.convert(ImageToBitmapByteArrayConverter.scaleBitmapData(e.target.content.bitmapData, scale*previewScale)));
					}
				);
				imageLoader.load(urlReq);
			}
			
			
		}
		
		
		
		/**
		 * @private 
		 * Callback for the <code>gshah.components.convertes.MovieClipToBitmapByteArrayConverter</code> process
		 */
		protected function onConversionComplete(resultData:ByteArray):void
		{
			var rawFile:File = File.applicationStorageDirectory.resolvePath("ffmpegLib/snapshotOverlay"+(GshahUIComponent.instanceCount++)+".raw");
			overlayPath=rawFile.nativePath;
			var rawFileStream:FileStream = new FileStream();
			rawFileStream.addEventListener(Event.CLOSE, rawFileStreamCloseHandler);
			rawFileStream.addEventListener(IOErrorEvent.IO_ERROR,fsIOErrorHandler);
			rawFileStream.openAsync(rawFile, FileMode.WRITE);
			rawFileStream.writeBytes(resultData, 0, resultData.length);
			rawFileStream.close();
		}
		/**
		 * @private 
		 * Handler for the onConversionComplete method.
		 * Starts getting video settings from the input file
		 */
		protected function rawFileStreamCloseHandler(event:Event):void
		{
			paramsXml.source=overlayPath;
			if(paramsXml.hasOwnProperty('animation'))
			{
				convertCallBack();
			}
			else
			{
				convertCallBack(paramsXml);
			}
			
		}
		
		/**
		 * Sets overlay's text
		 * @param text
		 * @param num
		 * 
		 */
		public function setOverlayText(text:String, num:int):void
		{
			_overlay.setText(text, num);
		}
		
		private var nativeAlert:NativeAlert = new NativeAlert();
		/**
		 * @private 
		 * Event handler for any <code>flash.events.SecurityErrorEvent</code> in the class
		 */
		protected function securityErrorErrorHandler(event:SecurityErrorEvent=null):void
		{
			nativeAlert.alert("Security error! Check your files' security settings.");
		}
		/**
		 * @private 
		 * Event handler for any <code>flash.events.IOErrorEvent</code> in the class
		 */
		protected function fsIOErrorHandler(event:IOErrorEvent=null):void
		{
			nativeAlert.alert("Input/outpur error! Check your files' location and security settings.");
		}
	}
}