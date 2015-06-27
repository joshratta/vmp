package gshah.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	/**
	 *  The NativeProcessUtils class is an all-static class 
	 *  with methods for working with <code>flash.desktop.NativeProcess</code>.
	 *  You do not create instances of NativeProcessUtils 
	 *  instead you simply call static methods.
	 */
	public class NativeProcessUtils
	{
		private static var runningProcesses:Array=[];
		/**
		 *  Returns event handler for <code>flash.events.ProgressEvent.STANDARD_ERROR_DATA</code>
		 *  and delivers string value of <code>flash.desktop.NativeProcess.standardError</code> 
		 *  bytes to the callback function
		 *
		 *  @param callBack  must be <code>function(s:String):void</code>
		 *
		 *  @return <code>function(event:ProgressEvent):void</code>
		 */
		public static function errorHandlerFunction(callBack:Function):Function
		{
			return function(event:ProgressEvent):void
			{
				var _process:NativeProcess=event.target as NativeProcess;
				if (_process.running)
				{
					var errorBytes:ByteArray = new ByteArray();
					if (_process.standardError.bytesAvailable > 0) 
					{
						_process.standardError.readBytes(errorBytes);
						errorBytes.position=0;
						if(callBack!=null)
						{
							callBack(errorBytes.toString());
						}
						
						
					}
					
				}
			}
		}
		
		/**
		 *  Returns event handler for <code>flash.events.ProgressEvent.STANDARD_OUTPUT_DATA</code>
		 *  and delivers string value of <code>flash.desktop.NativeProcess.standardOutput</code> 
		 *  bytes to the callback function
		 *
		 *  @param callBack  must be <code>function(s:String):void</code>
		 *
		 *  @return <code>function(event:ProgressEvent):void</code>
		 */
		public static function outputHandlerFunction(callBack:Function):Function
		{
			return function(event:ProgressEvent):void
			{
				var _process:NativeProcess=event.target as NativeProcess;
				if (_process.running)
				{
					var outputBytes:ByteArray = new ByteArray();
					if (_process.standardOutput.bytesAvailable > 0) 
					{
						_process.standardOutput.readBytes(outputBytes);
						outputBytes.position=0;
						if(callBack!=null)
						{
							callBack(outputBytes.toString());
							
						}
						
						
					}
					
				}
			}
		}
		
		/**
		 *  The runNativeProcess function creates <code>flash.desktop.NativeProcess</code> 
		 *  for selected file and arguments and runs it with specified event handlers
		 *
		 *  @param executable File to run with <code>flash.desktop.NativeProcess</code>
		 *  @param args Array to push in <code>flash.desktop.NativeProcessStartupInfo</code>
		 * 	@param errorHandler is an event handler for <code>flash.events.ProgressEvent.STANDARD_ERROR_DATA</code>
		 *  @param errorHandler is an event handler for <code>flash.events.ProgressEvent.STANDARD_OUTPUT_DATA</code>
		 * 	@param exitHandler is an event handler for <code>flash.events.NativeProcessExitEvent.EXIT</code>
		 */
		public static function runNativeProcess(executable:File, args:Array, errorHandler:Function, outputHandler:Function, exitHandler:Function):void
		{
			var nativeAlert:NativeAlert = new NativeAlert();
			if(!NativeProcess.isSupported)
			{
				nativeAlert.alert('NativeProcess is not supported!');
				return;
			}
			if(!executable.exists)
			{
				nativeAlert.alert('File: "'+executable.nativePath+'" does not exist!');
				return;
			}
			//Load bytes by Native process
			var _nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			
			_nativeProcessStartupInfo.executable = executable;
			
			
			//Set up the process arguments
			var _processArgs:Vector.<String> = new Vector.<String>();
			for each (var arg:String in args) 
			{
				_processArgs.push(arg);
			}
			
			
			
			_nativeProcessStartupInfo.arguments = _processArgs;
			_nativeProcessStartupInfo.workingDirectory = executable.parent;
			
			//create new native process
			var _process:NativeProcess = new NativeProcess();
			
			if(errorHandler!=null)
			{
				_process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, errorHandler);
			}
			if(outputHandler!=null)
			{
				_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, outputHandler);
			}	
			if(exitHandler!=null)
			{
				_process.addEventListener(NativeProcessExitEvent.EXIT, exitHandler);
			}
			_process.addEventListener(NativeProcessExitEvent.EXIT,onExitStatic);
			runningProcesses.push(_process);
			//start the process
			_process.start(_nativeProcessStartupInfo);
		}
		/**
		 * @private 
		 * Exit handler for the runNativeProcess method
		 */
		private static function onExitStatic(event:NativeProcessExitEvent):void
		{
			var _process:NativeProcess=event.target as NativeProcess;
			var ind:int=runningProcesses.indexOf(_process);
			if(ind!=-1)
			{
				runningProcesses.slice(ind,1);
			}
		}
		public static function stopAll():void
		{
			
			for each (var _process:NativeProcess in runningProcesses) 
			{
				if(_process.running)
				{
					_process.exit(true);
					_process=null;
				}
				
			}
			
			
			runningProcesses=[];
		}
	}
}