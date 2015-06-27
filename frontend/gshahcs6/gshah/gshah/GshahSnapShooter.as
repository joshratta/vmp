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
	import flash.display.Loader;
	
	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	[Event(name="gshahError", type="gshah.events.GshahErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class GshahSnapShooter extends EventDispatcher
	{
		/**
		 * Instance of <code>gshah.GshahSettings</code> with all necessary properties about output video stream
		 */		
		[Bindable]
		public var settings:GshahSettings;
		
		private var inPath:String;
		
		private var helper:GshahUtils;
		
		private var snapShoots:Array;
		
		public var running:Boolean;
		
		public function GshahSnapShooter()
		{
			
		}
		private var startTime:int=-1;
		private var endTime:int=-1;
		private var intervalTime:int=1;
		private var framesCount:int=-1;
		private var indexesToLoad:Array;
		private var indexesToSave:Array;
		public function startSnapShoot(inPath:String,interval:int=1000,start:int=0,end:int=-1,width:int=-1,height:int=-1):void
		{
			helper=new GshahUtils;
			settings=new GshahSettings;
			snapShoots=[];
			indexesToLoad=[];
			indexesToSave=[];
			settings.outPath=File.createTempDirectory().nativePath;
			settings.resX=width;
			settings.resY=height;
			startTime=start;
			endTime=end;
			intervalTime=interval;
			this.inPath=inPath;
			curFrame=0;
			running=true;
			preparePathes();
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
			settings.totalFrames=s.totalFrames;
			settings.tbr=s.tbr;
			framesCount=(settings.totalFrames*1000/settings.tbr);
			if(settings.resX>0&&settings.resY<=0)
			{
				settings.resY=s.resY*settings.resX/s.resX;
			}
			else if(settings.resY>0&&settings.resX<=0)
			{
				settings.resX=s.resX*settings.resY/s.resY;
			}
			if(startTime>0)
			{
				framesCount-=startTime;
			}
			if(endTime>0)
			{
				framesCount=endTime-startTime;
			}
			framesCount=int(framesCount/intervalTime)+1;
			for(var i:int=1;i<=framesCount;i++)
			{
				indexesToLoad.push(i);
				indexesToSave.push(i);
			}

			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,extractSnapShoot);
			helper.checkFilesExist(checkFiles);
		}
		private var checkFiles:Array=[{o:false, f:FfmpegVideoUtils.FFMPEG_LOCATION,r:FfmpegVideoUtils.FFMPEG_RESOURCE}];

		
		private var noteTime:int;
		
		private function extractSnapShoot(event:GshahEvent=null):void
		{
			var params:Array=[];
			if(startTime>0)
			{
				params.push(FfmpegVideoUtils.COMMAND_CUT_START, FfmpegVideoUtils.convertTime(startTime));
			}
			if(endTime>0)
			{
				params.push(FfmpegVideoUtils.COMMAND_CUT_END,FfmpegVideoUtils.convertTime(endTime-startTime));
			}
			params.push(FfmpegVideoUtils.COMMAND_INPUT,inPath);
			if(settings.resX>0&&settings.resY>0)
			{
				params.push(FfmpegVideoUtils.COMMAND_RESOLUTION, [settings.resX,settings.resY].join('x'));
			}
			params.push(FfmpegVideoUtils.COMMAND_FORMAT, 'image2',
						'-vf',"fps=fps="+(1000/intervalTime),
						settings.outPath+File.separator+"sh%d.png");
			
			trace(params.join(' '));
			
			noteTime=getTimer();
			
			NativeProcessUtils.runNativeProcess(FfmpegVideoUtils.FFMPEG_LOCATION, params, 
				NativeProcessUtils.errorHandlerFunction(onSavingError), NativeProcessUtils.outputHandlerFunction(onSavingError), onSnapShootDoneHandler);
		}
		private var curFrame:int=0;
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
				curFrame=frameMatches[1];
				saveSnapShots();
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,curFrame,framesCount));

				
				
				
			}
			
		}
		private function saveSnapShots():void
		{
			for each(var i:int in indexesToLoad)
			{
				if(indexesToSave.indexOf(i)>-1&&indexesToLoad.indexOf(i)>-1&&(i<=curFrame&&snapShoots.length<i||snapShoots[i-1]==null))
				{
					var imageFile:File = new File(settings.outPath+File.separator+"sh"+i+".png");
					if(imageFile.exists)
					{
						indexesToLoad.splice(indexesToLoad.indexOf(i),1);
						var imageLoader:Loader = new Loader(); 
						var urlReq :URLRequest = new URLRequest(imageFile.url);
						imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImage);
						imageLoader.load(urlReq);
					}						
				}
				
			}
		}
		private function onLoadImage(e:Event):void
		{
			
			var j:int=e.target.url.match(/sh([0-9]+).png/)[1];
			if(indexesToSave.indexOf(j)>-1&&(snapShoots.length<j||snapShoots[j-1]==null))
			{
				snapShoots[j-1]=e.target.content.bitmapData;
				trace('done '+e.target.url);
				indexesToSave.splice(indexesToSave.indexOf(j),1);
				onSnapShootDoneHandler();
			}
			
			
		}
							
		/**
		 * @private 
		 * Exit handler for the startMontage method
		 */
		public function onSnapShootDoneHandler(event:NativeProcessExitEvent=null):void
		{			
			if(running)
			{
				if(indexesToLoad.length==0&&snapShoots.length==framesCount)
				{
					running=false;
					dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,snapShoots));
					trace("done processing video, see result at " + settings.outPath +", took "+(getTimer()-noteTime)+"ms")
					var tempFolder:File=new File(settings.outPath);
					tempFolder.deleteDirectory(true);
	
				}
				else
				{
					saveSnapShots();
				}
			}
			
			
		}
	}
}