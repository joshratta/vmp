package application.managers
{
	import flash.events.EventDispatcher;
	import flash.text.Font;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	
	import application.managers.components.UndoRedoManagerItem;
	import application.view.renderers.TimeLineAssetItemRenderer;
	
	import gshah.GshahTextUI;
	import gshah.GshahVideoController;
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahSource;
	
	[Bindable]
	public class UndoRedoManager extends EventDispatcher
	{
		public function UndoRedoManager()
		{
			super();
			dataProvider=new ArrayCollection;
		}
		
		private static var _instance:UndoRedoManager;

		public static function get instance():UndoRedoManager
		{
			if(_instance==null)
			{
				_instance=new UndoRedoManager;
			}
			return _instance;
		}

		public static function set instance(value:UndoRedoManager):void
		{
			_instance = value;
		}
		
		private var dataProvider:ArrayCollection;

		public var currentIndex:int=-1;
		
		public function undo():void
		{
			TimelineManager.instance.currentIndex=-1;

			var item:UndoRedoManagerItem=dataProvider.getItemAt(currentIndex) as UndoRedoManagerItem;
			item.undo();
			currentIndex--;
			
		}
		public function redo():void
		{
			TimelineManager.instance.currentIndex=-1;

			var item:UndoRedoManagerItem=dataProvider.getItemAt(currentIndex+1) as UndoRedoManagerItem;
			item.redo();

			currentIndex++;
			
		}
		public function addItem(item:UndoRedoManagerItem):void
		{
			while(dataProvider.length>0&&currentIndex<(dataProvider.length-1))
			{
				dataProvider.removeItemAt(dataProvider.length-1);
			}
			dataProvider.addItem(item);
			currentIndex++;
		}
		
		public function itemAt(index:int):UndoRedoManagerItem
		{
			if(dataProvider.length==0||index<0||index>=dataProvider.length)
			{
				return null;
			}
			else
			{
				return dataProvider.getItemAt(index) as UndoRedoManagerItem;
			}
		}
		
		public static function addSourceFunction(s:GshahSource,index:int):Function
		{
			return function():void
			{
				AssetSourceManager.instance.dataProvider.addItemAt(s,index);
			}
		}
		public static function removeSourceFunction(s:GshahSource):Function
		{
			return function():void
			{
				AssetSourceManager.instance.dataProvider.removeItemAt(AssetSourceManager.instance.dataProvider.getItemIndex(s));
			}
		}
		public static function addAssetFunction(a:GshahAsset,index:int):Function
		{
			return function():void
			{
				a.source.assetsCount++;
				TimelineManager.instance.dataProvider.addItemAt(a,index);
				updateAsset(a)();
			}
		}
		
		public static function removeAssetFunction(a:GshahAsset):Function
		{
			return function():void
			{
				TimelineManager.instance.removeAsset(a);
			}
		}
		
		public static function updateAssetContent(a:GshahAsset,parts:Array,fadeIn:Number=0,fadeOut:Number=0):Function
		{
			return function():void
			{
				updateAssetParts(a,parts)();
				updateAssetFade(a,fadeIn,fadeOut)();
			}
		}
		public static function updateAssetParts(a:GshahAsset,parts:Array):Function
		{
			return function():void
			{
				a.parts=parts;
			}
		}
		public static function updateAssetFade(a:GshahAsset,fadeIn:Number=0,fadeOut:Number=0):Function
		{
			return function():void
			{
				a.fadeIn=fadeIn;
				a.fadeOut=fadeOut;
				updateAsset(a)();
			}
		}
		public static function updateTextAsset(a:GshahAsset,_inputFont:Font,_fontColor:uint,_alignmentIndex:int,_text:String):Function
		{
			return function():void
			{
				GshahTextUI(a.source.ui).updateText(_inputFont,_fontColor,_alignmentIndex,_text);
				updateAsset(a)();
			}
		}
		public static function updateAssetSize(a:GshahAsset,x:Number,y:Number,w:Number,h:Number):Function
		{
			return function():void
			{
				a.width=w;
				a.height=h;
				a.x=x;
				a.y=y;
				updateAsset(a)();
			}
		}
		
		public static function updateAssetGreenScreen(a:GshahAsset,color:int,tola:int,tolb:int):Function
		{
			return function():void
			{
				a.greenScreenColor=color;
				a.greenScreenTola=tola;
				a.greenScreenTolb=tolb;

				updateAsset(a)();
			}
		}
		public static function updateAsset(a:GshahAsset):Function
		{
			return function():void
			{
				GshahVideoController.instance.addAsset(a);
			}
		}
		public static function changeLayersCount(layersCount:int):Function
		{
			return function():void
			{
				TimelineManager.instance.layersCount=layersCount;
			}
		}
		public static function updateAssetLayer(a:GshahAsset,layer:int):Function
		{
			return function():void
			{
				a.layer=layer;
			}
		}
		
		public static function updateAssetIndex(a:GshahAsset,index:int):Function
		{
			return function():void
			{
				TimelineManager.instance.dataProvider.addItemAt(TimelineManager.instance.dataProvider.removeItemAt(TimelineManager.instance.dataProvider.getItemIndex(a)),index);
			}
		}
		
		public static function updateAssetTimelineStart(a:GshahAsset,timelineStart:Number):Function
		{
			return function():void
			{
				a.timelineStart=timelineStart;
			}
		}
		
		
		public static function updateAssetVolume(a:GshahAsset,volume:Number):Function
		{
			return function():void
			{
				a.volume=volume;
				updateAsset(a)();
			}
		}
		public static function updateAssetRenderer(a:GshahAsset,mainList:List):Function
		{
			return function():void
			{
				var r:TimeLineAssetItemRenderer=mainList.dataGroup.getElementAt(TimelineManager.instance.dataProvider.getItemIndex(a)) as TimeLineAssetItemRenderer;
				if(r!=null&&r.previewGroup.dataGroup.getElementAt(0)!=null)
				{
					r.previewGroup.dataGroup.getElementAt(0).dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
				}
			}
		}
		public static function updateAssetVisible(a:GshahAsset):Function
		{
			return function():void
			{
				a.visibleOnPreview=!a.visibleOnPreview;
				if(a.visibleOnPreview)
				{
					GshahVideoController.instance.addAsset(a);
					
				}
				else
				{
					GshahVideoController.instance.removeAsset(a);
					
				}
				
				if(TimelineManager.instance.currentIndex==TimelineManager.instance.dataProvider.getItemIndex(a))
				{
					TimelineManager.instance.currentIndex=-1;
				}
			}
		}
		
		public function clear():void
		{
			dataProvider.removeAll();
			currentIndex=-1;
		}
	}
}