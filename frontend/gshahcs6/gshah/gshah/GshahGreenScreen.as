package gshah
{
	import flash.display.MovieClip;
	import gshah.utils.FfmpegVideoUtils;
	import gshah.utils.NativeProcessUtils;
	import fl.data.DataProvider;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.ServerSocket;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.desktop.NativeProcess;
	import flash.display.Loader;
	import fl.controls.ComboBox;
	import gshah.utils.GshahUtils;
	import gshah.events.GshahEvent;
	
	public class GshahGreenScreen extends MovieClip
	{
		/**
		 * Instance of <code>gshah.GshahSettings</code> with all necessary properties about output video stream
		 */		
		[Bindable]
		public var settings:GshahSettings;

		[Bindable]
		/**
		 * Inputs with layer=0 
		 */
		public var videoTracks:DataProvider;
		private var index:int;
		private var previewBitmap:Bitmap;
		public var colorBox:ComboBox;
		private var calcColors:Boolean;
		
		private var helper:GshahUtils;
		
		public function GshahGreenScreen()
		{
			settings=new GshahSettings;
			helper=new GshahUtils;
			
			previewBitmap=new Bitmap;
			colorBox=new ComboBox;
			addChild(colorBox);
			colorBox.addEventListener(Event.CHANGE,onDropDownChange);
			previewBitmap.y=40;
			addChild(previewBitmap);
		}
		protected function onDropDownChange(event:Event):void
		{
			getGreenScreen(index, false);
		}
		public function getGreenScreen(index:int,calcColors:Boolean=true):void
		{
			this.index=index;
			this.calcColors=calcColors;
			if(videoTracks.getItemAt(index).source.hasOwnProperty('@shortPath'))
			{
				helper.addEventListener(GshahEvent.GSHAH_COMPLETE,startGreenScreen);
				helper.checkFilesExist(checkFiles);
			}
			else
			{
				preparePathes();
			}
			
		}
		
				/**
		 * @private 
		 * Starts conversion pathes from standart to short
		 */		
		private function preparePathes(event:Event=null):void
		{
			var sfnCmdContent:String=FfmpegVideoUtils.SFN_CMD_CONTENT;
			var videoPaths:Array=[videoTracks.getItemAt(index).source.toString()];
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
				videoTracks.getItemAt(index).source.@shortPath=outArr[2];
			}
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,startGreenScreen);
			helper.checkFilesExist(checkFiles);
			
			
		}
		private var checkFiles:Array=[{o:false, f:FfmpegVideoUtils.FFMPEG_LOCATION,r:FfmpegVideoUtils.FFMPEG_RESOURCE},
									  {o:true, f:FfmpegVideoUtils.GREENSCREEN_EXE_LOCATION,r:FfmpegVideoUtils.GREENSCREEN_RESOURCE}];
		

		/**
		 * Cuts video using settings in tr XML 
		 * @param tr is XML with settings about track
		 * 
		 */
		private function cutVideo(tr:XML):void
		{
			var tcpPort:int=helper.getNextPortNumber();
			var cutParams:Array=[
				FfmpegVideoUtils.COMMAND_INPUT,tr.source.@shortPath.toString(),
				FfmpegVideoUtils.COMMAND_RESOLUTION, [tr.@width.toString(),tr.@height.toString()].join('x'),
				FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_SOUND, 
				FfmpegVideoUtils.COMMAND_FRAMERATE, settings.tbr,
				FfmpegVideoUtils.COMMAND_FORMAT, FfmpegVideoUtils.FORMAT_RAWVIDEO,
				FfmpegVideoUtils.COMMAND_CUT_START, FfmpegVideoUtils.convertTime(tr.cue.startpos),
				FfmpegVideoUtils.COMMAND_VIDEO_FRAMES,1,
				//FfmpegVideoUtils.COMMAND_CUT_END,FfmpegVideoUtils.convertTime(tr.cue.endpos),
				'"tcp://127.0.0.1:'+tcpPort.toString()+'?listen=1&listen_timeout='+FfmpegVideoUtils.TCP_TIMEOUT.toString()+'"'
			];
			tr.source.@tcpPort=tcpPort;
			
			helper.writeUTFFileAndLunch(File.applicationStorageDirectory.resolvePath("ffmpegLib/cut_"+tcpPort.toString()+".cmd"),'ffmpeg '+cutParams.join(' '));
			
		}
		
		private var previewSource:ByteArray;
		
		private function startGreenScreen(event:GshahEvent=null):void
		{
			var videoTrack:XML=videoTracks.getItemAt(index) as XML;
			cutVideo(videoTrack);
			previewSource=new ByteArray;
			greenColorBuffer="";
			var montageParams:Array=[calcColors?"1":"-1",int(videoTrack.@width.toString()),int(videoTrack.@height.toString()),videoTrack.source.@tcpPort];
			if(!calcColors)
			{
				montageParams.push(colorBox.selectedItem.u,colorBox.selectedItem.v);
			}
			trace('greenScreen.exe '+montageParams.join(' '));
			
			NativeProcessUtils.runNativeProcess(FfmpegVideoUtils.GREENSCREEN_EXE_LOCATION,montageParams, NativeProcessUtils.errorHandlerFunction(onGreenScreenError), onGreenScreenOutput,onGreenScreenExit);


		}
			
		
		/**
		 * @private 
		 * Handler for the startGreenScreen method
		 */
		private function onGreenScreenExit(event:NativeProcessExitEvent):void
		{
			var videoTrack:XML=videoTracks.getItemAt(index) as XML;
			previewSource.position=0;
			trace("previewSource.bytesAvailable"+previewSource.bytesAvailable);
			var newBmd:BitmapData = new BitmapData(int(videoTrack.@width.toString()),int(videoTrack.@height.toString()));
		   	newBmd.setPixels(new Rectangle(0,0,int(videoTrack.@width.toString()),int(videoTrack.@height.toString())), previewSource);
			previewBitmap.bitmapData=newBmd;
			
			if(calcColors)
			{
				colorBox.dataProvider=new DataProvider();
				trace(greenColorBuffer);
				var gscolors:Array=greenColorBuffer.split("\n");
				for each (var gsc:String in gscolors) 
				{
					var exist:Boolean=false;
					for each (var obj:Object in colorBox.dataProvider.toArray()) 
					{
						if(obj.label==gsc)
						{
							exist=true;
							break;
						}
					}
					if(!exist&&gsc!='')
					{
						var gsMatches:Array=gsc.match(/\(u=([0-9]+) v=([0-9]+)\)/);
						colorBox.dataProvider.addItem({label:gsc, u:gsMatches[1], v:gsMatches[2]});
					}
					
				}
			}
			
		}
		

		private var greenColorBuffer:String;
		
		/**
		 * @private 
		 * Handler for a process output
		 */
		private function onGreenScreenError(s:String):void
		{
			greenColorBuffer+=s;
			//trace(s);
		}	
		/**
		 * @private 
		 * Handler for a process output
		 */
		private function onGreenScreenOutput(event:ProgressEvent):void
		{
			var _process:NativeProcess=event.target as NativeProcess;
			if (_process.running)
			{
				var ba:int=_process.standardOutput.bytesAvailable;
				if (ba > 0) 
				{
					var outputBytes:ByteArray = new ByteArray();
					_process.standardOutput.readBytes(outputBytes);
					outputBytes.position=0;
					previewSource.writeBytes(outputBytes);
				}
				
			}
		}	
	}
}