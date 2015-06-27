package gshah.entities
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.utils.UIDUtil;
	
	import application.components.timeline.TimelineCollection;
	import application.events.TimelineEvent;
	import application.managers.GshahAnimationLibrary;
	import application.managers.TimelineManager;
	import application.managers.UndoRedoManager;
	import application.managers.components.UndoRedoManagerItem;
	import application.managers.components.UndoRedoManagerItemType;
	
	import gshah.GshahTextUI;
	import gshah.GshahVideoController;
	import gshah.events.GshahAssetEvent;
	import gshah.utils.GshahAssetUtils;
	
	
	[Event(name="sourceChange", type="gshah.events.GshahAssetEvent")]
	public class GshahAsset extends EventDispatcher
	{
		private var _type:String=GshahAssetType.NONE;
		private var _source:GshahSource;
		private var _timeline:TimelineCollection;
		
		
		
		public var uuid:String;
		
		
		[Bindable]
		public var layer:int=0;
		
		
		public function GshahAsset(source:GshahSource,type:String=null)
		{
			uuid=UIDUtil.createUID();
			
			_source=source;
			source.assetsCount++;
			
			if(_source!=null)
			{
				if(type==null)
				{
					_type=_source.type;	
					
				}
				else
				{
					_type=type;	
				}
				
				parts=[{s:0,e:((type==GshahAssetType.IMAGE||type==GshahAssetType.TEXT)?GshahAssetUtils.IMAGE_MINIMUM_TIME:(1000*_source.metadata.duration))}];
			}
			
			dispatchEvent(new GshahAssetEvent(GshahAssetEvent.SOURCE_CHANGE));	
			
			
		}
		
		
		[Bindable]
		public function get timelineStart():Number
		{
			return _timelineStart;
		}
		
		public function set timelineStart(value:Number):void
		{
			if(_timelineStart!=value)
			{
				if(value<0)
				{
					value=0;
				}
				if(this.type==GshahAssetType.ANIMATION&&GshahAnimationLibrary.instance.isOutro(this.source.animationId))
				{
					for each (var _a:GshahAsset in TimelineManager.instance.dataProvider.source) 
					{
						if(_a.parrentUuid==this.uuid)
						{
							_a.timelineStart+=value-timelineStart;
						}
					}
				}
				
				_timelineStart = value;
				
				TimelineManager.instance.dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_WIDTH_CHANGE));
			}
			
		}
		
		private var _parts:Array=[{s:0,e:0}];
		
		[Bindable]
		public function get parts():Array
		{
			return _parts;
		}
		
		public function set parts(value:Array):void
		{
			if(_parts!=value)
			{
				_parts = value;
				GshahAssetUtils.getTimeline(this);
			}
		}
		
		
		private var _timelineStart:Number=0;
		
		
		
		
		[Bindable]
		public function get timeline():TimelineCollection
		{
			return _timeline;
		}
		public function set timeline(value:TimelineCollection):void
		{
			if( _timeline !== value)
			{
				if(_timeline!=null)
				{
					_timeline.destroy();
					_timeline=null;
				}
				_timeline = value;
			}
		}
		[Bindable(event="sourceChange")]
		public function get source():GshahSource
		{
			return _source;
		}
		
		public var rawSourse:String;
		
		[Bindable(event="sourceChange")]
		public function get type():String
		{
			return _type;
		}
		
		
		
		[Bindable]
		public var x:Number=0;
		
		[Bindable]
		public var y:Number=0;
		
		private var _width:Number=-1;
		
		[Bindable]
		public function get width():Number
		{
			if(_width<0&&_source.metadata!=null)
			{
				return _source.metadata.resX;
			}
			return _width;
		}
		
		public function set width(value:Number):void
		{
			if(_width != value)
			{
				_width = value;
				if(_type==GshahAssetType.TEXT&&this.source!=null&&this.source.ui!=null)
				{
					(this.source.ui as GshahTextUI).setAssetSize();
				}
			}
		}
		
		
		private var _height:Number=-1;
		
		[Bindable]
		public function get height():Number
		{
			if(_height<0&&_source.metadata!=null)
			{
				return _source.metadata.resY;
			}
			return _height;
		}
		
		public function set height(value:Number):void
		{
			if(_height != value)
			{
				_height = value;
				if(_type==GshahAssetType.TEXT&&this.source!=null&&this.source.ui!=null)
				{
					(this.source.ui as GshahTextUI).setAssetSize();
				}
			}
		}
		
		private var _visibleOnPreview:Boolean=true;
		
		[Bindable]
		public function get visibleOnPreview():Boolean
		{
			return _visibleOnPreview;
		}
		
		public function set visibleOnPreview(value:Boolean):void
		{
			if(_visibleOnPreview!=value)
			{
				_visibleOnPreview = value;
			}
		}
		
		
		[Bindable]
		public var fadeIn:int=0;
		
		[Bindable]
		public var fadeOut:int=0;
		
		
		[Bindable]
		public var greenScreenColor:int=-1;
		
		[Bindable]
		public var greenScreenTola:int=-1;
		
		[Bindable]
		public var greenScreenTolb:int=-1;
		
		private var _volume:Number=100;
		
		[Bindable]
		public function get volume():Number
		{
			return _volume;
		}
		
		private var oldVolume:Number;
		
		public function set volume(value:Number):void
		{
			if(_volume!=value)
			{
				if(timer==null)
				{
					oldVolume=_volume;
					timer=new Timer(1000,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler);
				}
				_volume = value;
				if(timer.running)
				{
					timer.stop();
				}
				timer.reset();
				timer.start();
				
			}
		}
		
		protected function timer_completeHandler(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler);
			timer=null;
			GshahVideoController.instance.addAsset(this);
			UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.VOLUME,[UndoRedoManager.updateAssetVolume(this,oldVolume)],[UndoRedoManager.updateAssetVolume(this,_volume)]));		
		}		
		
		private var timer:Timer;
		
		public var parrentUuid:String;
	}
}