package application.components.timeline
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import application.events.TimelineEvent;
	import application.managers.TimelineManager;
	
	import gshah.GshahThumbnailer;
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahAssetType;
	import gshah.events.GshahEvent;
	import gshah.utils.GshahAssetUtils;
	
	public class TimelineCollection extends ArrayCollection
	{
		public static const TIMER_DELAY:Number=500;
		
		public var asset:GshahAsset;
		
		private var _index:int=0;
		
		private var startIndex:int=0;
		private var endIndex:int=0;
		
		private var processing:Boolean;
		
		
		public function TimelineCollection(asset:GshahAsset,source:Array=null)
		{
			super(source);
			this.asset=asset;
			TimelineManager.instance.addEventListener(TimelineEvent.SCROLL_POSITION_CHANGE,timeLineManager_changeHandler);
			TimelineManager.instance.addEventListener(TimelineEvent.CONTEINER_WIDTH_CHANGE,timeLineManager_changeHandler);
		}
		
		protected function timeLineManager_changeHandler(event:Event):void
		{
			var start:int=0;			
			
			while(super.getItemAt(start)!=null)
			{
				start++;
				if(start>=length-1)
				{
					TimelineManager.instance.removeEventListener(TimelineEvent.SCROLL_POSITION_CHANGE,timeLineManager_changeHandler);
					TimelineManager.instance.removeEventListener(TimelineEvent.CONTEINER_WIDTH_CHANGE,timeLineManager_changeHandler);
					return;
				}
			}
			addIndex(start);
		}
		
		private var timer:Timer;
		
		private function addIndex(index:int):void
		{
			/*			if(super.getItemAt(index)==null)
			{*/
			if(processing)
			{
				_index=Math.min(index,_index);
			}
			else 
			{
				if(timer==null)
				{
					timer=new Timer(TIMER_DELAY,1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler);
					timer.start();
				}
				else
				{
					if(timer.running)
					{
						timer.stop();
					}
					timer.reset();
					timer.start();
				}
			}
			/*}*/
		}
		private var thumbnailer:GshahThumbnailer;
		protected function timer_completeHandler(event:TimerEvent):void
		{
			if(!processing)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_completeHandler);
				timer=null;
				processing=true;
				
				if(asset.type==GshahAssetType.ANIMATION)
				{
					for (var i:int = 0; i < length; i++) 
					{
						setItemAt(asset.source.preview[Math.round(i*asset.source.preview.length/length)],i)
					}
					TimelineManager.instance.removeEventListener(TimelineEvent.SCROLL_POSITION_CHANGE,timeLineManager_changeHandler);
					TimelineManager.instance.removeEventListener(TimelineEvent.CONTEINER_WIDTH_CHANGE,timeLineManager_changeHandler);

				}
				else if(asset.type==GshahAssetType.TEXT)
				{
					setItemAt(asset.source.preview,0);
					TimelineManager.instance.removeEventListener(TimelineEvent.SCROLL_POSITION_CHANGE,timeLineManager_changeHandler);
					TimelineManager.instance.removeEventListener(TimelineEvent.CONTEINER_WIDTH_CHANGE,timeLineManager_changeHandler);
				}
				else
				{
					endIndex=length-1;
					startIndex=0;
					var previewFramesCount:int=1;
					var previewDuration:Number=GshahAssetUtils.getAssetDuration(asset.parts);
					var previeElementWidth:Number;
					var previewWidth:Number=GshahAssetUtils.getPreviewGroupWidth(asset.parts,TimelineManager.instance.milisecondsPerPixel,false);
					
					var intervalTime:int=1000;
					if(asset.type==GshahAssetType.AUDIO)
					{
						previeElementWidth=previewWidth/length;
						intervalTime=previewDuration/length;
						trace('milisecondsPerPixel='+TimelineManager.instance.milisecondsPerPixel);
					}
					else
					{
						previeElementWidth=previewWidth/length;
						//intervalTime=previewDuration/(length-1);
						intervalTime=previeElementWidth*TimelineManager.instance.milisecondsPerPixel;
						
						
					}
					while(super.getItemAt(startIndex)!=null)
					{
						startIndex++;
						if(startIndex>length-1)
						{
							TimelineManager.instance.removeEventListener(TimelineEvent.SCROLL_POSITION_CHANGE,timeLineManager_changeHandler);
							TimelineManager.instance.removeEventListener(TimelineEvent.CONTEINER_WIDTH_CHANGE,timeLineManager_changeHandler);
							return;
						}
					}
					
					while(super.getItemAt(endIndex)!=null)
					{
						endIndex--;
					}
					
					
					startIndex=Math.max(startIndex, Math.floor(((-asset.timelineStart/TimelineManager.instance.milisecondsPerPixel)+TimelineManager.instance.scrollPosition)/previeElementWidth));
					
					endIndex=Math.min(endIndex, Math.ceil(((-asset.timelineStart/TimelineManager.instance.milisecondsPerPixel)+TimelineManager.instance.containerWidth+TimelineManager.instance.scrollPosition)/previeElementWidth));			
					/*if(endIndex<length-1)
					{
					endIndex++;
					}*/
					if(intervalTime<1)
					{
						intervalTime=int.MAX_VALUE;
					}
					
					if(startIndex<=endIndex)
					{
						
						var assetParts:Array=GshahAssetUtils.cutAssetParts(intervalTime*startIndex,(endIndex<(length-1))?(previewDuration-intervalTime*(length-endIndex-1)):-1,asset.parts);
						
						if(assetParts.length>0)
						{
							trace('startIndex='+startIndex+' endIndex='+endIndex);
							var elementWidth:int;
							if(asset.type==GshahAssetType.AUDIO)
							{
								elementWidth=previeElementWidth;
							}
							else
							{
								elementWidth=asset.source.metadata.resX/asset.source.metadata.resY*GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT;
								
							}
							thumbnailer=new GshahThumbnailer();
							thumbnailer.addEventListener(GshahEvent.GSHAH_COMPLETE,thumbnailer_gshahCompleteHandler);
							var additionalPrams:String;
							
							thumbnailer.start(asset.type,asset.source.source.nativePath,assetParts,intervalTime,elementWidth,GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT, additionalPrams);				
							
							
						}
						else
						{
							processing=false;
						}
					}
					else
					{
						processing=false;
					}
				}
			}
		}
		
		protected function thumbnailer_gshahCompleteHandler(event:GshahEvent):void
		{
			if(startIndex<length)
			{
				setItemAt(event.data,startIndex)
				startIndex++;
			}
			trace('Thumbnailer ('+TimelineManager.instance.milisecondsPerPixel+'): '+startIndex);
			
			if(startIndex>endIndex||startIndex>=length)
			{
				trace('Thumbnailer ('+TimelineManager.instance.milisecondsPerPixel+'): all items setted');
				event.target.removeEventListener(GshahEvent.GSHAH_COMPLETE,thumbnailer_gshahCompleteHandler);
				event.target.close();
				thumbnailer=null;
				processing=false;
			}
			
		}		
		
		
		
		
		
		
		override public function getItemAt(index:int, prefetch:int=0):Object
		{
			var item:Object=super.getItemAt(index, prefetch);
			if(item==null)
			{
				addIndex(index);
			}
			return item;
		}
		
		public function destroy():void
		{
			TimelineManager.instance.removeEventListener(TimelineEvent.SCROLL_POSITION_CHANGE,timeLineManager_changeHandler);
			TimelineManager.instance.removeEventListener(TimelineEvent.CONTEINER_WIDTH_CHANGE,timeLineManager_changeHandler);
			processing=true;
			if(thumbnailer!=null)
			{
				thumbnailer.close();
			}
		}
	}
}