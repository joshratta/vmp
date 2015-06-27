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
	import gshah.utils.GshahUtils;
	import gshah.events.GshahEvent;
	
	public class GshahAudioExtractor extends EventDispatcher
	{
		/**
		 * Instance of <code>gshah.GshahSettings</code> with all necessary properties about output video stream
		 */		
		[Bindable]
		public var settings:GshahSettings;
		
		private var inPath:String;
		
		private var helper:GshahUtils;
		
		public function GshahAudioExtractor()
		{
			
		}
		public function startExtract(inPath:String,outPath:String,settings:GshahSettings=null):void
		{
			helper=new GshahUtils;
			if(settings==null)
			{
				this.settings=new GshahSettings;
			}
			else
			{
				this.settings=settings;
			}
			
			this.settings.outPath=outPath;
			this.inPath=inPath;
			curTime=0;
			
			checkOutFile();
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
			var videoPaths:Array=[settings.outPath,inPath];
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
			helper.getShortPathes(videoPaths);

		}
		
		/**
		 * @private 
		 * Handler for the preparePathes method
		 */
		protected function onGetShortPathes(event:GshahEvent):void
		{
			helper.removeEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
			var outArr:Array=event.data.split("\r\n");
			if(outArr.length==4)
			{
				settings.outPath=outArr[2];
				inPath=outArr[3];
			}
			
			
			FfmpegVideoUtils.getVideoSettings(inPath,onGetTrackParams);
		}
		

		/**
		 * @private
		 */
		private function onGetTrackParams(s:GshahSettings):void
		{
			settings.duration=s.duration;
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,extractAudio);
			helper.checkFilesExist(checkFiles);
		}
		private var checkFiles:Array=[{o:false, f:FfmpegVideoUtils.FFMPEG_LOCATION,r:FfmpegVideoUtils.FFMPEG_RESOURCE}];

		
		private var noteTime:int;
		
		private function extractAudio(event:GshahEvent=null):void
		{
			var params:Array=[
				FfmpegVideoUtils.COMMAND_INPUT,inPath,
				FfmpegVideoUtils.COMMAND_AUDIO_BITRATE, settings.audioBitrate,
				FfmpegVideoUtils.COMMAND_AUDIO_CHANELS, settings.audioChanels,
				FfmpegVideoUtils.COMMAND_AUDIO_RATE, settings.audioRate,
				FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_VIDEO, 
				settings.outPath, FfmpegVideoUtils.COMMAND_REWRITE];
			
			trace(params.join(' '));
			
			noteTime=getTimer();
			
			NativeProcessUtils.runNativeProcess(FfmpegVideoUtils.FFMPEG_LOCATION, params, 
				NativeProcessUtils.errorHandlerFunction(onSavingError), NativeProcessUtils.outputHandlerFunction(onSavingError), onAudioDoneHandler);
		}
		private var curTime:Number=0;
		/**
		 * @private 
		 * Output data handler for the startSaving method
		 */
		public function onSavingError(s:String):void
		{
			trace(s);
			var errDataArr:Array=s.split('\\n');
			
			var errDataLast:String=errDataArr[errDataArr.length-1];
			var durMatches:Array=errDataLast.match(/time=([0-9]+):([0-9]+):([0-9]+).([0-9]+)/);
			if(durMatches!=null&&durMatches.length==5)
			{
				var duration:Number=(parseFloat(durMatches[1])*60+parseFloat(durMatches[2]))*60+parseFloat(durMatches[3])+parseFloat(durMatches[4])/100;
				if(curTime<duration)
				{
					curTime=duration;
					dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,curTime,settings.duration));
				}
			}
			
		}
		/**
		 * @private 
		 * Exit handler for the startMontage method
		 */
		public function onAudioDoneHandler(event:NativeProcessExitEvent):void
		{			
			dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,"done processing video, see result at " + settings.outPath +", took "+(getTimer()-noteTime)+"ms"));

		}
	}
}