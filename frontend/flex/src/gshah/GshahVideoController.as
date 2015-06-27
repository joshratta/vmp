package gshah
{
	import flash.desktop.NativeProcess;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	
	import application.components.PreviewVideoUI;
	import application.managers.AssetSourceManager;
	import application.managers.GshahAnimationLibrary;
	import application.managers.ProjectManger;
	import application.managers.TimelineManager;
	import application.managers.UndoRedoManager;
	import application.managers.components.UndoRedoManagerItem;
	import application.managers.components.UndoRedoManagerItemType;
	import application.view.popups.GlamourAlert;
	
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahAssetType;
	import gshah.entities.GshahSource;
	import gshah.utils.GraphicUtils;
	import gshah.utils.GshahApi;
	import gshah.utils.GshahAssetUtils;
	import gshah.utils.GshahUtils;
	import gshah.utils.NativeProcessUtils;
	
	import sys.SystemSettings;
	
	public class GshahVideoController
	{
		protected var helper:GshahUtils;
		
		private var process:NativeProcess;
		
		public var timelineTcpPort:int;
		
		private var previewTcpPort:int;
		private var commandSocket:Socket;
		private var netStream:NetStream;
		
		private var closing:Boolean;
		
		public var renderMode:Boolean=false;
		
		public function GshahVideoController()
		{
			helper=new GshahUtils;
		}
		
		private var _previewVideo:PreviewVideoUI;
		
		[Bindable]
		public function get previewVideo():PreviewVideoUI
		{
			if(_previewVideo==null)
			{
				_previewVideo=new PreviewVideoUI;
				
			}
			return _previewVideo;
		}
		
		public function set previewVideo(value:PreviewVideoUI):void
		{
			_previewVideo = value;
		}
		
		[Bindable]
		public var paused:Boolean=true;
		
		[Bindable]
		public var ended:Boolean;
		
		protected function socketIOErrorHandler(event:IOErrorEvent=null):void
		{
			commandSocket=new Socket('127.0.0.1',previewTcpPort);
			commandSocket.addEventListener(Event.CONNECT,socketConnectHandler);
			commandSocket.addEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
			commandSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketSocketDataHandler);
		}
		
		protected function socketConnectHandler(event:Event):void
		{
			commandSocket.removeEventListener(Event.CONNECT,socketConnectHandler);
			setSize();
			
			changeBackground(TimelineManager.instance.bgColor);
			if(renderMode)
			{
				for each (var _a:GshahAsset in TimelineManager.instance.dataProvider.source) 
				{
					addAsset(_a);
				}
				play();
				
			}
			else
			{
				
				FlexGlobals.topLevelApplication.enabled=true;
				if(FlexGlobals.topLevelApplication.fileNameToOpen!=null)
				{
					ProjectManger.instance.open(new File(FlexGlobals.topLevelApplication.fileNameToOpen));
					FlexGlobals.topLevelApplication.fileNameToOpen=null;
					
				}
				
			}
		}
		
		protected function socketSocketDataHandler(event:ProgressEvent):void
		{
			var ba:ByteArray=new ByteArray;
			commandSocket.readBytes(ba);
			ba.position=0;
			sBufer+=ba.toString();
			var sep:String='\n\r';
			var sArr:Array=sBufer.substr(0,sBufer.lastIndexOf(sep)).split(sep);
			for each (var _s:String in sArr) 
			{
				if(_s.length>0)
				{
					if(_s.indexOf('TIMECODE')!=-1)
					{
						var tm:Array=_s.match(/TIMECODE;([0-9.-]+);[0-9-]+/);
						if(tm!=null&&tm.length>1)
						{
							var t:Number=parseFloat(tm[1]);
							if(!isNaN(t))
							{
								currentTime=t;
								//trace(currentTime);
							}
							//helper.log('commandSocket('+previewTcpPort+'): '+_s);
						}
					}
					else if(_s.indexOf('METADATA')!=-1)
					{
						var mm:Array=_s.match(/METADATA;([^;]+);([0-9-]+);([0-9-]+);([0-9.-]+);([0-9.]+)/);
						if(mm!=null&&mm.length>4)
						{
							var gs:GshahSettings=new GshahSettings;
							var f:File=new File(mm[1]);
							
							var type:String=GshahAssetType.getByExtention(f.extension);
							
							gs.resX=mm[2];
							gs.resY=mm[3];
							if(gs.resX==-1&&gs.resY==-1)
							{
								GlamourAlert.show('Import Failed','Error');
							}
							else
							{
								switch(type)
								{
									case GshahAssetType.AUDIO:
									case GshahAssetType.VIDEO:
									{
										gs.withAudio=true;
										gs.totalFrames=mm[5];
										gs.tbr=mm[4];
										break;
									}
										
									case GshahAssetType.IMAGE:
									{
										gs.totalFrames=mm[4];
										break;
									}
								}
								
								
								gs.duration=gs.totalFrames/gs.tbr;
								var _gs:GshahSource=AssetSourceManager.instance.addSource(f,gs);
								UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.SADD,[UndoRedoManager.removeSourceFunction(_gs)],[UndoRedoManager.addSourceFunction(_gs,AssetSourceManager.instance.dataProvider.getItemIndex(_gs))]));
							}
							
						}
						helper.log('commandSocket('+previewTcpPort+'): '+_s);
						
					}
					else if(_s.indexOf('GREENSCREENDATA')!=-1)
					{
						var gsm:Array=_s.match(/GREENSCREENDATA;([0-9]+);([0-9]+)/);
						if(gsm!=null&&gsm.length>2)
						{
							var rgb:uint=GraphicUtils.yuvToRgb({y:128,u:gsm[1],v:gsm[2]});
							if(GshahGreenScreen.instance.colorProvider.length==0)
							{
								GshahGreenScreen.instance.selectedColor=rgb;
							}
							if(GshahGreenScreen.instance.colorProvider.getItemIndex(rgb)<0)
							{
								GshahGreenScreen.instance.colorProvider.addItem(rgb);
							}
						}
						helper.log('commandSocket('+previewTcpPort+'): '+_s);
					}
					else if(_s.indexOf('EYEDROPDATA')!=-1)
					{
						var edd:Array=_s.match(/EYEDROPDATA;([0-9]+);([0-9]+);([0-9]+)/);
						if(edd!=null&&edd.length>3)
						{
							rgb=GraphicUtils.yuvToRgb({y:edd[1],u:edd[2],v:edd[3]});
							GshahGreenScreen.instance.selectedColor=rgb;
						}
						helper.log('commandSocket('+previewTcpPort+'): '+_s);
					}
					else if(_s.indexOf('AUTO_PAUSE')!=-1)
					{
						ended=true;
						paused=true;
						helper.log('commandSocket('+previewTcpPort+'): '+_s);
					}
					else if(_s.indexOf('HALT_SUCCESS')!=-1)
					{
						paused=true;
						helper.log('commandSocket('+previewTcpPort+'): '+_s);
						setHalt(TimelineManager.instance.cutChildX*TimelineManager.instance.milisecondsPerPixel/1000);
					}
					else 
					{
						helper.log('commandSocket('+previewTcpPort+'): '+_s);
					}
				}
				
			}
			sBufer=sBufer.substr(sBufer.lastIndexOf(sep));
		}
		
		
		private var _currentTime:Number=0;
		
		[Bindable]
		public function get currentTime():Number
		{
			return _currentTime;
		}
		
		public function set currentTime(value:Number):void
		{
			_currentTime = value;
			if(ended)
			{
				ended=false;
			}
			var _a:GshahAsset=TimelineManager.instance.currentItem;
			if(_a!=null&&(_a.timelineStart>_currentTime*1000||(_a.timelineStart+GshahAssetUtils.getAssetDuration(_a.parts))<_currentTime*1000))
			{
				TimelineManager.instance.currentIndex=-1;
			}
		}
		
		
		protected function metaDataHandler(infoObject:Object):void 
		{
			trace(infoObject.duration);
		}
		private var sBufer:String='';
		private function onProcessError(s:String):void
		{
			var a:Array=s.split('\r\n');
			
			for each (var p:String in a) 
			{
				if(p.length>0)
				{
					var m:Array=p.match(/[d]+/g);
					if(m==null||m.length==0||m[m.length-1].length!=p.length)
					{
						helper.log('stderr('+previewTcpPort+'): '+p);
					}
					
				}
				
				
			}
		}
		
		private function onProcessOutput(event:ProgressEvent):void
		{
			var ba:ByteArray=new ByteArray;
			process.standardOutput.readBytes(ba);
			netStream.appendBytes(ba);
			/*if(netStream.bufferLength>0.7)
			{
			trace('netStream.time='+netStream.time+' netStream.bufferLength='+netStream.bufferLength);
			send(GshahApi.CMD_DELAY);
			}*/
		}
		
		private static var _instance:GshahVideoController;
		
		[Bindable]
		public static function get instance():GshahVideoController
		{
			if(_instance==null)
			{
				_instance=new GshahVideoController;
			}
			return _instance;
		}
		
		public static function set instance(value:GshahVideoController):void
		{
			_instance = value;
		}
		
		public var ffmpegParams:Array;
		
		private var restarting:Boolean;
		
		public function initialize():void
		{
			helper=new GshahUtils;
			paused=true;
			ended=false;
			closing=false;
			lengthObject=new Object;
			restarting=false;
			
			
			previewTcpPort=helper.getNextPortNumber();
			timelineTcpPort=helper.getNextPortNumber();
			if(!renderMode)
			{
				var customClient:Object = new Object();
				customClient.onMetaData = metaDataHandler;
				
				var netConnection:NetConnection = new NetConnection();
				netConnection.connect(null);
				netStream = new NetStream(netConnection);
				netStream.client = customClient;
				netStream.bufferTime=0.5;
				netStream.bufferTimeMax=0.5;
				
				previewVideo.attachNetStream(netStream);
				
				netStream.play(null);
				
				process=NativeProcessUtils.runNativeProcess(SystemSettings.getBinFile(SystemSettings.VMP_CORE_BIN),
					[previewTcpPort,timelineTcpPort,TimelineManager.instance.width,TimelineManager.instance.height],NativeProcessUtils.errorHandlerFunction(onProcessError),onProcessOutput,process_exitHandler);
				
			}
			else
			{
				
				process=helper.writeAndLunch(
					[SystemSettings.getBinPath(SystemSettings.VMP_CORE_BIN),
						previewTcpPort,timelineTcpPort,previewVideo.width,previewVideo.height].join(' ')+' | '+ffmpegParams.join(' '),process_exitHandler,NativeProcessUtils.errorHandlerFunction(onProcessError));
				
			}
			NativeProcessUtils.addExclusionProcess(process);
			setTimeout(socketIOErrorHandler,100);
		}
		
		
		public var exitHandler:Function;
		private function process_exitHandler(event:NativeProcessExitEvent):void
		{
			if(renderMode)
			{
				if(exitHandler!=null)
				{
					exitHandler();
				}
			}
			else
			{
				if(restarting)
				{
					restarting=false;
					initialize();
				}
				else
				{
					helper.saveLog('c:');
					NativeProcessUtils.stopAll(true);
				}
			}
			
		}
		
		public function stop():void
		{
			seek(0);
			pause();
		}
		
		public function toogle():void
		{
			
			if(paused)
			{
				if(!ended)
				{
					play();
				}
			}
			else
			{
				pause();
			}
			
		}
		
		public function play():void
		{
			if(netStream!=null)
			{
				netStream.soundTransform.volume=100.0;
			}
			send(GshahApi.CMD_PLAY);
			paused=false;
			
		}
		public function pause():void
		{
			if(netStream!=null)
			{
				netStream.soundTransform.volume=0.0;
				
			}
			send(GshahApi.CMD_PAUSE);
			paused=true;
		}
		
		public function close():void
		{
			closing=true;
			send(GshahApi.CMD_QUIT);
		}
		public function changeBackground(rgb:uint):void
		{
			var yuv:Object=GraphicUtils.rgbToYuv(rgb);
			
			send(GshahApi.CMD_BACKGROUND+[yuv.y,yuv.u,yuv.v].join(';'));
		}
		
		public function eyeDrop(uuid:String,originalX:Number,originalY:Number,radiusX:Number,radiusY:Number):void
		{
			send(GshahApi.CMD_EYEDROP+[uuid,originalX,originalY,radiusX,radiusY].join(';'));
			
		}
		private function send(s:String):void
		{
			if(commandSocket!=null&&commandSocket.connected)
			{
				if(s.charAt(0)!=GshahApi.CMD_DELAY)
				{
					helper.log('sending: '+s+'|');
				}
				commandSocket.writeUTFBytes(s+'|');
				commandSocket.flush();
				
			}
			else if(helper!=null)
			{
				helper.log('sending false: '+s+'|');
			}
		}
		
		
		public function seek(seekTime:Number):void
		{
			if(seekTime>duration)
			{
				seekTime=duration;
			}
			
			send(GshahApi.CMD_SEEK+Math.max(0,seekTime).toFixed(3));
		}
		
		public var duration:Number=0;
		
		private var lengthObject:Object;
		public function changeLayersOrder():void
		{
			var ids:Array=[];
			for each (var a:GshahAsset in TimelineManager.instance.dataProvider) 
			{
				if(lengthObject.hasOwnProperty(a.uuid))
				{
					for (var j:int = 0 ; j < a.parts.length; j++) 
					{
						ids.unshift(a.uuid+j.toString());
					}
					
				}
				else
				{
					if(a.type==GshahAssetType.ANIMATION&&GshahAnimationLibrary.instance.isOutro(a.source.animationId))
					{
						for each (var _a:GshahAsset in TimelineManager.instance.dataProvider.source) 
						{
							if(_a.parrentUuid==a.uuid)
							{
								for (var k:int = 0 ; k < _a.parts.length; k++) 
								{
									ids.unshift(_a.uuid+k.toString());
								}
							}
						}
					}
					ids.unshift(a.uuid);
				}
			}
			send(GshahApi.CMD_LAYERS+ids.join(';'));
		}
		
		
		public function addAsset(a:GshahAsset,greenScreenPreview:Boolean=false):void
		{
			if(a!=null&&a.visibleOnPreview)
			{
				if(a.x<0)
				{
					a.x=0;
				}
				if(a.y<0)
				{
					a.y=0;
				}
				if((a.width+a.x)>TimelineManager.instance.width)
				{
					a.width=TimelineManager.instance.width-a.x;
				}
				if((a.height+a.y)>TimelineManager.instance.height)
				{
					a.height=TimelineManager.instance.height-a.y;
				}
				if(a.type==GshahAssetType.VIDEO||a.type==GshahAssetType.AUDIO)
				{
					if(lengthObject.hasOwnProperty(a.uuid)&&lengthObject[a.uuid]>a.parts.length)
					{
						for (var j:int = a.parts.length-1; j < lengthObject[a.uuid]; j++) 
						{
							removeAssetPart(a.uuid+j.toString());
						}
						
					}
					lengthObject[a.uuid]=a.parts.length;
					var i:int=0;
					var fromStart:Number=0;
					var toFinish:Number=GshahAssetUtils.getAssetDuration(a.parts);
					
					for each (var p:Object in a.parts) 
					{
						toFinish-=p.e-p.s;
						var yuv:Object;
						if(a.type==GshahAssetType.VIDEO)
						{
							if(greenScreenPreview)
							{
								yuv=GraphicUtils.rgbToYuv(GshahGreenScreen.instance.selectedColor);
								send(GshahApi.CMD_VIDEO+[a.uuid+i.toString(),a.source.source.nativePath,a.x.toFixed(3),a.y.toFixed(3),a.width.toFixed(3),a.height.toFixed(3),(a.timelineStart+fromStart)/1000,(p.e-p.s)/1000,p.s/1000,
									GshahGreenScreen.instance.calcColors?2:1,yuv.u,yuv.v,
									Math.round(Math.pow(2,Math.min(GshahGreenScreen.instance.tol1,GshahGreenScreen.instance.tol2)/16.0)),
									Math.round(Math.pow(2,Math.max(GshahGreenScreen.instance.tol1,GshahGreenScreen.instance.tol2)/16.0)),
									Math.max(0,a.fadeIn-fromStart)/1000,Math.max(0,a.fadeOut-toFinish)/1000,a.volume].join(';'));
							}
							else
							{
								yuv=GraphicUtils.rgbToYuv(a.greenScreenColor);
								send(GshahApi.CMD_VIDEO+[a.uuid+i.toString(),a.source.source.nativePath,a.x.toFixed(3),a.y.toFixed(3),a.width.toFixed(3),a.height.toFixed(3),(a.timelineStart+fromStart)/1000,(p.e-p.s)/1000,p.s/1000,
									a.greenScreenColor==-1?0:1,yuv.u,yuv.v,
									Math.round(Math.pow(2,a.greenScreenTola/16.0)),
									Math.round(Math.pow(2,a.greenScreenTolb/16.0)),
									Math.max(0,a.fadeIn-fromStart)/1000,Math.max(0,a.fadeOut-toFinish)/1000,a.volume].join(';'));
							}
						}
						else
						{
							send(GshahApi.CMD_SOUND+[a.uuid+i.toString(),a.source.source.nativePath,a.x.toFixed(3),a.y.toFixed(3),a.width.toFixed(3),a.height.toFixed(3),(a.timelineStart+fromStart)/1000,(p.e-p.s)/1000,p.s/1000,
								Math.max(0,a.fadeIn-fromStart)/1000,Math.max(0,a.fadeOut-toFinish)/1000,a.volume].join(';'));
						}
						fromStart+=p.e-p.s;
						i++;
					}
				}
				else if(a.type==GshahAssetType.IMAGE)
				{
					send(GshahApi.CMD_IMAGE+[a.uuid,a.source.source.nativePath,a.x.toFixed(3),a.y.toFixed(3),a.width.toFixed(3),a.height.toFixed(3),a.timelineStart/1000,(a.parts[0].e-a.parts[0].s)/1000,a.parts[0].s/1000,Math.max(0,a.fadeIn)/1000,Math.max(0,a.fadeOut)/1000].join(';'));
					
				}
				else if(a.type==GshahAssetType.ANIMATION||a.type==GshahAssetType.TEXT)
				{
					a.x=helper.toEven(a.x);
					a.y=helper.toEven(a.y);
					a.width=helper.toEven(a.width);
					a.height=helper.toEven(a.height);
					yuv=GraphicUtils.rgbToYuv(a.source.metadata.bgColor);
					send(GshahApi.CMD_ANIMATION+[a.uuid,a.source.ui.portNumber,a.x.toFixed(3),a.y.toFixed(3),
						a.width.toFixed(3),a.height.toFixed(3),a.timelineStart/1000,int(a.parts[0].e-a.parts[0].s)/1000,int(a.parts[0].s)/1000,a.source.metadata.resX,a.source.metadata.resY,a.source.metadata.tbr,
						/*Math.max(0,a.fadeIn)/1000,Math.max(0,a.fadeOut)/1000,*/a.source.metadata.bgColor==-1?256:yuv.y,a.source.metadata.bgColor==-1?256:yuv.u,a.source.metadata.bgColor==-1?256:yuv.v].join(';'));
					
				}
				calcDuration();
				changeLayersOrder();
			}
			else
			{
				trace('asset is null');
			}
		}
		public function calcDuration():void
		{
			var _duration:Number=0;
			for each (var _a:GshahAsset in TimelineManager.instance.dataProvider) 
			{
				_duration=Math.max(_duration,(_a.timelineStart+GshahAssetUtils.getAssetDuration(_a.parts))/1000);
				
			}
			duration=_duration;
		}
		
		private function removeAssetPart(uuid:String):void
		{
			send(GshahApi.CMD_REMOVE+uuid);
			
		}
		
		public function removeAsset(a:GshahAsset):void
		{
			if(a.type==GshahAssetType.VIDEO||a.type==GshahAssetType.AUDIO)
			{
				var i:int=0;
				for each (var p:Object in a.parts) 
				{
					removeAssetPart(a.uuid+i.toString());
					i++;
				}
				if(lengthObject.hasOwnProperty(a.uuid))
				{
					delete lengthObject[a.uuid];
				}
			}
			else
			{
				removeAssetPart(a.uuid);
				
			}
			calcDuration();
			changeLayersOrder();
		} 
		
		public function getMetadata(path:String):void
		{
			var type:String=GshahAssetType.getByExtention(new File(path).extension);
			switch(type)
			{
				case GshahAssetType.VIDEO:
				{
					send(GshahApi.CMD_METADATA_VIDEO+';'+path);
					break;
				}
					
				case GshahAssetType.IMAGE:
				{
					send(GshahApi.CMD_METADATA_IMAGE+';'+path);
					break;
				}
				case GshahAssetType.AUDIO:
				{
					send(GshahApi.CMD_METADATA_SOUND+';'+path);
					break;
				}
			}
		}
		
		private var _playerWidth:Number;
		
		[Bindable]
		public function get playerWidth():Number
		{
			return _playerWidth;
		}
		
		public function set playerWidth(value:Number):void
		{
			if(_playerWidth!=value)
			{
				_playerWidth = value;
				previewVideo.width=_playerWidth*_videoScale;
				
			}
		}
		
		private var _playerHeight:Number;
		
		[Bindable]
		public function get playerHeight():Number
		{
			return _playerHeight;
		}
		
		public function set playerHeight(value:Number):void
		{
			if(_playerHeight!=value)
			{
				_playerHeight = value;
				previewVideo.height=_playerHeight*_videoScale;
				
			}
		}
		
		public function setSize():void
		{
			send([GshahApi.CMD_RENDER+(renderMode?'1':'0'),TimelineManager.instance.width,previewVideo.width].join(';'));
		}
		
		private var _videoScale:Number=1;
		
		public function get videoScale():Number
		{
			return _videoScale;
		}
		
		public function set videoScale(value:Number):void
		{
			if(_videoScale!=value)
			{
				_videoScale = value;
				
				previewVideo.width=_playerWidth*_videoScale;
				previewVideo.height=_playerHeight*_videoScale;
				if(TimelineManager.instance.currentIndex>-1)
				{
					TimelineManager.instance.resizeComponent(TimelineManager.instance.currentIndex);
				}
			}
		}
		
		
		public function restart():void
		{
			restarting=true;
			close();
		}
		
		public function setHalt(t:Number):void
		{
			send(GshahApi.CMD_HALT+t);
		}
	}
}