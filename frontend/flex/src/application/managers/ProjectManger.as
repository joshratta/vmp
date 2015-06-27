package application.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.utils.UIDUtil;
	
	import application.components.LoadingContainer;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZipFile;
	
	import fonts.GshahFont;
	
	import gshah.GshahAnimationUI;
	import gshah.GshahTextUI;
	import gshah.GshahVideoController;
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahAssetType;
	import gshah.entities.GshahSource;
	import gshah.events.GshahEvent;
	import gshah.intros.texts.GshahTextFont;
	import gshah.utils.GshahAssetUtils;
	import gshah.utils.GshahUtils;
	import gshah.utils.NativeProcessUtils;
	
	import sys.SystemSettings;
	
	public class ProjectManger
	{
		[Bindable]
		private var timelineManger:TimelineManager=TimelineManager.instance;
		
		private static var _instance:ProjectManger;
		[Bindable]
		public static function get instance():ProjectManger
		{
			if(_instance==null)
			{
				_instance=new ProjectManger;
			}
			return _instance;
		}
		
		public static function set instance(value:ProjectManger):void
		{
			_instance = value;
		}
		public function ProjectManger()
		{
		}
		
		private var totalSize:Number;
		private var totalLoaded:Number;
		private var fzip:FZip;
		private var i:int;
		private var l:int;
		private var projectPath:String;
		public function clear():void
		{
			stopAuto();
			AssetSourceManager.instance.clear();
			timelineManger.clear();
			NativeProcessUtils.stopAll();
		}
		
		public function open(file:File):void
		{
			LoadingContainer.instance.start(progressSource);
			
			i=0;
			totalLoaded=0;
			projectPath = file.url;
			totalSize=file.size;
			clear();
			
			fzip=new FZip();
			fzip.addEventListener(ProgressEvent.PROGRESS, onStreamsProgress);
			fzip.addEventListener(Event.COMPLETE,onZipFileLoaded);
			fzip.load(new URLRequest(projectPath));
			
		}
		
		
		private var timer:Timer;
		
		public function startAuto(e:Event=null):void
		{
			timer=new Timer(60000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,autoSave);
			timer.start();
		}
		public function stopAuto(e:Event=null):void
		{
			if(timer!=null&&timer.running)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,autoSave);
				timer.stop();
				timer=null;
			}
			
		}
		
		public function autoSave(e:Event=null):void
		{
			stopAuto();
			var f:File=File.desktopDirectory.resolvePath('autosave.vfs');
			var _projectXML:XML=timelineManger.getProjectXML();
			_projectXML.@auto="1";
			var _fzip:FZip=new FZip();
			_fzip.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_fzip.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			var xmlByteArray:ByteArray=new ByteArray;
			xmlByteArray.writeUTFBytes(_projectXML.toString());
			_fzip.addFile('project.xml',xmlByteArray);
			var fs:FileStream=new FileStream;
			fs.addEventListener(IOErrorEvent.IO_ERROR,onError);
			fs.addEventListener(Event.CLOSE,startAuto);
			fs.openAsync(f,FileMode.WRITE);
			_fzip.serialize(fs);
			_fzip.close();
			fs.close();
		}		
		
		private var logoPathes:Array;
		
		public function save(file:File):void
		{
			stopAuto();
			LoadingContainer.instance.start(progressSource,'Saving');
			i=0;
			l=0;
			
			totalLoaded=0;
			projectPath = file.nativePath.replace(/\\/g, File.separator);
			if(projectPath.indexOf(".vfs")==-1)
			{
				projectPath+=".vfs";
			}
			logoPathes=[];
			totalSize=0;
			var _projectXML:XML=timelineManger.getProjectXML();
			for each (var track:XML in _projectXML.video.track.(@layer<0)) 
			{
				if(track!=null&&track.hasOwnProperty('animation'))
				{
					var k:int=0;
					for each (var l:XML in track.animation.logo) 
					{
						var uid:String=UIDUtil.createUID();
						logoPathes.push({p:l.toString(),uid:uid});
						var logoXml:XML=new XML('<logo>logos'+File.separator+uid+'_'+(new File(l.toString())).name+'</logo>');
						logoXml.@id=l.@id;
						track.animation.logo[k]=logoXml;
						k++;
					}
				}
			}
			
			
			fzip=new FZip();
			fzip.addEventListener(IOErrorEvent.IO_ERROR, onError);
			fzip.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			var xmlByteArray:ByteArray=new ByteArray;
			xmlByteArray.writeUTFBytes(_projectXML.toString());
			fzip.addFile('project.xml',	xmlByteArray);
			fzip.addEventListener(ProgressEvent.PROGRESS,onZipProgress);
			totalSize+=AssetSourceManager.instance.getTotalSize();
			saveNextAssetFile();
		}
		private var helper:GshahUtils=new GshahUtils;
		protected function onError(event:Event):void
		{
			helper.log('file saving error: '+event+' target: '+event.target)
		}
		
		protected function onZipProgress(event:ProgressEvent):void
		{
			progressSource.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,totalLoaded+event.bytesLoaded,totalSize*2));
			
		}
		
		private var aByteArray:ByteArray;
		
		private function saveNextAssetFile(event:Event=null):void
		{
			var a:GshahSource;
			var lf:File;
			var aLoader:URLLoader;
			if(event!=null)
			{
				if(i<AssetSourceManager.instance.dataProvider.length)
				{
					a=AssetSourceManager.instance.dataProvider.getItemAt(i) as GshahSource ;
					aLoader=event.target as URLLoader;
					fzip.addFile(a.uid+'_'+a.name,aLoader.data);
					helper.log('file saving: '+a.uid+'_'+a.name);
					totalLoaded+=a.source.size;
					i++;
				}
				else if(l<logoPathes.length)
				{
					lf=new File(logoPathes[l].p);
					aLoader=event.target as URLLoader;
					fzip.addFile('logos'+File.separator+logoPathes[l].uid+'_'+lf.name,aLoader.data);
					helper.log('file saving: '+'logos'+File.separator+logoPathes[l].uid+'_'+lf.name);
					
					totalLoaded+=lf.size;
					l++;
				}
				
			}
			if(i<AssetSourceManager.instance.dataProvider.length)
			{
				a=AssetSourceManager.instance.dataProvider.getItemAt(i) as GshahSource ;
				
				aLoader=new URLLoader;
				aLoader.dataFormat=URLLoaderDataFormat.BINARY;
				aLoader.addEventListener(ProgressEvent.PROGRESS, onStreamsProgress);
				aLoader.addEventListener(Event.COMPLETE, saveNextAssetFile);
				aLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				aLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				helper.log('file saving: '+a.source.url);
				
				aLoader.load(new URLRequest(a.source.url));
			}
			else if(l<logoPathes.length)
			{
				lf=new File(logoPathes[l].p);
				aLoader=new URLLoader;
				aLoader.dataFormat=URLLoaderDataFormat.BINARY;
				aLoader.addEventListener(ProgressEvent.PROGRESS, onStreamsProgress);
				aLoader.addEventListener(Event.COMPLETE, saveNextAssetFile);
				aLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				aLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				helper.log('file saving: '+lf.url);
				aLoader.load(new URLRequest(lf.url));
			}
			else
			{
				helper.log('file saving: '+projectPath);
				helper.log('file saving: spaceAvailable='+new File(projectPath).parent.spaceAvailable);
				var fs:FileStream=new FileStream;
				fs.addEventListener(ProgressEvent.PROGRESS, onStreamsProgress);
				fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onStreamsOutputProgress);
				fs.addEventListener(IOErrorEvent.IO_ERROR,onError);
				fs.addEventListener(Event.CLOSE,onSaveZipClose);
				fs.openAsync(new File(projectPath),FileMode.WRITE);
				fzip.serialize(fs);
				fzip.close();
				fs.close();
			}
		}	
		
		protected function onStreamsOutputProgress(event:OutputProgressEvent):void
		{
			//trace((totalLoaded+event.bytesTotal-event.bytesPending)/(totalSize+event.bytesTotal));
			//LoadingContainer.instance.progressBar.setProgress(totalLoaded+event.bytesTotal-event.bytesPending,totalSize+event.bytesTotal);
			progressSource.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,totalLoaded+event.bytesTotal-event.bytesPending,totalSize+event.bytesTotal));
			
		}
		[Bindable]
		private var progressSource:EventDispatcher=new EventDispatcher;
		
		protected function onStreamsProgress(event:ProgressEvent):void
		{
			//trace((totalLoaded+event.bytesLoaded)/(totalSize*2));
			//LoadingContainer.instance.progressBar.setProgress(totalLoaded+event.bytesLoaded,totalSize*2);
			
			progressSource.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,totalLoaded+event.bytesLoaded,totalSize*2));
		}
		
		protected function onSaveZipClose(event:Event):void
		{
			setTimeout(LoadingContainer.instance.stop,500);
			helper.log('file saving: finished');
			startAuto();
			
		}
		protected function onOpenZipClose(event:Event):void
		{
			fzip.loadBytes(aByteArray);
			fzip.addEventListener(FZipEvent.FILE_LOADED,onZipFileLoaded);
			
		}
		
		private var projectXML:XML;
		
		protected function onZipFileLoaded(event:Event):void
		{
			i=1;
			totalLoaded=totalSize;
			for (var j:int = 1; j < fzip.getFileCount(); j++) 
			{
				totalSize+=fzip.getFileAt(j).sizeUncompressed;
			}
			projectXML=new XML(fzip.getFileAt(0).getContentAsString());
			timelineManger.bgColor=parseInt(projectXML.video.@bgColor.toString().substr(1),16);
			timelineManger.lowerThirdsDelay=parseFloat(projectXML.video.@lowerThirdsDelay.toString());
			
			if(projectXML.hasOwnProperty('@auto'))
			{
				for each (var _s:XML in projectXML.sources.children()) 
				{
					if(_s.hasOwnProperty('@path')&&new File(_s.@path).exists)
					{
						var a:GshahSource=AssetSourceManager.instance.addSource(new File(_s.@path),GshahAssetUtils.xmlToMetada(_s));
						a.uid=_s.@uid;
						addAssetsBySource(a);
					}
				}
				animationsCount=0;
				totalAnimations=projectXML.video.track.(@layer<0).animation.length();
				setTimeout(addNextAnimation,500);
				
			}
			else
			{
				openNextAssetFile();
				
			}
		}
		private function openNextAssetFile(event:Event=null):void
		{
			var fzf:FZipFile;
			if(event!=null)
			{
				fzf=fzip.getFileAt(i);
				if(fzf.filename.indexOf('logos'+File.separator)==-1)
				{
					
					var a:GshahSource=AssetSourceManager.instance.addSource(SystemSettings.tempFolder.resolvePath(fzf.filename),GshahAssetUtils.xmlToMetada(projectXML.sources.children().(@uid==fzf.filename.substr(0,36))[0]));
					addAssetsBySource(a);
				}
				totalLoaded+=fzf.sizeUncompressed;
				i++;
			}
			if(i<fzip.getFileCount())
			{
				fzf=fzip.getFileAt(i);
				var fs:FileStream=new FileStream;
				fs.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onOpenStreamsOutputProgress);
				fs.addEventListener(Event.CLOSE,openNextAssetFile);
				fs.openAsync(SystemSettings.tempFolder.resolvePath(fzf.filename),FileMode.WRITE);
				fs.writeBytes(fzf.content);
				fs.close();
			}
			else
			{
				animationsCount=0;
				totalAnimations=projectXML.video.track.(@layer<0).animation.length();
				setTimeout(addNextAnimation,500);
			}
		}	
		
		private var totalAnimations:int;
		private var animationsCount:int;
		
		
		protected function addNextAnimation(event:GshahEvent=null):void
		{
			for each (var track:XML in projectXML.video.track.(@layer<0)) 
			{
				if(track!=null&&!track.hasOwnProperty('@completed'))
				{
					if(track.hasOwnProperty('animation'))
					{
						if(event==null)
						{
							animationsCount++;
							var texts:Array=[]
							for each (var t:XML in track.animation.text) 
							{
								texts[int(t.@id.toString())]=new GshahTextFont(t.toString(),t.@fontName.toString(),t.@fontSize.toString(),t.@fontColor.toString());
							}
							
							
							var logos:Array=new Array(track.animation.logo.length());
							for each (var l:XML in track.animation.logo) 
							{
								if(projectXML.hasOwnProperty('@auto'))
								{
									if(new File(l.toString()).exists)
									{
										logos[int(l.@id.toString())]=new File(l.toString()).nativePath.replace(/\\/g, File.separator);
									}
								}
								else
								{
									logos[int(l.@id.toString())]=SystemSettings.tempFolder.resolvePath(l.toString()).nativePath.replace(/\\/g, File.separator);
									
								}
							}
							
							LoadingContainer.instance.start(null, 'Creating Animation '+animationsCount+'/'+totalAnimations);
							var guic:GshahAnimationUI=new GshahAnimationUI;
							guic.overlay=GshahAnimationLibrary.instance.getAnimationById(track.animation.@id);
							guic.addEventListener(GshahEvent.GSHAH_COMPLETE, addNextAnimation);
							guic.createAsset(texts,logos);
							TimelineManager.instance.animationContainer.addChild(guic);
						}
						else
						{
							event.target.removeEventListener(GshahEvent.GSHAH_COMPLETE, addNextAnimation);
							track.@completed=1;
							var s:GshahSource=event.data as GshahSource;
							s.uid=track.@uid;
							var asset:GshahAsset=new GshahAsset(s,s.type);
							asset.uuid=track.@uuid;
							asset.x=track.@x;
							asset.y=track.@y;
							asset.width=track.@width;
							asset.height=track.@height;
							asset.timelineStart=track.cue.startpos.@time;	
							asset.visibleOnPreview=track.@visibleOnPreview=="true";
							
							asset.source.metadata.bgColor=track.@bgColor;
							track.@layer++;
							if(track.hasOwnProperty('@l'))
							{
								asset.layer=track.@l;
								
							}
							else
							{
								asset.layer=Math.abs(track.@layer);
							}
							putIntoTimeline(asset,Math.abs(track.@layer),null);	
							LoadingContainer.instance.stop();
							addNextAnimation();
						}
						return;
					}
					else if(track.hasOwnProperty('@text'))
					{
						if(event==null)
						{
							var gshahUI:GshahTextUI=new GshahTextUI();
							TimelineManager.instance.animationContainer.addChild(gshahUI);
							var inputFont:Font;
							for each (var gf:GshahFont in GshahFont.getFontProvider()) 
							{
								for each (var f:Font in gf.fonts) 
								{
									if(f.fontName==track.@fontName&&f.fontStyle==track.@fontStyle)
									{
										inputFont=f;
										break;
									}
								}
							}
							gshahUI.addEventListener(GshahEvent.GSHAH_COMPLETE, addNextAnimation);
							gshahUI.updateText(inputFont,track.@fontColor,track.@alignmentIndex,track.@text,false);
							
						}
						else
						{
							track.@completed=1;
							event.target.removeEventListener(GshahEvent.GSHAH_COMPLETE, addNextAnimation);
							asset=event.data as GshahAsset;
							asset.uuid=track.@uuid;
							asset.x=track.@x;
							asset.y=track.@y;
							asset.width=track.@width;
							asset.height=track.@height;
							asset.timelineStart=track.cue.startpos.@time;
							asset.parts=[{s:0,e:(track.cue.endpos.@time-asset.timelineStart)}];
							asset.visibleOnPreview=track.@visibleOnPreview=="true";
							track.@layer++;
							if(track.hasOwnProperty('@l'))
							{
								asset.layer=track.@l;
								
							}
							else
							{
								asset.layer=Math.abs(track.@layer);
							}
							putIntoTimeline(asset,Math.abs(track.@layer),null);	
							addNextAnimation();
						}
						return;
					}
					
				}
				
			}
			GshahVideoController.instance.changeLayersOrder();
			setTimeout(LoadingContainer.instance.stop,500);
			startAuto();
			
			timelineManger.calcLayers();
		}
		
		
		protected function addAssetsBySource(_source:GshahSource):void
		{
			var tracks:XMLList=projectXML.video.children().(@uid==_source.uid);
			for each (var track:XML in tracks) 
			{
				
				if(track!=null&&!track.hasOwnProperty('@completed'))
				{
					var _type:String=track.name().localName=='sound'?GshahAssetType.AUDIO:_source.type;
					var asset:GshahAsset=new GshahAsset(_source,_type);
					asset.uuid=track.@uuid;
					if(track.hasOwnProperty('@parrentUuid'))
					{
						asset.parrentUuid=track.@parrentUuid;
					}
					track.@completed=1;
					switch(asset.type)
					{
						case GshahAssetType.IMAGE:
						{
							
							asset.x=track.@x;
							asset.y=track.@y;
							asset.width=track.@width;
							asset.height=track.@height;
							asset.timelineStart=track.cue.startpos.@time;
							asset.parts=[{s:0,e:(track.cue.endpos.@time-asset.timelineStart)}];
							asset.fadeIn=track.@fadein;
							asset.fadeOut=track.@fadeout;
							break;
						}
						case GshahAssetType.ANIMATION:
						case GshahAssetType.TEXT:
						{
							break;
						}
						case GshahAssetType.AUDIO:
						{
							var parts:Array=[];
							for each (var p:XML in track.cue.part) 
							{
								parts.push({s:Number(p.@s.toString()),e:Number(p.@e.toString())});
							}
							asset.parts=parts;
							asset.timelineStart=track.cue.startpos.@time;
							asset.fadeIn=track.@fadein;
							asset.fadeOut=track.@fadeout;
							asset.volume=track.@volume;
							break;
						}
						case GshahAssetType.VIDEO:
						{
							
							asset.x=track.@x;
							asset.y=track.@y;
							asset.width=track.@width;
							asset.height=track.@height;
							parts=[];
							for each (p in track.cue.part) 
							{
								parts.push({s:Number(p.@s.toString()),e:Number(p.@e.toString())});
							}
							asset.parts=parts;
							asset.timelineStart=track.cue.startpos.@time;
							asset.fadeIn=track.@fadein;
							asset.fadeOut=track.@fadeout;
							asset.volume=track.@volume;
							if(track.@greenscreenbackground.toString()=='true')
							{
								asset.greenScreenColor=parseInt(track.@greenscreencolour1.toString().substr(1),16);
								asset.greenScreenTola=int(track.@greenscreentola.toString());
								asset.greenScreenTolb=int(track.@greenscreentolb.toString());
							}
							else
							{
								asset.greenScreenColor=-1;
								asset.greenScreenTola=-1;
								asset.greenScreenTolb=-1;
							}
							
							break;
						}
							
					}
					asset.visibleOnPreview=track.@visibleOnPreview=="true";
					
					if(track.hasOwnProperty('@l'))
					{
						asset.layer=track.@l;
						
					}
					else
					{
						asset.layer=Math.abs(track.@layer);
					}
					
					putIntoTimeline(asset,Math.abs(track.@layer),track.@binduuid.toString());	
				}
			}
			
		}
		
		
		
		private function putIntoTimeline(_asset:GshahAsset,_layer:int,_binduuid:String):void
		{
			var added:Boolean=false;
			for (var j:int = 0; j < timelineManger.dataProvider.length; j++) 
			{
				var asset:GshahAsset=timelineManger.dataProvider.getItemAt(j) as GshahAsset;
				var layer:int=Math.abs((projectXML.video.children().(@uuid==asset.uuid)[0]).@layer);
				//var binduuid:String=(projectXML.video.children().(@uuid==asset.uuid)[0]).@binduuid.toString();
				
				if(!added&&layer<_layer)
				{	
					timelineManger.dataProvider.addItemAt(_asset,j);
					added=true;
				}
				
			}
			if(!added)
			{
				timelineManger.dataProvider.addItem(_asset);
			}
			
			if(_asset.visibleOnPreview)
			{
				GshahVideoController.instance.addAsset(_asset);
			}
			

		}
		
		protected function onOpenStreamsOutputProgress(event:OutputProgressEvent):void
		{
			trace((totalLoaded+event.bytesTotal-event.bytesPending)/totalSize);
			
			progressSource.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,totalLoaded+event.bytesTotal-event.bytesPending,totalSize));
			
			
		}
		
	}
}