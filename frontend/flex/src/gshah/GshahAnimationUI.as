package gshah
{
	import application.managers.GshahAnimationLibrary;
	import application.managers.TimelineManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import gshah.components.convertes.MovieClipToBitmapConverter;
	import gshah.entities.GshahAssetType;
	import gshah.entities.GshahSource;
	import gshah.events.GshahEvent;
	import gshah.intros.texts.GshahTextFont;
	import gshah.outros.logos.OutroMainLogo;
	import gshah.utils.GshahAssetUtils;
	import gshah.utils.GshahUtils;
	

	public class GshahAnimationUI extends GshahUI
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
		
		private var _animationScaleX:Number=0.5;	
		private var _animationScaleY:Number=0.5;	
		
		
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
					animationScaleX=animationScaleY=_animationScale;
				}
			}
		}
		
		[Bindable]
		public function get animationScaleX():Number
		{
			return _animationScaleX;
		}
		
		public function set animationScaleX(value:Number):void
		{
			if(!isNaN(_animationScaleX)&&_animationScaleX>0&&_animationScaleX!=value)
			{
				_animationScaleX = value;
				if(_overlay!=null&&_overlay.content!=null)
				{
					_overlay.content.scaleX=_animationScaleX;
					_overlay.content.x = -_overlay.contentPaddingLeft*_animationScaleX;
				}
			}
		}
		
		[Bindable]
		public function get animationScaleY():Number
		{
			return _animationScaleY;
		}
		
		public function set animationScaleY(value:Number):void
		{
			if(!isNaN(_animationScaleY)&&_animationScaleY>0&&_animationScaleY!=value)
			{
				_animationScaleY = value;
				if(_overlay!=null&&_overlay.content!=null)
				{
					_overlay.content.scaleY=_animationScaleY;
					_overlay.content.y = -_overlay.contentPaddingTop*_animationScaleY;
				}
			}
		}
		/**
		 * 
		 * @param overlay is an instance of any class implements <code>gshah.IGshahAnimationController</code>. <b>Required!</b> 
		 * 
		 */		
		public function GshahAnimationUI(overlay:IGshahAnimationController=null)
		{
			this.overlay=overlay;
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			startConvertIfReady();
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
			var helper:GshahUtils=new GshahUtils;
			if(logos!=null&&completedLogos!=null&&logos.length==completedLogos.length&&parent!=null)
			{
				
				_portNumber=helper.getNextPortNumber();
				connectSocket();
				var s:GshahSource=new GshahSource(null,null,GshahAssetType.ANIMATION);
				s.animationId=GshahAnimationLibrary.instance.getAnimationId(_overlay);
				s.ui=this;
				var texts:Array=[]
				for (var i:int = 0; i < _overlay.numTexts; i++) 
				{
					texts.push(_overlay.getText(i));
				}
				s.texts=texts;
				s.logos=logos;
				
				s.preview=[];
				var k:int=Math.ceil((s.metadata.duration*1000/TimelineManager.scaleAray[0])/(s.metadata.resX*GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT/s.metadata.resY));
				animationScale=GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT/_overlay.contentHeight;
				converter=new MovieClipToBitmapConverter(_overlay.content);
				converter.callBack=function(ba:ByteArray):void
				{
					
					var bd:BitmapData=new BitmapData(_overlay.contentWidth*animationScale,_overlay.contentHeight*animationScale);
					bd.setPixels(new Rectangle(0,0,bd.width,bd.height),ba);
					s.preview.push(bd);
					k--;
					if(k==0)
					{
						converter.callBack=converter_gshahCompleteHandler;
						dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,s));	
					}
				};
				converter.startConversion(new Rectangle(0,0,_overlay.contentWidth*animationScale,_overlay.contentHeight*animationScale),0,-1,_overlay.content.totalFrames/k);
				
				
				
			}
		}
		

		
		
		
		
		
		
		
		
		
		
		
		private var completedLogos:Array;
		
		/**
		 * Sets overlay's logo from path
		 */	
		private function setLogoFile(path:String, i:int):void
		{
			var imageFile:File = new File(path);
			var imageLoader:Loader = new Loader(); 
			var urlReq :URLRequest = new URLRequest(imageFile.url);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
				function(e:Event):void
				{
					var image:Bitmap = new Bitmap(e.target.content.bitmapData); 
					_overlay.setLogo(image, i);
					completedLogos.push(path);
					startConvertIfReady();
				}
			);
			imageLoader.load(urlReq);
		}
		
		public function setOverlayLogo(imageFile:File, num:int):void
		{
			var imageLoader:Loader = new Loader(); 
			var urlReq :URLRequest = new URLRequest(imageFile.url);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
				function(e:Event):void
				{
					var image:Bitmap = new Bitmap(e.target.content.bitmapData); 
					_overlay.setLogo(image, num);
				}
			);
			imageLoader.load(urlReq);
		}
		
		public function setOutroLogo(imageFile:File):void
		{
			var imageLoader:Loader = new Loader(); 
			var urlReq :URLRequest = new URLRequest(imageFile.url);
			OutroMainLogo.defaultPath=imageFile.nativePath.replace(/\\/g, File.separator);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
				function(e:Event):void
				{
					var image:Bitmap = new Bitmap(e.target.content.bitmapData); 
					OutroMainLogo.dafaultBitmap=image;
				}
			);
			imageLoader.load(urlReq);
		}
		private var logos:Array;
		
		/**
		 * Begins conversion
		 */
		public function createAsset(texts:Array, logoPathes:Array):void
		{
			
			completedLogos=[];
			var helper:GshahUtils=new GshahUtils;
			
			logos=logoPathes;
			
			animationScale=1;
			for (var i:int = 0; i < texts.length; i++) 
			{
				var t:GshahTextFont=texts[i];
				setOverlayText(t,i);
				
			}
			for (var j:int = 0; j < logos.length; j++) 
			{
				var l:String=logos[j];
				if(l!=null)
				{
					setLogoFile(l,j);
				}
				else
				{
					completedLogos.push(l);
				}
			}
			
			startConvertIfReady();
		}
		
		override protected function setSize(w:Number, h:Number):void
		{
			animationScaleX=w/_overlay.contentWidth;
			animationScaleY=h/_overlay.contentHeight;
		}
		
		
		
		
		
		/**
		 * Sets overlay's text
		 * @param text
		 * @param num
		 * 
		 */
		public function setOverlayText(text:GshahTextFont, num:int):void
		{
			_overlay.setText(text, num);
		}
	}
}