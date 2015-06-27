package gshah.utils
{
	import flash.desktop.NativeProcess;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.ServerSocket;
	import flash.utils.ByteArray;
	
	import application.view.popups.GlamourAlert;
	
	import gshah.events.GshahEvent;
	
	import sys.SystemSettings;
	
	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	/**
	 *  The GshahUtils class helps you with some gshah methods
	 */
	public class GshahUtils extends EventDispatcher
	{
		private static var logArray:Array=[]
		
		
		
		
		public function createEmptyFile(f:File):void
		{
			var fs:FileStream=new FileStream;
			fs.addEventListener(Event.CLOSE,createEmptyFile_closeHandler);
			fs.addEventListener(IOErrorEvent.IO_ERROR,createEmptyFile_ioErrorHandler);
			fs.openAsync(f,FileMode.WRITE);
			fs.writeUTFBytes('');
			fs.close();
		}
		/**
		 * @private 
		 * Event handler for any <code>flash.events.Event.CLOSE</code> in the class
		 */
		protected function createEmptyFile_closeHandler(event:Event=null):void
		{
			dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE));
		}
		/**
		 * @private 
		 * Event handler for any <code>flash.events.IOErrorEvent</code> in the class
		 */
		protected function createEmptyFile_ioErrorHandler(event:IOErrorEvent=null):void
		{
			GlamourAlert.show("Input/output error! Check your files' location and security settings.");
		}
		
		
		
		private var getShortPathesBuffer:String;

		public function getShortPathes(a:Array):void
		{
			getShortPathesBuffer='';
			var sfnCmdContent:String=FfmpegVideoUtils.SFN_CMD_CONTENT;
			sfnCmdContent=sfnCmdContent.replace('$$1', '"'+a.join('", "')+'"');
			writeAndLunch(sfnCmdContent,onShortPathesProcessExit,null,NativeProcessUtils.outputHandlerFunction(onShortPathesProcessOutput));
		}
		
		private function onShortPathesProcessOutput(s:String):void
		{
			getShortPathesBuffer+=s;
			
		}
		protected function onShortPathesProcessExit(event:NativeProcessExitEvent):void
		{
			dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,getShortPathesBuffer));
		}
		
		
		
		/**
		 * makes int even
		 */	
		public function toEven(num:int):int
		{
			return Math.floor(num/2)*2;
		}
		
		public function toNumber(xml:*):Number
		{
			return parseFloat(xml.toString());
		}
		
		public function toInt(xml:*):int
		{
			return parseInt(xml.toString());
		}
		/**
		 * Last used port in session
		 */	
		public static var currentPort:int;
		/**
		 * @private
		 * Use this function when you have to stop the montage because of error
		 * 
		 */
		public function getNextPortNumber():int
		{
			currentPort=1024+int(Math.random()*(65535-1023));
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
		
		
		public function writeAndLunch(s:String,exitHandler:Function=null,errorHandler:Function=null,outputHandler:Function=null):NativeProcess
		{
			if(errorHandler==null)
			{
				errorHandler=NativeProcessUtils.errorHandlerFunction(writeAndLunch_processOutputHandler);
			}
			var f:File=SystemSettings.newTempFile();
			writeUTFFile(f,s);
			return NativeProcessUtils.runNativeProcess(f,[], errorHandler, outputHandler,exitHandler);
			
		}
		/**
		 * @private 
		 * Handler for a process output
		 */
		private function writeAndLunch_processOutputHandler(s:String):void
		{
			log(s);
		}
		
		private function writeUTFFile(f:File,s:String):void
		{
			var outStream:FileStream=new FileStream;
			outStream.addEventListener(IOErrorEvent.IO_ERROR,createEmptyFile_ioErrorHandler);
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
			var oldLog:File=File.desktopDirectory.resolvePath('gshah.log');
			if(oldLog.exists)
			{
				oldLog.deleteFile();
			}
			var logFile:File=File.desktopDirectory.resolvePath('vmp.log');
			var logStream:FileStream=new FileStream;
			var logString:String=logArray.join('\n');
			/*if(logFile.exists)
			{
				logStream.openAsync(logFile, FileMode.APPEND);
			}
			else
			{*/
				logStream.openAsync(logFile, FileMode.WRITE);
			/*}*/
			var ba:ByteArray=new ByteArray;
			ba.writeUTFBytes(logString);
			logStream.writeBytes(ba);
			logStream.close();
		}
		
		
		/**
		 * @private 
		 * Storage for output data
		 */		
		private var getVideoSettingsBuffer:String='';
		
		
		/**
		 * Uses ffmpeg to determine input video parameters and delivers 
		 * the result within <code>gshah.GshahSettings</code> to the callback function
		 * @param path is a native path of target video file
		 * @param callBack must be <code>function(gshahSettings:GshahSettings):void</code>
		 * 
		 */
		public function getVideoSettings(path:String, callBack:Function):void
		{
			getVideoSettingsBuffer='';
			var onPathReady:Function=function(event:GshahEvent=null):void
			{
				if(event!=null)
				{
					event.target.removeEventListener(GshahEvent.GSHAH_COMPLETE,onPathReady);
					path=event.data.split('\n')[2];
				}
				writeAndLunch([SystemSettings.getBinPath(),FfmpegVideoUtils.COMMAND_INPUT,'"'+path+'"'].join(' '),
					function (event:NativeProcessExitEvent):void
					{
						if(callBack!=null)
						{
							callBack(FfmpegVideoUtils.parseVideoParams(getVideoSettingsBuffer));
						}
					},
					NativeProcessUtils.errorHandlerFunction(
						function(data:String):void
						{
							getVideoSettingsBuffer +=data;	
						}
					));	
			}
			if(!SystemSettings.isMac)
			{
				var h:GshahUtils=new GshahUtils;
				h.addEventListener(GshahEvent.GSHAH_COMPLETE,onPathReady);
				h.getShortPathes([path]);
			}
			else
			{
				onPathReady();
			}
		}
	}
}