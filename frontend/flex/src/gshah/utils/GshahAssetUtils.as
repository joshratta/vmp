package gshah.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import application.assets.ApplicationAssets;
	import application.components.timeline.TimelineCollection;
	import application.events.TimelineEvent;
	import application.managers.TimelineManager;
	
	import gshah.GshahSettings;
	import gshah.GshahTextUI;
	import gshah.GshahThumbnailer;
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahAssetType;
	import gshah.entities.GshahSource;
	import gshah.events.GshahEvent;
	import gshah.intros.texts.GshahTextFont;
	
	public class GshahAssetUtils
	{
		public static const PREVIEW_DEFAULT_WIDTH:Number=146;
		public static const PREVIEW_DEFAULT_HEIGHT:Number=90;
		public static const TIMELINE_PREVIEW_DEFAULT_WIDTH:Number=80;
		public static const TIMELINE_PREVIEW_DEFAULT_HEIGHT:Number=60;
		
		public static const TIMELINE_TOOLTIP_MAX_WIDTH:Number=160;
		public static const TIMELINE_TOOLTIP_MAX_HEIGHT:Number=90;
		
		//public static const TIMELINE_SOUND_DEFAULT_PART:Number=10000;
		
		public static function getPreviewGroupWidth(parts:Array,milisecondsPerPixel:int,dispatchEvent:Boolean=true):Number
		{
			var newWidth:Number=Math.max(getAssetDuration(parts)/milisecondsPerPixel,10);
			if(dispatchEvent)
			{
				TimelineManager.instance.dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_WIDTH_CHANGE));
				
			}
			return newWidth;
		}
		
		public static function getPreview(source:GshahSource):void
		{
			if(source!=null)
			{
				
				if(source.type==GshahAssetType.AUDIO)
				{
					source.preview=ApplicationAssets.PREVIEW_DEFAULT_AUDIO;
					
				}
				else
				{
					source.preview=ApplicationAssets.PREVIEW_DEFAULT_VIDEO;
				}
				
				
				var thumbnailer:GshahThumbnailer=new GshahThumbnailer();
				
				var thumbnailer_gshahCompleteHandler:Function=function(event:GshahEvent):void
				{
					source.preview=event.data;
					thumbnailer.removeEventListener(GshahEvent.GSHAH_COMPLETE,thumbnailer_gshahCompleteHandler);
					thumbnailer.close();
					thumbnailer=null;
				}
				thumbnailer.addEventListener(GshahEvent.GSHAH_COMPLETE,thumbnailer_gshahCompleteHandler);
				if(source.type==GshahAssetType.AUDIO)
				{
					thumbnailer.start(source.type,source.source.nativePath,[{s:0, e:Math.min(10000,source.metadata.duration*1000)}],Math.min(10000,source.metadata.duration*1000),PREVIEW_DEFAULT_WIDTH,PREVIEW_DEFAULT_HEIGHT);
					
				}
				else
				{
					thumbnailer.start(source.type,source.source.nativePath,[{s:0, e:0}],1,source.metadata.resX/source.metadata.resY*PREVIEW_DEFAULT_HEIGHT,PREVIEW_DEFAULT_HEIGHT);
				}
				
				
				
				
			}
		}
		
		public static function scalePreview(source:Object):BitmapData
		{
			var sourceBitmapData:BitmapData=getBitmapData(source);
			var previewBitmapData:BitmapData=new BitmapData(PREVIEW_DEFAULT_WIDTH,PREVIEW_DEFAULT_HEIGHT,true,0xffffff);
			var matrix:Matrix = new Matrix();
			var scale:Number=Math.max(previewBitmapData.width/sourceBitmapData.width,previewBitmapData.height/sourceBitmapData.height);
			
			matrix.scale(scale, scale);
			matrix.tx = (previewBitmapData.width-sourceBitmapData.width*scale)/ 2;
			matrix.ty = (previewBitmapData.height-sourceBitmapData.height*scale)/ 2;
			
			previewBitmapData.draw(sourceBitmapData,matrix);
			return previewBitmapData;
		}
		
		
		public static function getAssetDuration(parts:Array):Number
		{
			var d:Number=0;
			for each (var p:Object in parts) 
			{
				d+=p.e-p.s;
			}
			return d;
		}
		public static function cutAssetParts(start:Number,end:Number,parts:Array):Array
		{
			var cutParts:Array=[];
			var d:Number=0;
			var pd:Number=0;
			for each (var p:Object in parts) 
			{
				d+=p.e-p.s;
				if(d>start)
				{
					if(start<pd)
					{
						var s:Number=p.s+start;
					}
					else
					{
						s=p.s;
					}
					if(end==-1||end>d)
					{
						cutParts.push({s:s, e:p.e});
					}
					else
					{
						cutParts.push({s:s, e:(p.s+end-pd)});
						break;
					}
					
				}
				pd=d;
				
			}
			return cutParts;
		}
		
		public static function sliceAssetParts(start:Number,end:Number,parts:Array):Array
		{
			var cutParts:Array=[];
			var d:Number=0;
			var pd:Number=0;
			for each (var p:Object in parts) 
			{
				d+=p.e-p.s;
				if(pd>=end||d<=start)
				{
					cutParts.push({s:p.s, e:p.e});
				}
				else
				{
					if(start>pd&&start<d)
					{
						cutParts.push({s:p.s, e:p.s+start-pd})
					}
					
					if(end>pd&&end<d)
					{
						cutParts.push({s:p.s+end-pd, e:p.e})
					}
				}
				
				pd=d;
			}
			return cutParts;
		}
		
		public static function getAssetFilterString(parts:Array,type:String='v'):String
		{
			var j:int=1;
			var f:String='';
			for each (var p:Object in parts) 
			{
				f+=("[0:"+type+"]"+(type=='v'?'':'a')+"trim=start="+(p.s/1000)+":end="+(p.e/1000)+","+(type=='v'?'':'a')+"setpts=PTS-STARTPTS[p"+((parts.length==1)?'out':(j++))+"]");
				if(j==2&&parts.length>1)
				{
					f+=';';
				}
				if(j>2)
				{
					f+=";[p"+(j-2)+"][p"+(j-1)+"]concat"+(type=='v'?'':'=v=0:a=1')+"[p"+((parts.indexOf(p)==(parts.length-1))?'out':(j++))+"]"+((parts.indexOf(p)==(parts.length-1))?'':';');
				}
			}
			return f;
		}
		public static function getTimeline(asset:GshahAsset):void
		{
			if(asset!=null)
			{
				if(asset.type==GshahAssetType.IMAGE||asset.type==GshahAssetType.TEXT)
				{
					if(asset.timeline==null)
					{
						asset.timeline=new TimelineCollection(asset,new Array(1));
					}
					return;
				}
				var previewFramesCount:int=1;
				var previewDuration:Number=getAssetDuration(asset.parts);
				var previewWidth:Number=previewDuration/TimelineManager.instance.milisecondsPerPixel;
				asset.timeline=new TimelineCollection(asset,[null]);
				if(asset.source.metadata!=null)
				{	
					if(asset.type==GshahAssetType.AUDIO)
					{
						
						previewFramesCount=Math.ceil(previewDuration/PREVIEW_DEFAULT_WIDTH/TimelineManager.instance.milisecondsPerPixel);
						
						
					}
					else
					{
						previewFramesCount=Math.ceil(previewWidth/(asset.source.metadata.resX*TIMELINE_PREVIEW_DEFAULT_HEIGHT/asset.source.metadata.resY));
					}
					if(previewFramesCount<1)
					{
						previewFramesCount=1;
					}
				}
				switch(asset.type)
				{
					case GshahAssetType.AUDIO:
					{
						asset.timeline=new TimelineCollection(asset,new Array(previewFramesCount));
						break;
					}
					case GshahAssetType.IMAGE:
					{
						break;
					}
					case GshahAssetType.VIDEO:
					case GshahAssetType.ANIMATION:
					{						
						asset.timeline=new TimelineCollection(asset,new Array(previewFramesCount));
						break;
					}
				}
				
				
			}
		}
		
		public static function getAnimationLogos(asset:GshahSource):void
		{
			var bitmapLogos:Array=[];
			for (var j:int = 0; j < asset.logos.length; j++) 
			{
				bitmapLogos.push(null);
			}
			asset.bitmapLogos=bitmapLogos;
			for (var num:int = 0; num < asset.logos.length; num++) 
			{
				var p:String=asset.logos[num];
				if(p!=null)
				{
					var imageLoader:Loader = new Loader(); 
					var urlReq :URLRequest = new URLRequest(new File(p).url);
					imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
						function(e:Event):void
						{
							var n:int=-1;
							for each (var _p:String in asset.logos) 
							{
								n++;
								if(new File(p).url==e.target.url)
								{
									break;	
								}
							}
							
							asset.bitmapLogos[n]=new Bitmap(e.target.content.bitmapData);
							for (var i:int = 0; i < asset.bitmapLogos.length; i++) 
							{
								if(asset.bitmapLogos[i]==null&&asset.logos[i]!=null)
								{
									return;
								}
							}
							
						}
					);
					imageLoader.load(urlReq);
				}
				
			}
			for (var i:int = 0; i < asset.bitmapLogos.length; i++) 
			{
				if(asset.bitmapLogos[i]==null&&asset.logos[i]!=null)
				{
					return;
				}
			}
		}
		
		private static function getBitmapData(source:Object):BitmapData
		{
			if(source is BitmapData)
			{
				return source as BitmapData;
			}
			else if(source is Class)
			{
				return Bitmap(new source).bitmapData;
			}
			return null
		}
		
		private static var _defaultLoadingLabel:TextField;
		
		private static var defaultLoadingPreview:Object={};
		
		public static function get defaultLoadingLabel():TextField
		{
			if(_defaultLoadingLabel==null)
			{
				_defaultLoadingLabel=new TextField;
				_defaultLoadingLabel.text='LOADING';
				
				var labelFormat:TextFormat=new TextFormat;
				labelFormat.color=0xffffff;
				labelFormat.bold=true;
				
				_defaultLoadingLabel.setTextFormat(labelFormat);
			}
			return _defaultLoadingLabel;
		}
		
		public static function getLoadingPreview(width:Number):BitmapData
		{
			if(!defaultLoadingPreview.hasOwnProperty(width.toString()))
			{
				var loadingBitmapData:BitmapData=new BitmapData(width,TIMELINE_PREVIEW_DEFAULT_HEIGHT,true,0xffffff);
				
				loadingBitmapData.draw(defaultLoadingLabel,
					new Matrix(1,0,0,1,
						(loadingBitmapData.width-defaultLoadingLabel.textWidth)/2,
						(loadingBitmapData.height-defaultLoadingLabel.textHeight)/2));
				defaultLoadingPreview[width.toString()]=loadingBitmapData;
				
			}
			
			return defaultLoadingPreview[width.toString()];
		}
		
		
		private static function scaleBitmapData(sourceBitmapData:BitmapData,scale:Number):BitmapData
		{
			var previewBitmapData:BitmapData=new BitmapData(sourceBitmapData.width*scale,sourceBitmapData.height*scale,true,0xffffff);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			previewBitmapData.draw(sourceBitmapData,matrix);
			return previewBitmapData;
		}
		public static function scalePreviewToTimeline(source:Object):BitmapData
		{
			var sourceBitmapData:BitmapData=getBitmapData(source);
			
			if(	sourceBitmapData!=null)
			{
				return scaleBitmapData(sourceBitmapData,TIMELINE_PREVIEW_DEFAULT_HEIGHT/sourceBitmapData.height);
			}
			else
			{
				return null;
			}
		}
		public static function scalePreviewToTimelineTooltip(source:Object):BitmapData
		{
			var sourceBitmapData:BitmapData=getBitmapData(source);
			
			if(	sourceBitmapData!=null)
			{
				return scaleBitmapData(sourceBitmapData,Math.min(TIMELINE_TOOLTIP_MAX_WIDTH/sourceBitmapData.width,TIMELINE_TOOLTIP_MAX_HEIGHT/sourceBitmapData.height,1));
			}
			else
			{
				return null;
			}
		}
		
		
		public static function xmlToMetada(source:XML):GshahSettings
		{
			var metadata:GshahSettings=new GshahSettings;
			metadata.withAudio=source.@withAudio;
			metadata.resX=source.@resX;
			metadata.resY=source.@resY;
			metadata.tbr=source.@tbr;
			metadata.totalFrames=source.@totalFrames;
			metadata.duration=source.@duration;
			metadata.bgColor=source.@bgColor;
			return metadata;
			
		}
		public static const IMAGE_MINIMUM_TIME:Number=1000;
		public static function sourceToXML(s:GshahSource):XML
		{
			var source:XML=<source/>;
			source.@uid=s.uid;
			source.@withAudio=s.metadata.withAudio;
			source.@resX=s.metadata.resX;
			source.@resY=s.metadata.resY;
			source.@tbr=s.metadata.tbr;
			source.@duration=s.metadata.duration;
			source.@totalFrames=s.metadata.totalFrames;
			source.@bgColor=s.metadata.bgColor;
			if(s.source!=null)
			{
				source.@path=s.source.nativePath;
			}
			return source;
			
		}
		public static function assetToXML(asset:GshahAsset,layer:int,type:String):XML
		{
			var track:XML;
			var helper:GshahUtils=new GshahUtils;
			switch(type)
			{
				case GshahAssetType.IMAGE:
				{
					track=<track/>;
					track.image=asset.source.name;
					track.@layer=layer;
					track.@x=asset.x;
					track.@y=asset.y;
					track.@width=asset.width;
					track.@height=asset.height;
					track.cue.startpos.@time=asset.timelineStart;
					track.cue.endpos.@time=asset.timelineStart+Math.max(asset.parts[0].e,IMAGE_MINIMUM_TIME);
					track.@fadein=asset.fadeIn;
					track.@fadeout=asset.fadeOut;
					break;
				}
				case GshahAssetType.TEXT:
				{
					track=<track/>;
					track.@text=GshahTextUI(asset.source.ui).text;
					track.@layer=-layer-1;
					track.@x=asset.x;
					track.@y=asset.y;
					track.@width=asset.width;
					track.@height=asset.height;
					track.cue.startpos.@time=asset.timelineStart;
					track.cue.endpos.@time=asset.timelineStart+Math.max(asset.parts[0].e,IMAGE_MINIMUM_TIME);
					track.@fontColor=GshahTextUI(asset.source.ui).fontColor;
					track.@alignmentIndex=GshahTextUI(asset.source.ui).alignmentIndex;
					track.@fontName=GshahTextUI(asset.source.ui).inputFont.fontName;
					track.@fontStyle=GshahTextUI(asset.source.ui).inputFont.fontStyle;
					break;
				}
				case GshahAssetType.ANIMATION:
				{
					track=<track/>;
					track.animation.@id=asset.source.animationId;
					for (var i:int = 0; i < asset.source.texts.length; i++) 
					{
						var textXml:XML=new XML('<text>'+GshahTextFont(asset.source.texts[i]).text+'</text>');
						textXml.@id=i;
						textXml.@fontColor=GshahTextFont(asset.source.texts[i]).fontColor;
						textXml.@fontName=GshahTextFont(asset.source.texts[i]).fontName;
						textXml.@fontSize=GshahTextFont(asset.source.texts[i]).fontSize;
						
						track.animation.appendChild(textXml);
					}
					for (i = 0; i < asset.source.logos.length; i++) 
					{
						if(asset.source.logos[i]!=null)
						{
							var logoXml:XML=new XML('<logo>'+asset.source.logos[i]+'</logo>');
							logoXml.@id=i;
							track.animation.appendChild(logoXml);
						}
						
					}
					track.@layer=-layer-1;
					track.@x=asset.x;
					track.@y=asset.y;
					track.@width=helper.toEven(asset.width);
					track.@height=helper.toEven(asset.height);
					track.cue.startpos.@time=asset.timelineStart;
					track.@bgColor=asset.source.metadata.bgColor;
					break;
				}
				case GshahAssetType.AUDIO:
				{
					track=<sound/>;
					track.@layer=layer;
					track.source=asset.source.name;
					track.cue.startpos.@time=asset.timelineStart;
					
					for each (var p:Object in asset.parts) 
					{
						var px:XML=<part/>;
						px.@s=p.s;
						px.@e=p.e;
						track.cue.appendChild(px);
					}
					
					
					track.@fadein=asset.fadeIn;
					track.@fadeout=asset.fadeOut;
					track.@volume=asset.volume;
					break;
				}
				case GshahAssetType.VIDEO:
				{
					track=<track/>;
					track.source=asset.source.name;
					track.@layer=layer;
					track.@x=asset.x;
					track.@y=asset.y;
					track.@width=asset.width;
					track.@height=asset.height;
					track.cue.startpos.@time=asset.timelineStart;
					for each (p in asset.parts) 
					{
						px=<part/>;
						px.@s=p.s;
						px.@e=p.e;
						track.cue.appendChild(px);
					}
					track.@fadein=asset.fadeIn;
					track.@fadeout=asset.fadeOut;
					track.@greenscreenbackground=asset.greenScreenColor>0?'true':'false';
					track.@greenscreencolour1='#'+asset.greenScreenColor.toString(16);
					track.@greenscreentola=asset.greenScreenTola;
					track.@greenscreentolb=asset.greenScreenTolb;
					
					break;
				}
					
			}
			track.@uid=asset.source.uid;
			if(asset.parrentUuid!=null)
			{
				track.@parrentUuid=asset.parrentUuid;
			}
			track.@uuid=asset.uuid;
			track.@visibleOnPreview=asset.visibleOnPreview;
			track.@l=asset.layer;
			
			return track;
		}
		
		public static function correctAssetSize(asset:GshahAsset):void
		{
			if(asset.type!=GshahAssetType.AUDIO&&(asset.width>TimelineManager.instance.width||asset.height>TimelineManager.instance.height))
			{
				fullScreenAsset(asset);
				fixAssetRatio(asset);
			}
		}
		
		public static function fixAssetRatio(asset:GshahAsset):void
		{
			var helper:GshahUtils=new GshahUtils;
			
			var _scale:Number=Math.min(asset.width/asset.source.metadata.resX,asset.height/asset.source.metadata.resY);
			asset.x=helper.toEven((-_scale*asset.source.metadata.resX+asset.width)/2+asset.x);
			asset.y=helper.toEven((-_scale*asset.source.metadata.resY+asset.height)/2+asset.y);
			
			asset.width=helper.toEven(asset.source.metadata.resX*_scale);
			asset.height=helper.toEven(asset.source.metadata.resY*_scale);
		}
		
		public static function fullScreenAsset(asset:GshahAsset):void
		{
			asset.width=TimelineManager.instance.width;
			asset.height=TimelineManager.instance.height;
		}
	}
}