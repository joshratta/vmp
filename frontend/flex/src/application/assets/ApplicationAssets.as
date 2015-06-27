package application.assets
{
	import application.managers.TimelineManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import gshah.icons.Logo;
	
	import mx.core.UIComponent;
	
	public class ApplicationAssets
	{
		[Embed(source="application/assets/previews/audioDefault.png")]
		public static const PREVIEW_DEFAULT_AUDIO:Class;
		[Embed(source="application/assets/previews/videoDefault.png")]
		public static const PREVIEW_DEFAULT_VIDEO:Class;
		[Embed(source="application/assets/previews/imageDefault.png")]
		public static const PREVIEW_DEFAULT_IMAGE:Class;
		[Embed(source="application/assets/previews/loadingIcon.png")]
		public static const PREVIEW_LOADING:Class;
		[Embed(source="application/assets/logo/logoIcon30.png")]
		public static const LOGO_ICON_30:Class;
		[Embed(source="application/assets/logo/logoIcon16.png")]
		public static const LOGO_ICON_16:Class;
		[Embed(source="application/assets/logo/logoIcon128.png")]
		public static const LOGO_ICON_128:Class;
		
		private static var _dockIcon16:BitmapData;
		
		public static function get dockIcon16():BitmapData
		{
			if(_dockIcon16==null)
			{
				var bd:BitmapData=new BitmapData(16,16,true,0x00ffffff);
				bd.draw((new LOGO_ICON_16).bitmapData);
				dockIcon16=bd;
			}
			return _dockIcon16;
		}
		
		public static function set dockIcon16(value:BitmapData):void
		{
			_dockIcon16 = value;
		}
		private static var _dockIcon128:BitmapData;
		
		public static function get dockIcon128():BitmapData
		{
			if(_dockIcon128==null)
			{
				var bd:BitmapData=new BitmapData(128,128,true,0x00ffffff);
				bd.draw((new LOGO_ICON_128).bitmapData);
				dockIcon128=bd;
			}
			return _dockIcon128;
		}
		
		public static function set dockIcon128(value:BitmapData):void
		{
			_dockIcon128 = value;
		}
		
	}
}