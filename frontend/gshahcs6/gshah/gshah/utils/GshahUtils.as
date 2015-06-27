package gshah.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.events.EventDispatcher;
	import gshah.events.GshahEvent;
	import flash.net.ServerSocket;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	/**
	 *  The GshahUtils class helps you with some gshah methods
	 */
	public class GshahUtils extends EventDispatcher
	{
		private var nativeAlert:NativeAlert = new NativeAlert();
		private var logArray:Array=[]

		public function createEmptyFile(f:File):void
		{
			var fs:FileStream=new FileStream;
			fs.addEventListener(Event.CLOSE,fsCloseHandler);
			fs.addEventListener(IOErrorEvent.IO_ERROR,fsIOErrorHandler);
			fs.openAsync(f,FileMode.WRITE);
			fs.writeUTFBytes('');
			fs.close();
		}
		/**
		 * @private 
		 * Event handler for any <code>flash.events.Event.CLOSE</code> in the class
		 */
		protected function fsCloseHandler(event:IOErrorEvent=null):void
		{
			dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE));
		}
		/**
		 * @private 
		 * Event handler for any <code>flash.events.IOErrorEvent</code> in the class
		 */
		protected function fsIOErrorHandler(event:IOErrorEvent=null):void
		{
			nativeAlert.alert("Input/output error! Check your files' location and security settings.");
		}
		
		public function getShortPathes(a:Array):void
		{
			var sfnCmdContent:String=FfmpegVideoUtils.SFN_CMD_CONTENT;
			sfnCmdContent=sfnCmdContent.replace('$$1', '"'+a.join('", "')+'"');
			
			var sfnCmdLocation:File=File.applicationStorageDirectory.resolvePath("ffmpegLib/sfn.cmd");
			
			var outStream:FileStream=new FileStream;
			outStream.addEventListener(Event.CLOSE, outStreamCloseHandler);
			outStream.addEventListener(IOErrorEvent.IO_ERROR,fsIOErrorHandler);
			outStream.openAsync(sfnCmdLocation,FileMode.WRITE);
			outStream.writeUTFBytes(sfnCmdContent);
			outStream.close();
		}
		
		/**
		 * @private 
		 * Event handler for the getShortPathes method
		 */
		protected function outStreamCloseHandler(event:Event):void
		{
			stringBuffer='';
			var sfnCmdLocation:File=File.applicationStorageDirectory.resolvePath("ffmpegLib/sfn.cmd");
			NativeProcessUtils.runNativeProcess(sfnCmdLocation,[], null, 
				NativeProcessUtils.outputHandlerFunction(onProcessOutput),onProcessExit);
		}
		/**
		 * @private 
		 * Storage for the path conversion process
		 */
		private var stringBuffer:String;
		
		/**
		 * @private 
		 * Data handler for the outStreamCloseHandler method
		 */
		private function onProcessOutput(s:String):void
		{
			stringBuffer+=s;
			
		}
		
		/**
		 * @private 
		 * Exit handler for the fsCloseHandler method
		 */
		protected function onProcessExit(event:NativeProcessExitEvent):void
		{
			dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,stringBuffer));
		}
		
		/**
		 * @private
		 * Gets video parameters for the input tracks
		 */
		public function getTracksParams(a:Array):void
		{
			stringBuffer='';
			var ffmpegParams:Array=[];
			for each (var path:String in a) 
			{
				ffmpegParams.push(FfmpegVideoUtils.COMMAND_INPUT);
				ffmpegParams.push(path);
			}
			NativeProcessUtils.runNativeProcess(FfmpegVideoUtils.FFMPEG_LOCATION, ffmpegParams, 
				NativeProcessUtils.errorHandlerFunction(onProcessOutput), null, onProcessExit)
			
		}
		/**
		 * makes int even
		 */	
		public function toEven(num:int):int
		{
			return Math.round(num/2)*2;
		}
		/**
		 * Last used port in session
		 */	
		public static var currentPort:int=1023;
		/**
		 * @private
		 * Use this function when you have to stop the montage because of error
		 * 
		 */
		public function getNextPortNumber():int
		{
			currentPort++;
			var ss:ServerSocket=new ServerSocket();
			try
			{
				ss.bind(currentPort, '127.0.0.1');
			} 
			catch(error:Error) 
			{
				return getNextPortNumber();
			} 
			ss.close();
			
			return currentPort;
		}

		public function writeUTFFileAndLunch(f:File,s:String):void
		{
			writeUTFFile(f,s);
			NativeProcessUtils.runNativeProcess(f,[], NativeProcessUtils.errorHandlerFunction(onFileProcessOutput), NativeProcessUtils.outputHandlerFunction(onFileProcessOutput),null);
			
		}
		
		/**
		 * @private 
		 * Handler for a process output
		 */
		private function onFileProcessOutput(s:String):void
		{
			log(s);
		}
		
		public function writeUTFFile(f:File,s:String):void
		{
			var outStream:FileStream=new FileStream;
			outStream.addEventListener(IOErrorEvent.IO_ERROR,fsIOErrorHandler);
			outStream.open(f,FileMode.WRITE);
			outStream.writeUTFBytes(s);
			outStream.close();
			log(s);
			
		}
		
		public function log(...params):void
		{
			for each(var s:String in params)
			{
				trace(s);
				logArray.push(s);
			}
			
		}
		
		public function saveLog(outPath:String):void
		{
			var logFile:File=(new File(outPath)).parent.resolvePath('gshah.log');
			var logStream:FileStream=new FileStream;
			var logString:String='';
/*			if(logFile.exists)
			{
				logStream.open(logFile, FileMode.READ);
				logString=logStream.readUTF();
				logStream.close();
				logStream=new FileStream;
			}*/
			logString+=logArray.join('\n');
			logStream.openAsync(logFile, FileMode.WRITE);
			logStream.writeUTF(logString.substr(0,Math.min(65535,logString.length-1)));
			logStream.close();
		}
		
		[Bindable]
		private var checkFiles:Array=[{o:false, f:FfmpegVideoUtils.FFMPEG_LOCATION,r:FfmpegVideoUtils.FFMPEG_RESOURCE},
			{o:true, f:FfmpegVideoUtils.SOUNDMONTAGE_EXE_LOCATION, r:FfmpegVideoUtils.SOUNDMONTAGE_RESOURCE},
				{o:true, f:FfmpegVideoUtils.MONTAGE_EXE_LOCATION, r:FfmpegVideoUtils.MONTAGE_RESOURCE}];
				
		/**
		 * @private 
		 * Checks if all montage files exist and continue process 
		 */
		public function checkFilesExist(files:Array=null):void
		{
			if(files!=null)
			{
				checkFiles=files;
			}
			
			for each (var cf:Object in checkFiles) 
			{
				var f:File=cf.f as File;
				var r:String=cf.r as String;
				if(cf.o||!f.exists)
				{
					cf.o=false;
					var bl:URLLoader=new URLLoader;
					bl.dataFormat = URLLoaderDataFormat.BINARY;
					bl.addEventListener(IOErrorEvent.IO_ERROR, bfsIOErrorHandler);
					bl.addEventListener(Event.COMPLETE, function(event:Event):void
					{
						var bfs:FileStream=new FileStream;
						bfs.addEventListener(Event.CLOSE,bfsCloseHandler);
						bfs.addEventListener(IOErrorEvent.IO_ERROR,bfsIOErrorHandler);
						bfs.openAsync(f,FileMode.WRITE);
						bfs.writeBytes(bl.data,0,bl.bytesLoaded);
						bfs.close();
					});
					bl.load(new URLRequest(r));
					return;
				}
			}
			dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE));
		}
		/**
		 * @private 
		 * <code>flash.events.IOErrorEvent.IO_ERROR</code> handler for the checkFilesExistAndLaunch method
		 */
		protected function bfsIOErrorHandler(event:IOErrorEvent):void
		{
			nativeAlert.alert("Input/outpur error! Can't write files to application storage directory.");
		}
		/**
		 * @private 
		 * <code>flash.events.Event.CLOSE</code> handler for the checkFilesExistAndLaunch method
		 */
		protected function bfsCloseHandler(event:Event):void
		{
			checkFilesExist();
		}
	}
}