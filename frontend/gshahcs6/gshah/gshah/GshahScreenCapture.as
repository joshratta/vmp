package gshah
{
	import flash.display.MovieClip;
	import gshah.utils.FfmpegVideoUtils;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.filesystem.File;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import gshah.utils.NativeProcessUtils;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import gshah.events.GshahEvent;
	import gshah.utils.GshahUtils;
	
	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	[Event(name="gshahError", type="gshah.events.GshahErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class GshahScreenCapture extends EventDispatcher
	{
		/**
		 * Instance of <code>gshah.GshahSettings</code> with all necessary properties about output video stream
		 */		
		[Bindable]
		public var settings:GshahSettings;
		
		private var timer:Timer;
		
		private var helper:GshahUtils;
		
		public function GshahScreenCapture()
		{
			
		}
		
		private var tempFolderPath:String;
		private var tempFolder:File;
		private var fps:int=5;
		public function startRecording(fileNameWithFullPath:String,fps:int=5):void
		{
			helper=new GshahUtils;
			
			settings=new GshahSettings;
			settings.outPath=fileNameWithFullPath;
			timer=null;
			this.fps=fps;
			framesCount=0;
			framesToWrite=0;
			tempFolder=File.createTempDirectory();
			tempFolderPath=tempFolder.nativePath;
			checkOutFile();
		}
		public function finishRecording():void
		{
			timer.stop();
			timer=null;
			if(framesToWrite==0)
			{
				startSaving();
			}
				
		}
		public function cancelRecording():void
		{
			timer.stop();
			timer=null;
			tempFolder.deleteDirectory(true);
		}
		/**
		 * @private
		 * Check if output file exists and create it if not
		 * 
		 */
		private function checkOutFile():void
		{
			var outFile:File=new File(settings.outPath);
			if(outFile.exists)
			{
				preparePathes();
			}
			else
			{
				helper.addEventListener(GshahEvent.GSHAH_COMPLETE,preparePathes);
				helper.createEmptyFile(outFile);
			}
		}
		/**
		 * @private 
		 * Starts conversion pathes from standart to short
		 */		
		private function preparePathes(event:GshahEvent=null):void
		{
			if(event!=null)
			{
				helper.removeEventListener(GshahEvent.GSHAH_COMPLETE,preparePathes);
			}
			var sfnCmdContent:String=FfmpegVideoUtils.SFN_CMD_CONTENT;
			var videoPaths:Array=[settings.outPath,tempFolderPath];
			
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
			helper.getShortPathes(videoPaths);
		}
		
		
		
		/**
		 * @private 
		 * Exit handler for the preparePathes method
		 */
		protected function onGetShortPathes(event:GshahEvent):void
		{
			helper.removeEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
			var outArr:Array=event.data.split("\r\n");
			if(outArr.length==4)
			{
				settings.outPath=outArr[2];
				tempFolderPath=outArr[3];
			}
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,startCapture);
			helper.checkFilesExist(checkFiles);
			
			
		}
		private var checkFiles:Array=[{o:false, f:FfmpegVideoUtils.FFMPEG_LOCATION,r:FfmpegVideoUtils.FFMPEG_RESOURCE},
									  {o:true, f:FfmpegVideoUtils.SCREENSHOOTER_EXE_LOCATION,r:FfmpegVideoUtils.SCREENSHOOTER_RESOURCE}];

		private var framesCount:int=0;
		
		private var noteTime:int;
		private function startCapture(event:GshahEvent=null):void
		{
			timer=new Timer(1000/fps);
			timer.addEventListener(TimerEvent.TIMER,captureScreen);
			timer.start();	
		}
		private var framesToWrite:int=0;
		private function captureScreen(event:TimerEvent=null):void
		{
			
			framesCount++;
			framesToWrite++;
			NativeProcessUtils.runNativeProcess(FfmpegVideoUtils.SCREENSHOOTER_EXE_LOCATION, [tempFolderPath+File.separator+"sh"+framesCount+".bmp"], 
				NativeProcessUtils.errorHandlerFunction(onScreenshootError), NativeProcessUtils.outputHandlerFunction(onScreenshootError), onFrameWritten);

		}
		public function onScreenshootError(s:String):void
		{
			
		}
		protected function onFrameWritten(event:NativeProcessExitEvent):void
		{
			framesToWrite--;
			if(timer==null&&framesToWrite==0)
			{
				startSaving();
			}
		}
		
		[Bindable]
		/**
		 *  Dispatches <code>flash.events.ProgressEvent</code> events.
		 *  Use this <code>flash.events.EventDispatcher</code> instance
		 *  to watch the montage process progress.
		 */
		private function startSaving():void
		{
			trace("framesCount="+framesCount);
			var params:Array=["-framerate", fps, 
							  FfmpegVideoUtils.COMMAND_INPUT, tempFolderPath+File.separator+"sh%d.bmp",
							  "-c:v", "libx264", FfmpegVideoUtils.COMMAND_FRAMERATE, settings.tbr, "-pix_fmt", "yuv420p", settings.outPath, FfmpegVideoUtils.COMMAND_REWRITE];
			
			trace(params.join(' '));
			
			noteTime=getTimer();
			
			NativeProcessUtils.runNativeProcess(FfmpegVideoUtils.FFMPEG_LOCATION, params, 
				NativeProcessUtils.errorHandlerFunction(onSavingError), NativeProcessUtils.outputHandlerFunction(onSavingError), onVideoDoneReadHandler);
		}
		
		private var curFrame:Number=0;
		/**
		 * @private 
		 * Output data handler for the startSaving method
		 */
		public function onSavingError(s:String):void
		{
			trace(s);
			var errDataArr:Array=s.split('\\n');
			
			var errDataLast:String=errDataArr[errDataArr.length-1];
			var frameMatches:Array=errDataLast.match(/frame=[^0-9]+([0-9]+)/);
			if(frameMatches!=null&&frameMatches.length==2)
			{
				if(curFrame<frameMatches[1])
				{
					curFrame=frameMatches[1];
					dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,curFrame,framesCount));
				}
			}
		}
		/**
		 * @private 
		 * Exit handler for the startMontage method
		 */
		public function onVideoDoneReadHandler(event:NativeProcessExitEvent):void
		{			
			tempFolder.deleteDirectory(true);
			dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,"done processing video, see result at " + settings.outPath +", took "+(getTimer()-noteTime)+"ms"));
			
		}
	}
}