package application.managers
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import gshah.GshahSettings;
	import gshah.entities.GshahAssetType;
	import gshah.entities.GshahSource;
	
	public class AssetSourceManager extends EventDispatcher
	{
		private static var _instance:AssetSourceManager;
		[Bindable]
		public var dataProvider:ArrayCollection;
		
		public function AssetSourceManager()
		{
			dataProvider=new ArrayCollection;
		}
		
		[Bindable]
		public static function get instance():AssetSourceManager
		{
			if(_instance==null)
			{
				_instance=new AssetSourceManager;
			}
			return _instance;
		}
		
		public static function set instance(value:AssetSourceManager):void
		{
			_instance = value;
		}
		
		public function isAssetInDataProvider(asset:GshahSource):Boolean
		{
			for each (var _asset:GshahSource in dataProvider) 
			{
				if(_asset.compare(asset))
				{
					return true;
				}
			}
			return false;
			
		}
		public function addSource(assetFile:File,settings:GshahSettings):GshahSource
		{
			var asset:GshahSource=new GshahSource(assetFile as File,settings);
			if(asset.type!=GshahAssetType.NONE&&!isAssetInDataProvider(asset))
			{
				asset.metadata=settings;
				dataProvider.addItem(asset);
			}
			return asset;
		}
		
		
		
		public function clear():void
		{
			dataProvider.removeAll();
		}
		
		public function getTotalSize():Number
		{
			var total:Number=0;
			for each (var a:GshahSource in dataProvider) 
			{
				total+=a.source.size;
			}
			return total;
			
		}
	}
}