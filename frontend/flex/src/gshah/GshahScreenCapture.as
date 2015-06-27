package gshah
{
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.SystemTrayIcon;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import application.assets.ApplicationAssets;
	import application.managers.TimelineManager;
	
	import gshah.events.GshahEvent;
	import gshah.utils.GshahUtils;
	import gshah.utils.NativeProcessUtils;
	
	import sys.SystemSettings;
	
	public class GshahScreenCapture extends GshahAbstractService
	{
		[Bindable]
		public static var audioDeviceDataProvider:ArrayCollection;
		
		public function GshahScreenCapture()
		{
			if(!ready)
			{
				sBufer='';
				captureProcess=NativeProcessUtils.runNativeProcess(SystemSettings.getBinFile(SystemSettings.SCREEN_SHOOTER_BIN),[],NativeProcessUtils.errorHandlerFunction(onProcessError),NativeProcessUtils.outputHandlerFunction(onProcessError),onMicrophoneDataDoneHandler);
			}
		}
		private var fps:int=5;
		
		public function startRecording(fileNameWithFullPath:String,soundDeviceIds:Array,recordingSizeOptions:int,highlightMouseCursor:Boolean,fps:int=5):void
		{
			helper=new GshahUtils;
			running=true;
			settings=new GshahSettings;
			settings.outPath=fileNameWithFullPath;
			settings.resX=TimelineManager.DEFAULT_WIDTH;
			settings.resY=TimelineManager.DEFAULT_HEIGHT;
			
			this.fps=fps;
			
			sBufer='';
			
			dock();
			readyToExit=false;
			captureProcess=NativeProcessUtils.runNativeProcess(
				SystemSettings.getBinFile(SystemSettings.SCREEN_SHOOTER_BIN),
				[settings.outPath,fps,soundDeviceIds.length==0?'-1':soundDeviceIds.join(':'),recordingSizeOptions,highlightMouseCursor?'1':'0'],
					NativeProcessUtils.errorHandlerFunction(onProcessError),
					NativeProcessUtils.outputHandlerFunction(onProcessError),
					onVideoDoneReadHandler);
				trace([SystemSettings.getBinFile(SystemSettings.SCREEN_SHOOTER_BIN).nativePath,settings.outPath,fps,soundDeviceIds.length==0?'-1':soundDeviceIds.join(':'),recordingSizeOptions,highlightMouseCursor?'1':'0'].join(' '));
				
				}
		
		private var readyToExit:Boolean;
		
		private var isFirstInvoke:Boolean;
		public function dock(event:Event = null):void{
			
			
			NativeApplication.nativeApplication.icon.bitmaps = [ApplicationAssets.dockIcon16,ApplicationAssets.dockIcon128];
			
			if(NativeApplication.supportsDockIcon){
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;				
				isFirstInvoke=true;
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, finishRecording);
			} 
			else if (NativeApplication.supportsSystemTrayIcon){
				var sysTrayIcon:SystemTrayIcon =
					NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = "Click here to stop capturing";
				sysTrayIcon.addEventListener(MouseEvent.CLICK,finishRecording); 
				isFirstInvoke=false;
			}
			FlexGlobals.topLevelApplication.stage.nativeWindow.visible = false;
			
		}
		
		public function undock(event:Event = null):void{
			FlexGlobals.topLevelApplication.stage.nativeWindow.visible = true;
			NativeApplication.nativeApplication.icon.bitmaps = [];
		}
		public function finishRecording(event:Event = null):void
		{
			if(!isFirstInvoke)
			{
				if(readyToExit)
				{
					NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, finishRecording);
					captureProcess.exit(true);
				}
			}
			else
			{
				setTimeout(function():void{isFirstInvoke=false;},1000);
			}
		}
		public function cancelRecording():void
		{
			running=false;
			captureProcess.exit(true);
		}
		
		
		private var captureProcess:NativeProcess;
		
		public function onVideoDoneReadHandler(event:NativeProcessExitEvent):void
		{
			undock();
			if(running)
			{
				running=false;
				dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,settings.outPath));
			}
		}
		
		[Bindable]
		public static var ready:Boolean=false;
		
		public function onMicrophoneDataDoneHandler(event:NativeProcessExitEvent):void
		{
			var sep:String='\n';
			var sArr:Array=sBufer.replace(/\\r/g,'').split(sep);
			var _audioDeviceDataProvider:ArrayCollection=new ArrayCollection;
			for each (var _s:String in sArr) 
			{
				if(_s.length>0)
				{
					if(_s.indexOf('CAPTUREAUDIODATA')!=-1)
					{
						var cad:Array=_s.split(';');
						if(cad!=null&&cad.length>2)
						{
							_audioDeviceDataProvider.addItem({id:cad[1],label:cad[2]});
						}
					}
				}
			}
			
			audioDeviceDataProvider=_audioDeviceDataProvider;
			ready=true;
		}
		private var sBufer:String='';
		
		private function onProcessError(s:String):void
		{
			sBufer+=s;
			if(sBufer.indexOf('running callback')!=-1)
			{
				readyToExit=true;
			}
			
		}
	}
}