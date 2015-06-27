package gshah.entities
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.utils.UIDUtil;
	
	import application.managers.GshahAnimationLibrary;
	import application.managers.TimelineManager;
	
	import gshah.GshahSettings;
	import gshah.GshahUI;
	import gshah.IGshahAnimationController;
	import gshah.events.GshahAssetEvent;
	import gshah.utils.GshahAssetUtils;
	import gshah.utils.GshahUtils;
	
	[Event(name="previewChange", type="gshah.events.GshahAssetEvent")]
	[Event(name="sourceChange", type="gshah.events.GshahAssetEvent")]
	[Event(name="metadataChange", type="gshah.events.GshahAssetEvent")]
	public class GshahSource extends EventDispatcher
	{
		
		public function GshahSource(file:File,settings:GshahSettings,type:String=null)
		{
			uid=UIDUtil.createUID();
			_source=file;
			
			
			if(type==null)
			{
				if(_source!=null)
				{
					_type=GshahAssetType.getByExtention(_source.extension);	
				}
			}
			else
			{
				_type=type;	
			}
			
			if(_source!=null&&UIDUtil.isUID(_source.name.substr(0,36)))
			{
				uid=_source.name.substr(0,36);
			}
			
			if(settings!=null)
			{
				metadata=settings;
			}
		}
		
		private var _type:String=GshahAssetType.NONE;
		private var _preview:Object;
		private var _source:File;
		private var _metadata:GshahSettings;
		private var _animationId:int=-1;
		public var uid:String;
		
		public var ui:GshahUI;
		
		[Bindable]
		public function get animationId():int
		{
			return _animationId;
		}
		
		
		public function set animationId(value:int):void
		{
			_animationId = value;
			var helper:GshahUtils=new GshahUtils;
			
			var s:GshahSettings=new GshahSettings;
			
			var gc:IGshahAnimationController=GshahAnimationLibrary.instance.getAnimationById(animationId);
			s.resX=gc.contentWidth;
			s.resY=gc.contentHeight;
			s.tbr=24;
			s.totalFrames=gc.content.totalFrames;
			s.duration=gc.content.totalFrames/s.tbr;
			
			metadata=s;
			dispatchEvent(new GshahAssetEvent(GshahAssetEvent.PREVIEW_CHANGE));
		}
		
		
		
		private var _logos:Array;
		
		public function get logos():Array
		{
			return _logos;
		}
		
		public function set logos(value:Array):void
		{
			_logos = value;
			if(_logos!=null&&_bitmapLogos!=null&&logos.length!=bitmapLogos.length)
			{
				GshahAssetUtils.getAnimationLogos(this);
			}
		}
		
		public var texts:Array;
		private var _bitmapLogos:Array;
		
		public function get bitmapLogos():Array
		{
			return _bitmapLogos;
		}
		
		public function set bitmapLogos(value:Array):void
		{
			_bitmapLogos = value;
			if(_logos!=null&&_bitmapLogos!=null&&logos.length!=bitmapLogos.length)
			{
				GshahAssetUtils.getAnimationLogos(this);
			}
		}
		
		[Bindable(event="previewChange")]
		public function get preview():Object
		{
			if(_preview==null)
			{
				GshahAssetUtils.getPreview(this);
			}
			return _preview;
		}
		public function set preview(value:Object):void
		{
			if( _preview !== value)
			{
				_preview = value;
				dispatchEvent(new GshahAssetEvent(GshahAssetEvent.PREVIEW_CHANGE));
				if((_type==GshahAssetType.IMAGE||_type==GshahAssetType.TEXT))
				{
					for each (var a:GshahAsset in TimelineManager.instance.dataProvider) 
					{
						if(a.source.uid==uid)
						{
							a.timeline=null;
							GshahAssetUtils.getTimeline(a);
						}
					}
					
				}
			}
		}
		[Bindable(event="metadataChange")]
		public function get metadata():GshahSettings
		{
			return _metadata;
		}
		public function set metadata(value:GshahSettings):void
		{
			if( _metadata !== value)
			{
				var dispatchTimelineChange:Boolean=_metadata==null;
				_metadata = value;
				
				dispatchEvent(new GshahAssetEvent(GshahAssetEvent.METADATA_CHANGE));
				if(dispatchTimelineChange)
				{
					for each (var a:GshahAsset in TimelineManager.instance.dataProvider) 
					{
						if(a.source.uid==uid)
						{
							a.parts=[{s:0,e:((type==GshahAssetType.IMAGE||type==GshahAssetType.TEXT)?GshahAssetUtils.IMAGE_MINIMUM_TIME:(1000*_metadata.duration))}];
							GshahAssetUtils.getTimeline(a);
						}
					}
					withAudio=_metadata.withAudio;
				}
			}
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function compare(asset:GshahSource):Boolean
		{
			if(asset==null||asset.source==null||_source==null)
			{
				return false;
			}
			else
			{
				return asset.source.url==_source.url;
			}
		}
		[Bindable(event="sourceChange")]
		public function get source():File
		{
			return _source;
		}
		[Bindable(event="sourceChange")]
		public function get name():String
		{
			if(_source==null)
			{
				return '';
			}
			if(UIDUtil.isUID(_source.name.substr(0,36)))
			{
				return _source.name.substr(37);
			}
			return _source.name;
		}
		
		
		[Bindable]
		public var withAudio:Boolean=false;
		
		[Bindable]
		public var assetsCount:int=0;
	}
}