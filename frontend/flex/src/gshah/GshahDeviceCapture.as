package gshah
{
	import flash.desktop.NativeProcess;
	import flash.display.BitmapData;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import gshah.events.GshahEvent;
	import gshah.utils.FfmpegVideoUtils;
	import gshah.utils.GshahUtils;
	import gshah.utils.NativeProcessUtils;
	
	import sys.SystemSettings;
	
	
	public class GshahDeviceCapture extends GshahAbstractService
	{
		
		public static const DEFAULT_WIDTH:Number=640;
		public static const DEFAULT_HEIGHT:Number=480;
		
		public static const RECORDING_DELAY:Number=3000;
		
		[Bindable]
		public static var micVolume:Number=100;
		
		public function GshahDeviceCapture()
		{
			
		}
		private var withAudio:Boolean;
		private var withVideo:Boolean;
		private var videoDevice:Camera;
		private var captureVideo:Video;
		private var soundDevice:Microphone;
		private var nullBa:ByteArray;
		
		private var length:int=int.MAX_VALUE;
		
		public function startRecording(fileNameWithFullPath:String,videoDeviceIndex:int, soundDeviceIndex:int, captureVideo:Video):void
		{
			audioDuration=0;
			helper=new GshahUtils;
			running=true;
			settings=new GshahSettings;
			settings.outPath=fileNameWithFullPath;
			settings.tbr=24;
			nullBa=new ByteArray;
			for (var i:int = 0; i < settings.audioRate/settings.tbr; i++) 
			{
				nullBa.writeShort(0);
			}
			//nullBa.length=44100/24*2;
			if(videoDeviceIndex!=-1)
			{
				videoDevice=Camera.getCamera(videoDeviceIndex.toString());
				videoDevice.setMode(DEFAULT_WIDTH,DEFAULT_HEIGHT,settings.tbr,true);
				this.captureVideo=captureVideo;
				this.captureVideo.attachCamera(videoDevice);
				withVideo=true;
			}
			else
			{
				withVideo=false;
			}
			if(soundDeviceIndex!=-1)
			{
				soundDevice=Microphone.getMicrophone(soundDeviceIndex);
				soundDevice.enableVAD=false;
				soundDevice.setSilenceLevel(0,int.MAX_VALUE);
				soundDevice.gain=100;
				soundDevice.rate=44;
				soundDevice.setUseEchoSuppression(true);
				withAudio=true;
			}
			else
			{
				withAudio=false;
			}
			
			isCancel=false;
			isWhiteScreen=withVideo;
			audioStarted=!withAudio;
			isFirstAudio=true;
			isFirstVideo=true;
			checkOutFile();
			length=int.MAX_VALUE;
			curFrame=0;
		}
		private var isCancel:Boolean;
		public function finishRecording():void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,50,100));
			length=getTimer()-startTime;
			
		}
		public function cancelRecording():void
		{
			isCancel=true;
			stopProcess();
		}
		
		private function stopProcess():void
		{
			
			if(withAudio)
			{
				soundDevice.removeEventListener(SampleDataEvent.SAMPLE_DATA, soundDevice_sampleDataHandler);
				if(withVideo&&audioSocket!=null&&audioSocket.connected)
				{
					audioSocket.close();
					
				}
			}
			if(withVideo)
			{
				if(!withAudio)
				{
					captureVideo.removeEventListener(Event.ENTER_FRAME, captureVideo_enterFrameHandler);
				}
				captureVideo.attachCamera(null);
				
			}
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,100,100));
			cameraCaptureProcess.closeInput();
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
			if(!SystemSettings.isMac)
			{				
				helper.addEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
				helper.getShortPathes([settings.outPath]);
			}
			else
			{
				startCapture();
			}
		}
		
		
		
		/**
		 * @private 
		 * Exit handler for the preparePathes method
		 */
		protected function onGetShortPathes(event:GshahEvent):void
		{
			helper.removeEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
			var outArr:Array=event.data.split("\r\n");
			if(outArr.length>=4)
			{
				settings.outPath=outArr[2];
			}
			startCapture();
			
			
		}
		
		
		
		[Bindable]
		private var cameraCaptureProcess:NativeProcess;
		
		private var audioOutTcpPort:int;
		
		private var audioSocket:Socket;
		private function onCamStatusActivity(e:Event):void
		{
			if ((e is ActivityEvent)||((e is StatusEvent) && (e as StatusEvent).code == "Camera.Unmuted")) // rem: this event can't be relied upon 
			{
				videoDevice.removeEventListener(StatusEvent.STATUS, onCamStatusActivity);
				videoDevice.removeEventListener(ActivityEvent.ACTIVITY, onCamStatusActivity);
				
				if(!withAudio)
				{
					captureVideo.addEventListener(Event.ENTER_FRAME, captureVideo_enterFrameHandler);
				}				
				if(withAudio)
				{
					soundDevice.addEventListener(SampleDataEvent.SAMPLE_DATA, soundDevice_sampleDataHandler);
					
				}
				
				dispatchEvent(new GshahEvent(GshahEvent.GSHAH_START));
				
			}			
		}
		private function startCapture():void
		{			
			audioOutTcpPort=helper.getNextPortNumber();
			ba=new ByteArray;
			
			var params:Array=[];
			if(withVideo)
			{
				params.push(FfmpegVideoUtils.COMMAND_CUT_START,FfmpegVideoUtils.convertTime(RECORDING_DELAY));
				
			}
			if(withVideo)
			{
				videoDevice.addEventListener(StatusEvent.STATUS, onCamStatusActivity);
				videoDevice.addEventListener(ActivityEvent.ACTIVITY, onCamStatusActivity);
				this.captureVideo.attachCamera(videoDevice);
			}
			if(withVideo)
			{
				params.push(
					
					FfmpegVideoUtils.COMMAND_FORMAT, FfmpegVideoUtils.FORMAT_RAWVIDEO, 
					FfmpegVideoUtils.COMMAND_FRAMERATE,settings.tbr,
					'-pix_fmt','argb',
					FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_SOUND,
					FfmpegVideoUtils.COMMAND_RESOLUTION, [videoDevice.width,videoDevice.height].join('x'),
					FfmpegVideoUtils.COMMAND_INPUT, '-');
			}
			if(withAudio)
			{
				params.push(
					FfmpegVideoUtils.COMMAND_AUDIO_RATE, settings.audioRate,
					FfmpegVideoUtils.COMMAND_AUDIO_CHANELS, '1',
					FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_VIDEO, 
					FfmpegVideoUtils.COMMAND_AUDIO_CODEC, 'pcm_f32be',
					FfmpegVideoUtils.COMMAND_FORMAT, 'f32be');
				
				if(withVideo)
				{
					params.push(FfmpegVideoUtils.COMMAND_INPUT, '"tcp://127.0.0.1:'+audioOutTcpPort+'?listen=1&listen_timeout=100000"')
					
				}
				else
				{
					params.push(FfmpegVideoUtils.COMMAND_INPUT, '-');
					
					
				}
			}
			if(withVideo&&withAudio)
			{
				params.push('-map 0:v:0 -map 1:a:0 -shortest');
			}
			if(withVideo)
			{
				params.push(FfmpegVideoUtils.COMMAND_VIDEO_BITRATE, '1M',
					'-g 10');
			}
			else
			{
				params.push(FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_VIDEO);
			}
			
			if(withAudio)
			{
				params.push(
					FfmpegVideoUtils.COMMAND_AUDIO_BITRATE, settings.audioBitrate,
					FfmpegVideoUtils.COMMAND_AUDIO_CHANELS, settings.audioChanels,
					FfmpegVideoUtils.COMMAND_AUDIO_RATE, settings.audioRate);
				if(micVolume<100)
				{
					params.push('-af','"volume='+(micVolume/100)+'"');
				}
				
			}
			else
			{
				params.push(FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_SOUND);
			}
			params.push(settings.outPath, 
				FfmpegVideoUtils.COMMAND_REWRITE);
			cameraCaptureProcess=helper.writeAndLunch(
				SystemSettings.getBinPath()+' '+params.join(' '),
				onVideoDoneReadHandler,NativeProcessUtils.errorHandlerFunction(onDeviceInput));
			if(withAudio)
			{
				startTime=getTimer();
				audioTime=(new Date).time;
				soundDevice.addEventListener(SampleDataEvent.SAMPLE_DATA, soundDevice_sampleDataHandler);
				
			}
		}
		public var audioTime:Number;
		
		private var audioStarted:Boolean;
		private var sum:int=0;
		private var ba:ByteArray;
		
		public var audioDuration:Number=0;
		
		protected function soundDevice_sampleDataHandler(event:SampleDataEvent):void
		{
			
			
			if(withVideo)
			{
				if(audioSocket!=null&&audioSocket.connected)
				{					
					ba.writeBytes(event.data);
				}
			}
			else
			{
				if(cameraCaptureProcess.running)
				{
					if(audioDuration>=length/1000)
					{
						setTimeout(stopProcess,1000);
						return;
					}
					audioDuration+=event.data.length/(settings.audioRate*4);
					cameraCaptureProcess.standardInput.writeBytes(event.data);
					
				}
			}
			
		}
		
		protected function onDeviceInput(s:String):void
		{
			
			helper.log(s);
			if(isFirstVideo)
			{
				isFirstVideo=false;
				dispatchEvent(new GshahEvent(GshahEvent.GSHAH_START));
				if(withAudio)
				{
					if(withVideo)
					{
						writeVideoBitmapData(getVideoBitmapData());
						connectSocket();
					}
					
				}
			}
		}
		protected function connectSocket(e:IOErrorEvent=null):void
		{
			
			audioSocket=new Socket('127.0.0.1',audioOutTcpPort);
			audioSocket.addEventListener(Event.CONNECT, onSocketConnected);
			audioSocket.addEventListener(IOErrorEvent.IO_ERROR, connectSocket);
			
		}
		
		protected function onSocketConnected(event:Event):void
		{
			if(withAudio)
			{
				captureVideo.addEventListener(Event.ENTER_FRAME, captureVideo_enterFrameHandler);
				
			}
		}
		
		/**
		 * @private 
		 * Exit handler for the startMontage method
		 */
		public function onVideoDoneReadHandler(event:NativeProcessExitEvent):void
		{	
			running=false;
			if(isCancel)
			{
				
			}
			else
			{
				trace("done processing video, see result at " + settings.outPath);
				dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,settings.outPath));			
			}
			
			
		}
		private var isFirstVideo:Boolean=true;
		private var isFirstAudio:Boolean=true;
		private var isWhiteScreen:Boolean;
		
		private var curFrame:int=0;
		public var startTime:Number;
		
		protected function captureVideo_enterFrameHandler(event:Event):void
		{
			if(curFrame>length*settings.tbr/1000)
			{
				setTimeout(stopProcess,1000);
			}
			else if(running&&cameraCaptureProcess.running&&(!withAudio||audioSocket.connected))
			{
				
				if(isFirstAudio)
				{
					isFirstAudio=false;
					startTime=getTimer();
				}
				
				if(withAudio)
				{
					if (ba.length>=settings.audioRate/settings.tbr*4)
					{
						ba.position=0;
						audioSocket.writeBytes(ba,0,settings.audioRate/settings.tbr*4);
						audioSocket.flush();
						var _ba:ByteArray=new ByteArray;
						ba.position=0;
						_ba.writeBytes(ba,settings.audioRate/settings.tbr*4);
						ba=_ba;
					}
					else
					{
						return;
						trace('nullBa');
						nullBa.position=0;
						audioSocket.writeBytes(nullBa,0,settings.audioRate/settings.tbr*4);
						audioSocket.flush();
					}
					
				}
				curFrame++;
				
				writeVideoBitmapData(getVideoBitmapData());
				
			}
		}
		
		private function getVideoBitmapData():BitmapData
		{
			var frameBitmapData:BitmapData=new BitmapData(captureVideo.width,captureVideo.height);
			
			var m:Matrix=new Matrix;
			m.scale(captureVideo.scaleX,captureVideo.scaleY);
			frameBitmapData.draw(captureVideo,m);
			return frameBitmapData;
		}
		
		private var isF:Boolean=true;
		
		private function writeVideoBitmapData(frameBitmapData:BitmapData):void
		{
			var pixels:ByteArray=frameBitmapData.getPixels(new Rectangle(0,0,frameBitmapData.width,frameBitmapData.height));
			cameraCaptureProcess.standardInput.writeBytes(pixels);
			
		}
	}
}