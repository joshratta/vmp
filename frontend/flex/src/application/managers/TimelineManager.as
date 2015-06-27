package application.managers
{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	
	import application.events.AppEvent;
	import application.events.TimelineEvent;
	import application.managers.components.UndoRedoManagerItem;
	import application.managers.components.UndoRedoManagerItemType;
	import application.view.ResizeComponent;
	
	import flashx.undo.UndoManager;
	
	import gshah.GshahGreenScreen;
	import gshah.GshahSettings;
	import gshah.GshahVideoController;
	import gshah.IGshahAnimationController;
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahAssetType;
	import gshah.entities.GshahSource;
	import gshah.icons.EyeDropperCursor;
	import gshah.utils.GshahAssetUtils;
	
	[Event(name="timelineWidthChange", type="application.events.TimelineEvent")]	
	[Event(name="conteinerWidthChange", type="application.events.TimelineEvent")]
	[Event(name="resizeWidthChange", type="application.events.TimelineEvent")]	
	[Event(name="scrollPositionChange", type="application.events.TimelineEvent")]
	[Event(name="playerStart", type="application.events.TimelineEvent")]
	[Event(name="playerStop", type="application.events.TimelineEvent")]
	[Event(name="playerPause", type="application.events.TimelineEvent")]
	[Event(name="renderComplete", type="application.events.TimelineEvent")]
	[Event(name="resizePreviewChange", type="application.events.TimelineEvent")]
	
	public class TimelineManager extends EventDispatcher
	{
		
		public static const scaleAray:Array=[25,50,100,300,600];
		
		private var _milisecondsPerPixel:int=50;
		
		[Bindable]
		public var currentItem:GshahAsset;
		
		private var _currentIndex:int=-1;
		
		private static var _instance:TimelineManager;
		[Bindable]
		public var dataProvider:ArrayCollection;
		
		
		public function TimelineManager()
		{
			dataProvider=new ArrayCollection;
			dataProvider.filterFunction=parrentUuidFilter;
			dataProvider.refresh();
		}
		
		private function parrentUuidFilter(item:Object):Boolean
		{
			var _a:GshahAsset=item as GshahAsset;
			return _a!=null&&_a.parrentUuid==null;
		}
		private var _resizeWidth:Number=0;
		
		private var _containerWidth:Number;
		
		[Bindable]
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function set currentIndex(value:int):void
		{
			if(_currentIndex!=value)
			{
				eyeDropping=false;
				if(currentItem!=null&&currentItem.type==GshahAssetType.VIDEO)
				{
					if(GshahGreenScreen.instance.previewing&&dataProvider.getItemIndex(currentItem)!=-1)
					{
						GshahVideoController.instance.addAsset(currentItem);
						GshahGreenScreen.instance.previewing=false;
					}
					GshahGreenScreen.instance.reset();
				}
				_currentIndex = value;
				if(_currentIndex>-1)
				{
					currentItem=dataProvider.getItemAt(_currentIndex) as GshahAsset;
					if(currentItem.greenScreenColor!=-1&&currentItem.type==GshahAssetType.VIDEO)
					{
						GshahGreenScreen.instance.selectedColor=currentItem.greenScreenColor;
						GshahGreenScreen.instance.tol1=currentItem.greenScreenTola;
						GshahGreenScreen.instance.selectedColor=currentItem.greenScreenTolb;
						
					}
					if(!currentItem.visibleOnPreview||currentItem.type==GshahAssetType.AUDIO||(currentItem.type==GshahAssetType.ANIMATION&&GshahAnimationLibrary.instance.isOutro(currentItem.source.animationId)))
					{
						dispatchEvent(new TimelineEvent(TimelineEvent.PLAYER_WILL_START));
					}
					else
					{
						resizeComponent(_currentIndex);
						
					}
				}
				else
				{
					currentItem=null;
					dispatchEvent(new TimelineEvent(TimelineEvent.PLAYER_WILL_START));
				}
			}
			
		}
		
		[Bindable]
		public var layersCount:int=0;
		
		[Bindable]
		public function get milisecondsPerPixel():int
		{
			return _milisecondsPerPixel;
		}
		
		public function set milisecondsPerPixel(value:int):void
		{
			if(_milisecondsPerPixel!=value)
			{
				var scale:Number=_milisecondsPerPixel/value;
				_milisecondsPerPixel = value;
				if(_scrollPosition*scale>(timelineWidth-containerWidth))
				{
					scrollPosition=timelineWidth-containerWidth;
				}
				else
				{
					scrollPosition*=scale;
				}
				dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_WIDTH_CHANGE));
				
				for each (var asset:GshahAsset in dataProvider) 
				{
					GshahAssetUtils.getTimeline(asset)
				}
				
			}
			
			
		}
		
		[Bindable(event="scrollPositionChange")]
		public function get scrollPosition():Number
		{
			return _scrollPosition;
		}
		
		public function set scrollPosition(value:Number):void
		{
			if( _scrollPosition != value)
			{
				cutMainX+=_scrollPosition-value;
				cutChildX+=_scrollPosition-value;
				_scrollPosition = value;
				dispatchEvent(new TimelineEvent(TimelineEvent.SCROLL_POSITION_CHANGE));
			}
		}
		
		[Bindable(event="resizeWidthChange")]
		public function get resizeWidth():Number
		{
			return _resizeWidth;
		}
		
		public function set resizeWidth(value:Number):void
		{
			if(_resizeWidth!=value)
			{
				_resizeWidth = value;
				dispatchEvent(new TimelineEvent(TimelineEvent.RESIZE_WIDTH_CHANGE));
				dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_WIDTH_CHANGE));
			}
			
		}
		
		[Bindable(event="conteinerWidthChange")]
		public function get containerWidth():Number
		{
			return _containerWidth;
		}
		
		public function set containerWidth(value:Number):void
		{
			if(_containerWidth!=value)
			{
				_containerWidth = value;
				dispatchEvent(new TimelineEvent(TimelineEvent.CONTEINER_WIDTH_CHANGE));
				dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_WIDTH_CHANGE));
			}
			
		}
		
		[Bindable(event="timelineWidthChange")]
		public function get timelineWidth():Number
		{
			var _timelineWidth:Number=Math.max(_containerWidth,_resizeWidth);
			for each (var asset:GshahAsset in dataProvider) 
			{
				_timelineWidth=Math.max(_timelineWidth,GshahAssetUtils.getPreviewGroupWidth(asset.parts, milisecondsPerPixel, false)+asset.timelineStart/milisecondsPerPixel/*+(asset.type==GshahAssetType.ANIMATION?(GshahAnimationLibrary.instance.isLowerThird(asset.source.animationId)?(TimelineManager.instance.lowerThirdsDelay/milisecondsPerPixel):0):0)*/);
			}
			
			return _timelineWidth;
		}
		
		
		[Bindable]
		public static function get instance():TimelineManager
		{
			if(_instance==null)
			{
				_instance=new TimelineManager;
			}
			return _instance;
		}
		
		public static function set instance(value:TimelineManager):void
		{
			_instance = value;
		}
		
		private var _scrollPosition:Number=0;
		
		
		
		private function onProgress(e:ProgressEvent):void
		{
			
		}
		private var _animationContainer:UIComponent;
		
		
		
		[Bindable]
		public function get animationContainer():UIComponent
		{
			if(_animationContainer==null)
			{
				_animationContainer=new UIComponent;
				_animationContainer.visible=false;
			}
			return _animationContainer;
		}
		
		public function set animationContainer(value:UIComponent):void
		{
			_animationContainer = value;
		}
		
		private var _eyeDropping:Boolean;
		
		public function get eyeDropping():Boolean
		{
			return _eyeDropping;
		}
		
		public function set eyeDropping(value:Boolean):void
		{
			if(_eyeDropping != value)
			{
				_eyeDropping = value;
				
				if(resizeBox!=null)
				{
					
					if(_eyeDropping)
					{
						resizeBox.addEventListener(MouseEvent.MOUSE_OVER,eyeDropper_rollHandler);
						resizeBox.addEventListener(MouseEvent.MOUSE_OUT,eyeDropper_rollHandler);
					}
					else
					{
						CursorManager.removeAllCursors();
						resizeBox.removeEventListener(MouseEvent.MOUSE_OVER,eyeDropper_rollHandler);
						resizeBox.removeEventListener(MouseEvent.MOUSE_OUT,eyeDropper_rollHandler);
						
					}
				}
			}
		}
		
		protected function eyeDropper_rollHandler(event:MouseEvent):void
		{
			if(event.type==MouseEvent.MOUSE_OVER)
			{
				CursorManager.setCursor(EyeDropperCursor)
			}
			else if(event.type==MouseEvent.MOUSE_OUT)
			{
				
				CursorManager.removeAllCursors()
			}
		}
		
		[Bindable]
		public var resizeBox:ResizeComponent;
		
		
		public function resizeComponent(timelineDPIndex:int):void{
			var a:GshahAsset= dataProvider[timelineDPIndex];
			this.dispatchEvent(new AppEvent(AppEvent.RESIZE_PREVIEW_ELEMENT, timelineDPIndex));
		}
		
		private var _cutting:Boolean;
		
		[Bindable]
		public var cutting:Boolean;
		
		private var _cutMainX:Number=0;
		
		[Bindable]
		public function get cutMainX():Number
		{
			return _cutMainX;
		}
		
		public function set cutMainX(value:Number):void
		{
			if(_cutMainX!=value)
			{
				_cutMainX = value;
			}
		}
		
		
		private var _cutChildX:Number=0;
		
		[Bindable]
		public function get cutChildX():Number
		{
			return _cutChildX;
		}
		
		public function set cutChildX(value:Number):void
		{
			if(_cutChildX!=value)
			{
				_cutChildX = value;
			}
		}
		
		
		public function cut():void
		{
			cutting=false;
			GshahVideoController.instance.setHalt(-1);
			if(currentItem!=null&&[GshahAssetType.AUDIO,GshahAssetType.VIDEO].indexOf(currentItem.type)!=-1)
			{
				var oldParts:Array=currentItem.parts;
				var cutParts:Array=oldParts;
				var oldFadeIn:Number=currentItem.fadeIn;
				var oldFadeOut:Number=currentItem.fadeOut;
				if(cutChildX!=cutMainX)
				{
					
					
					var cutStart:Number=Math.max(0,Math.min(cutChildX+scrollPosition,cutMainX+scrollPosition)*_milisecondsPerPixel-currentItem.timelineStart);
					var cutEnd:Number=Math.min(GshahAssetUtils.getAssetDuration(cutParts),Math.max(cutChildX+scrollPosition,cutMainX+scrollPosition)*_milisecondsPerPixel-currentItem.timelineStart);
					cutParts=GshahAssetUtils.sliceAssetParts(cutStart,cutEnd,cutParts);
					
				}
				if(cutParts.length==0)
				{
					UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.REMOVE,
						[UndoRedoManager.addAssetFunction(currentItem,currentIndex)],[UndoRedoManager.removeAssetFunction(currentItem)]));
					
					removeAsset(currentItem);
					currentIndex=-1;
					
				}
				else
				{
					
					var newParts:Array=cutParts;
					currentItem.fadeIn=0;
					currentItem.fadeOut=0;
					GshahVideoController.instance.addAsset(currentItem);
					
					var splitCenter:Number=(Math.min(cutMainX,cutChildX)+scrollPosition)*_milisecondsPerPixel-currentItem.timelineStart;
					if(splitCenter>0&&splitCenter<GshahAssetUtils.getAssetDuration(cutParts))
					{
						var partsRight:Array=GshahAssetUtils.sliceAssetParts(0,splitCenter,cutParts);
						currentItem.fadeIn=0;
						currentItem.fadeOut=0;
						currentItem.parts=GshahAssetUtils.sliceAssetParts(splitCenter,GshahAssetUtils.getAssetDuration(cutParts),cutParts);
						GshahVideoController.instance.addAsset(currentItem);
						newParts=currentItem.parts;
						
						var a:GshahAsset=new GshahAsset(currentItem.source,currentItem.source.type);
						a.parts=partsRight;
						a.layer=currentItem.layer;
						a.timelineStart=Math.max(cutChildX+scrollPosition,cutMainX+scrollPosition)*_milisecondsPerPixel;
						dataProvider.addItemAt(a,dataProvider.getItemIndex(currentItem)+1);
						
						GshahVideoController.instance.addAsset(a);
						UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.CUT,
							[UndoRedoManager.updateAssetContent(currentItem,oldParts,oldFadeIn,oldFadeOut),
								UndoRedoManager.removeAssetFunction(a)],
							[UndoRedoManager.updateAssetContent(currentItem,newParts),
								UndoRedoManager.addAssetFunction(a,currentIndex+1)]));
					}
					else
					{
							currentItem.parts=cutParts;
							UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.CUT,
								[UndoRedoManager.updateAssetContent(currentItem,oldParts,oldFadeIn,oldFadeOut)],
								[UndoRedoManager.updateAssetContent(currentItem,newParts)]));
							currentItem.fadeIn=0;
							currentItem.fadeOut=0;
					}
					
					cutChildX=cutMainX;
				}
				
			}
			
		}
		public function fade():void
		{
			cutting=false;
			GshahVideoController.instance.setHalt(-1);

			if(currentItem!=null)
			{
				var fadeIn:Number=Math.max(0,Math.min(cutChildX,cutMainX)+scrollPosition);
				var fadeOut:Number=Math.max(cutChildX,cutMainX)+scrollPosition;
				
				var oldFadeIn:Number=currentItem.fadeIn;
				var oldFadeOut:Number=currentItem.fadeOut;
				
				currentItem.fadeIn=Math.min(GshahAssetUtils.getAssetDuration(currentItem.parts),fadeIn*_milisecondsPerPixel-currentItem.timelineStart);
				currentItem.fadeOut=Math.max(GshahAssetUtils.getAssetDuration(currentItem.parts)-(fadeOut*_milisecondsPerPixel-currentItem.timelineStart),0);
				
				var newFadeIn:Number=currentItem.fadeIn;
				var newFadeOut:Number=currentItem.fadeOut;
				
				GshahVideoController.instance.addAsset(currentItem);
				UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.CUT,
					[UndoRedoManager.updateAssetFade(currentItem,oldFadeIn,oldFadeOut)],
					[UndoRedoManager.updateAssetFade(currentItem,newFadeIn,newFadeOut)]));
			}
			//cutChildX=cutMainX=0;
			
		}
		
		
		[Bindable]
		public var lowerThirdsDelay:Number=GshahSettings.DEFAULT_LOWER_THIRDS_DELAY;
		private var _bgColor:uint=0x000000;
		
		[Bindable]
		public function get bgColor():uint
		{
			return _bgColor;
		}
		
		public function set bgColor(value:uint):void
		{
			if(_bgColor != value)
			{
				_bgColor = value;
				GshahVideoController.instance.changeBackground(_bgColor);
			}
		}
		
		[Bindable]
		public var width:Number=DEFAULT_WIDTH;
		[Bindable]
		public var height:Number=DEFAULT_HEIGHT;
		
		public static const DEFAULT_WIDTH:Number=1280;
		public static const DEFAULT_HEIGHT:Number=720;
		
		public function getProjectXML():XML
		{
			var maxWidth:Number=0;
			var maxHeight:Number=0;
			var inputXML:XML=<xml>
				  <video>
				  </video>
				  <sources>
				  </sources>
				</xml>;
			
			for each (var source:GshahSource in AssetSourceManager.instance.dataProvider) 
			{
				inputXML.sources.appendChild(GshahAssetUtils.sourceToXML(source));
			}
			
			inputXML.video.@bgColor="#"+bgColor.toString(16);
			inputXML.video.@lowerThirdsDelay=lowerThirdsDelay.toString();
			var layer:int=dataProvider.length;
			for each (var asset:GshahAsset in dataProvider.source) 
			{
				
				maxWidth=Math.max(maxWidth,asset.width);
				maxHeight=Math.max(maxHeight,asset.height);
				inputXML.video.appendChild(GshahAssetUtils.assetToXML(asset,layer--,asset.type));
				
			}
			inputXML.video.@width=width;//maxWidth;
			inputXML.video.@height=height;//maxHeight;
			
			trace(inputXML.toString());
			return inputXML;
		}
		
		public function clear():void
		{
			UndoRedoManager.instance.clear();
			
			
			GshahVideoController.instance.stop();
			for each (var a:GshahAsset in dataProvider) 
			{
				GshahVideoController.instance.removeAsset(a);
			}
			dataProvider.removeAll();
			for (var i:int = 0; i < animationContainer.numChildren; i++) 
			{
				if(animationContainer.getChildAt(i) is IGshahAnimationController)
				{
					animationContainer.removeChildAt(i);
				}
			}
			currentIndex=-1;
			bgColor=0x000000;
			lowerThirdsDelay=GshahSettings.DEFAULT_LOWER_THIRDS_DELAY;
		}
		public function removeAsset(a:GshahAsset):void
		{
			a.source.assetsCount--;
			/*if(a.type==GshahAssetType.ANIMATION||a.type==GshahAssetType.TEXT)
			{
			a.source.ui.close();
			var j:int=animationContainer.getChildIndex(a.source.ui);
			if(j!=-1)
			{
			animationContainer.removeChildAt(j);
			}
			}*/
			var i:int=dataProvider.getItemIndex(a);
			if(i==-1)
			{
				GshahVideoController.instance.removeAsset(a);
				dataProvider.source.slice(dataProvider.source.indexOf(a),1);
				
			}
			else
			{
				if(a.type==GshahAssetType.ANIMATION&&GshahAnimationLibrary.instance.isOutro(a.source.animationId))
				{
					for each (var _a:GshahAsset in dataProvider.source) 
					{
						if(_a.parrentUuid==a.uuid)
						{
							removeAsset(_a);
						}
					}
				}
				GshahVideoController.instance.removeAsset(dataProvider.removeItemAt(i) as GshahAsset);
			}
			
			currentIndex=-1;
			
			calcLayers();
			
		}
		
		public function calcLayers():void
		{
			layersCount=0;
			for each (var _a:GshahAsset in dataProvider) 
			{
				layersCount=Math.max(layersCount,_a.layer+1);
			}
		}
		
		public function addAsset(source:GshahSource):GshahAsset
		{
			var a:GshahAsset=new GshahAsset(source,source.type);
			a.layer=layersCount;
			layersCount++;
			if(a.type==GshahAssetType.ANIMATION&&!GshahAnimationLibrary.instance.isLowerThird(a.source.animationId))
			{
				GshahAssetUtils.fullScreenAsset(a);
				GshahAssetUtils.fixAssetRatio(a);
			}
			else
			{
				GshahAssetUtils.correctAssetSize(a);
			}
			dataProvider.addItem(a);
			
			GshahVideoController.instance.addAsset(a);
			return a;
			
		}
	}
}