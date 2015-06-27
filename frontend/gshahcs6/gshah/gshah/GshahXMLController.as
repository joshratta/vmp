package gshah
{
	import flash.display.FrameLabel;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.ServerSocket;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	
	import gshah.errors.GshahError;
	import gshah.utils.FfmpegVideoUtils;
	import gshah.utils.NativeProcessUtils;
	import gshah.utils.GshahUtils;
	import gshah.events.GshahEvent;
	import gshah.events.GshahErrorEvent;

	import fl.data.DataProvider;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Socket;
	
	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	[Event(name="gshahError", type="gshah.events.GshahErrorEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	public class GshahXMLController extends EventDispatcher
	{		
		/**
		 * Instance of <code>gshah.GshahUIComponent</code> for working with animations
		 */	
		[Bindable]
		private var uiComponent:GshahUIComponent;
		
		/**
		 * Return <code>true</code> when an montage is processing.
		 * Use this property to enable/disable your settings' changing UI-elements.
		 */
		[Bindable]
		public var processing:Boolean;
		
		
		/**
		 * @private 
		 * Storage for the process starting time
		 */
		private var _timeStamp:Number;
		
		/**
		 * Instance of <code>gshah.GshahSettings</code> with all necessary properties about output video stream
		 */		
		[Bindable]
		public var settings:GshahSettings;
		
		private var helper:GshahUtils;
		
		public function GshahXMLController()
		{
		}	
		
		[Bindable]
		/**
		 * Instances of <code>gshah.IGshahAnimationController</code> containing all necessary overlays
		 */	
		public var animations:Array=[];
		
		/**
		 * @private
		 * Inputs with layer=0 
		 */
		private var videoTracks:DataProvider;
		
		/**
		 * @private
		 * Inputs with layer=1 
		 */
		[Bindable]
		private var animationTracks:DataProvider;
		
		/**
		 * @private
		 * Sound inputs\
		 */
		private var soundTracks:DataProvider;
		
		/**
		 * Local files' native pathes of inputs 
		 */
		private var videoPaths:Array;
		

		/**
		 * Prases inputXML, converts animations using  uiComponent and calls onComplete when montage done
		 * @param inputXML is XML with all inputs
		 * @param uiComponent is an instance of <code>gshah.GshahUIComponent</code> for working with animations
		 * @param onComplete is the for callback wheh the montage finishes
		 * 
		 */
		private var isPreviewMode:Boolean;
		public var netStream:NetStream;
		private var previewVideo:Video;
		private var previewScale:Number=1;
		
		public function startXML(inputXML:XML, uiComponent:GshahUIComponent, isPreviewMode:Boolean, previewVideo:Video, previewWidth:Number, previewHeight:Number):void
		{
			isReadyToSeek=false;
						
			curFrame=0;
			seekTime=0;
			
			this.isPreviewMode=isPreviewMode;
			
			this.uiComponent=uiComponent;
			
			_timeStamp = getTimer();
			
			processing = true;
			
			settings=new GshahSettings;
			helper=new GshahUtils;
			previewScale=1;
			
			if(isPreviewMode)
			{
				
				this.previewVideo=previewVideo;
				createNetStream();
				
				
				
			}
			
			var videos:XMLList=inputXML.video;
			if(videos!=null&&videos.length()>0)
			{
				for each (var video:XML in videos) 
				{
					settings.resX=helper.toEven(parseFloat(video.@width));
					settings.resY=helper.toEven(parseFloat(video.@height));
					settings.outPath=video.output.toString();
					settings.bgColor=parseInt(video.@bgColor.toString().substr(1),16)
					if(isPreviewMode&&previewWidth>1&&previewHeight>1)
					{
						previewScale=Math.floor(Math.min(helper.toEven(previewWidth)/settings.resX, helper.toEven(previewHeight)/settings.resY)*10)/10;
						trace("previewScale="+previewScale);
						previewVideo.width=settings.resX*previewScale;
						previewVideo.height=settings.resY*previewScale;
					}
					testVideoXML(video);
					break;
				}
				
			}
			else
			{
				return stopProcessing(GshahError.MONTAGE_XML_INVALID);
			}
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,prepareOverlays);
			helper.checkFilesExist(checkFiles);
			
		}
		
		/**
		 *Prepares all animations for montage 
		 * 
		 */
		private function prepareOverlays(event:GshahEvent=null):void
		{
			if(event!=null)
			{
				event.target.removeEventListener(GshahEvent.GSHAH_COMPLETE,prepareOverlays);
			}
			for each (var animationTrack:XML in animationTracks.toArray()) 
			{
				if(!animationTrack.hasOwnProperty('source'))
				{
					if(animationTrack.hasOwnProperty('animation'))
					{
						var overlay:IGshahAnimationController=animations[animationTrack.animation.@id] as IGshahAnimationController
						uiComponent.overlay=overlay;
						animationTrack.@contentWidth=overlay.contentWidth;
						animationTrack.@contentHeight=overlay.contentHeight;
						var scale:Number=1;
						if(animationTrack.animation.hasOwnProperty('@scale'))
						{
							scale=animationTrack.animation.@scale;
						}
						else if(animationTrack.hasOwnProperty("@width")&&animationTrack.hasOwnProperty("@height"))
						{
							scale=Math.round(Math.min(helper.toEven(animationTrack.@width)/overlay.contentWidth,helper.toEven(animationTrack.@height)/overlay.contentHeight)*10)/10;
							if(animationTrack.@width/overlay.contentWidth>scale)
							{
								animationTrack.@x=(-scale*overlay.contentWidth+int(animationTrack.@width))/2+int(animationTrack.@x);
							}
							else if(animationTrack.@height/overlay.contentHeight>scale)
							{
								animationTrack.@y=(-scale*overlay.contentHeight+int(animationTrack.@height))/2+int(animationTrack.@y);
							}
						}
						
						animationTrack.animation.@scale=scale;
						if(animationTrack.animation.@scale*overlay.contentWidth+int(animationTrack.@x)>settings.resX||animationTrack.animation.@scale*overlay.contentHeight+int(animationTrack.@y)>settings.resY)
						{
							return stopProcessing(GshahError.MONTAGE_SCALE_INVALID);
						}
						uiComponent.startConvert(prepareOverlays,animationTrack,isPreviewMode?previewScale:1);
					}
					else
					{
						uiComponent.startConvert(checkOverlay,animationTrack,isPreviewMode?previewScale:1);
					}
					return;
				}
			}
			checkOutFile();
			
			
		}
		
		private function checkOverlay(animationTrack:XML):void
		{
			
			if(animationTrack.image.@scale*animationTrack.@contentWidth+int(animationTrack.@x)>settings.resX||animationTrack.image.@scale*animationTrack.@contentHeight+int(animationTrack.@y)>settings.resY)
			{
				return stopProcessing(GshahError.MONTAGE_SCALE_INVALID);
			}
			prepareOverlays();

			
		}
		
		/**
		 * @private
		 * Tests all of the input tracks in the video XML 
		 * @param video is XML with inputs
		 * 
		 */
		private function testVideoXML(video:XML):void
		{
			
			var sourceVideoTracks:XMLList=video.track.(@layer > 0);
			var sourceAnimationTracks:XMLList=video.track.(@layer < 0);
			var sourceSoundTracks:XMLList=video.sound;
			
			var duration:int=0;
			if(sourceVideoTracks!=null&&sourceVideoTracks.length()>0)
			{
				videoTracks=new DataProvider;
				for each (var sourceVideoTrack:XML in sourceVideoTracks) 
				{
					var sourceStart:int=int(sourceVideoTrack.cue.startpos.@time);
					var sourceEnd:int=sourceStart-int(sourceVideoTrack.cue.startpos)+int(sourceVideoTrack.cue.endpos);
					var sourceLayer:int=sourceVideoTrack.@layer;
					var addIndex:int=videoTracks.length;
					sourceVideoTrack.@sourceEnd=sourceEnd;
					
					var fadeIn:int=0;
					if(sourceVideoTrack.hasOwnProperty("@fadein"))
					{
						fadeIn=int(sourceVideoTrack.@fadein.toString());
						sourceVideoTrack.@fadeinFrames=fadeIn*settings.tbr/1000;;
					}
					var fadeOut:int=0;
					if(sourceVideoTrack.hasOwnProperty("@fadeout"))
					{
						fadeOut=int(sourceVideoTrack.@fadeout.toString());
						sourceVideoTrack.@fadeoutFrames=fadeOut*settings.tbr/1000;
					}
					if((fadeIn+fadeOut)>(sourceEnd-sourceStart))
					{
						return stopProcessing(GshahError.MONTAGE_INVALID_TIMING);
					}
					
					for each (var videoTrack:XML in videoTracks.toArray()) 
					{
						var start:int=int(videoTrack.cue.startpos.@time);
						var end:int=start-int(videoTrack.cue.startpos)+int(videoTrack.cue.endpos);
						var layer:int=videoTrack.@layer;
						if(sourceLayer<layer)
						{
							addIndex=videoTracks.getItemIndex(videoTrack);
							break;
						}
						else if(sourceLayer==layer)
						{
							if(sourceEnd<start)
							{
								addIndex=videoTracks.getItemIndex(videoTrack);
								break;
							}
							else if(sourceStart<end)
							{
								return stopProcessing(GshahError.MONTAGE_VIDEOS_OVERLAP);

							}
						}
						
					}
					if((int(sourceVideoTrack.@x.toString())+helper.toEven(sourceVideoTrack.@width.toString())) > settings.resX ||(int(sourceVideoTrack.@y.toString())+helper.toEven(sourceVideoTrack.@height.toString())) > settings.resY)
					{
						return stopProcessing(GshahError.MONTAGE_SIZE_INVALID);
					}
					videoTracks.addItemAt(sourceVideoTrack,addIndex);
				}
				
				animationTracks=new DataProvider;
				for each (var sourceAnimationTrack:XML in sourceAnimationTracks) 
				{
					sourceStart=int(sourceAnimationTrack.cue.startpos.@time);
					if(sourceAnimationTrack.hasOwnProperty('animation'))
					{
						 var sourceOverlay:IGshahAnimationController=animations[sourceAnimationTrack.animation.@id] as IGshahAnimationController
						sourceEnd=sourceStart+(sourceOverlay.content.totalFrames*1000/settings.tbr);
					}
					else
					{
						sourceEnd=int(sourceAnimationTrack.cue.endpos.@time);
					}
					
					fadeIn=0;
					if(sourceAnimationTrack.hasOwnProperty("@fadein"))
					{
						fadeIn=int(sourceAnimationTrack.@fadein.toString());
						sourceAnimationTrack.@fadeinFrames=fadeIn*settings.tbr/1000;;
					}
					fadeOut=0;
					if(sourceAnimationTrack.hasOwnProperty("@fadeout"))
					{
						fadeOut=int(sourceAnimationTrack.@fadeout.toString());
						sourceAnimationTrack.@fadeoutFrames=fadeOut*settings.tbr/1000;
					}
					if((fadeIn+fadeOut)>(sourceEnd-sourceStart))
					{
						return stopProcessing(GshahError.MONTAGE_INVALID_TIMING);
					}
					
					sourceLayer=-sourceAnimationTrack.@layer;
					sourceAnimationTrack.@sourceEnd=sourceEnd;
					addIndex=animationTracks.length;
					for each (var animationTrack:XML in animationTracks.toArray()) 
					{
						start=int(animationTrack.cue.startpos.@time);
						if(sourceAnimationTrack.hasOwnProperty('animation'))
						{
							var overlay:IGshahAnimationController=animations[animationTrack.animation.@id] as IGshahAnimationController
							end=start+(overlay.content.totalFrames*1000/settings.tbr);
						}
						else
						{
							end=start+int(animationTrack.cue.endpos.@time);
						}
						
						layer=-animationTrack.@layer;
						if(sourceLayer<layer)
						{
							addIndex=animationTracks.getItemIndex(animationTrack);
							break;
						}
						else if(sourceLayer==layer)
						{
							if(sourceEnd<start)
							{
								addIndex=animationTracks.getItemIndex(animationTrack);
								break;
							}
							else if(sourceStart<end)
							{
								return stopProcessing(GshahError.MONTAGE_ANIMATIONS_OVERLAP);
							}
						}
					}
					duration=Math.max(duration,sourceEnd);
					animationTracks.addItemAt(sourceAnimationTrack,addIndex);
				}
				
				soundTracks=new DataProvider;
				for each (var sourceSoundTrack:XML in sourceSoundTracks) 
				{
					sourceStart=int(sourceSoundTrack.cue.startpos.@time);
					sourceEnd=sourceStart-int(sourceVideoTrack.cue.startpos)+int(sourceVideoTrack.cue.endpos);
					sourceSoundTrack.@sourceEnd=sourceEnd;
					fadeIn=0;
					if(sourceSoundTrack.hasOwnProperty("@fadein"))
					{
						fadeIn=int(sourceSoundTrack.@fadein.toString());
						sourceSoundTrack.@fadeinFrames=fadeIn*settings.tbr/1000;;
					}
					fadeOut=0;
					if(sourceSoundTrack.hasOwnProperty("@fadeout"))
					{
						fadeOut=int(sourceSoundTrack.@fadeout.toString());
						sourceSoundTrack.@fadeoutFrames=fadeOut*settings.tbr/1000;
					}
					if((fadeIn+fadeOut)>(sourceEnd-sourceStart))
					{
						return stopProcessing(GshahError.MONTAGE_ANIMATIONS_OVERLAP);
					}
					addIndex=soundTracks.length;
					for each (var soundTrack:XML in soundTracks.toArray()) 
					{
						start=int(soundTrack.cue.startpos.@time);
						if(sourceStart<start)
						{
							addIndex=soundTracks.getItemIndex(soundTrack);
							break;
						}
					}
					soundTracks.addItemAt(sourceSoundTrack,addIndex);
				}
				
				withAudio=soundTracks.length>0;
				settings.duration=duration/1000;
			}
			else
			{
				return stopProcessing(GshahError.MONTAGE_XML_INVALID);
			}
		}
		
		/**
		 * @private
		 * Check if output file exists and create it if not
		 * 
		 */
		private function checkOutFile():void
		{
			var outFile:File=new File(settings.outPath);
			if(isPreviewMode||outFile.exists)
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
			
			videoPaths=[]
			if(!isPreviewMode)
			{
				videoPaths.push(settings.outPath);
			}
			for each (var videoTrack:XML in videoTracks.toArray()) 
			{
				if(videoTrack.hasOwnProperty('source'))
				{
					if(!(new File(videoTrack.source.toString()).exists))
					{
						return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
					}
					videoPaths.push(videoTrack.source.toString())
				}
				else
				{
					return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
				}
			}
			for each (var animationTrack:XML in animationTracks.toArray()) 
			{
				if(animationTrack.hasOwnProperty('source'))
				{
					videoPaths.push(animationTrack.source.toString())
				}
				else
				{
					return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
				}
			}
			for each (var soundTrack:XML in soundTracks.toArray()) 
			{
				if(soundTrack.hasOwnProperty('source'))
				{
					if(!(new File(soundTrack.source.toString()).exists))
					{
						return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
					}
					videoPaths.push(soundTrack.source.toString())
				}
				else
				{
					return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
				}
			}
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
			helper.getShortPathes(videoPaths);
			
		}
				
		
		
		
		/**
		 * @private 
		 * Complete handler for the preparePathes method
		 */
		protected function onGetShortPathes(event:GshahEvent):void
		{
			helper.removeEventListener(GshahEvent.GSHAH_COMPLETE,onGetShortPathes);
			var outArr:Array=event.data.split("\r\n");
			videoPaths=[];
			if(outArr.length==videoTracks.length+animationTracks.length+soundTracks.length+(isPreviewMode?3:4))
			{
				if(!isPreviewMode)
				{
					settings.outPath=outArr[2];
				}
				
				
				for (var i:int = 0; i < videoTracks.length; i++) 
				{
					videoTracks.getItemAt(i).source=outArr[i+(isPreviewMode?2:3)];
					videoPaths.push(outArr[i+(isPreviewMode?2:3)]);
				}
				
				for (var j:int = 0; j < animationTracks.length; j++) 
				{
					animationTracks.getItemAt(j).source=outArr[j+i+(isPreviewMode?2:3)];
				}
				
				for (var k:int = 0; k < soundTracks.length; k++) 
				{
					soundTracks.getItemAt(k).source=outArr[k+j+i+(isPreviewMode?2:3)];
					videoPaths.push(outArr[k+j+i+(isPreviewMode?2:3)]);
				}
			}
			else
			{
				return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
			}
			
			helper.addEventListener(GshahEvent.GSHAH_COMPLETE,onGetTracksParams);
			helper.getTracksParams(videoPaths);
			
			
		}
		
		
		/**
		 * @private
		 * Applies video parameters to the inputs
		 */
		private function onGetTracksParams(event:GshahEvent):void
		{
			helper.removeEventListener(GshahEvent.GSHAH_COMPLETE,onGetTracksParams);
			var trackParamArray:Array=event.data.split('Input #')
			for (var i:int = 0; i < videoTracks.length; i++) 
			{
				var gs:GshahSettings=FfmpegVideoUtils.parseVideoParams('Input #'+trackParamArray[i+1]);
				var tr:XML=videoTracks.getItemAt(i) as XML;
				if((tr.cue.endpos+tr.cue.startpos)<gs.duration)
				{
					return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
				}
				var start:int=int(tr.cue.startpos.toString());
				var end:int=int(tr.cue.endpos.toString());
				var sourceStart:int=int(tr.cue.startpos.@time);
				settings.totalFrames=Math.max(settings.totalFrames,(sourceStart-start+end)*settings.tbr/1000);
				tr.cue.endpos.@frames=Math.round((end-start)*settings.tbr/1000);
				tr.cue.startpos.@frame=Math.round((int(tr.cue.startpos.@time)*settings.tbr)/1000);
				cutVideo(tr);
			}
			for (var j:int = 0; j < soundTracks.length; j++) 
			{
				gs=FfmpegVideoUtils.parseVideoParams('Input #'+trackParamArray[j+i+1]);
				tr=soundTracks.getItemAt(j) as XML;
				if((tr.cue.endpos+tr.cue.startpos)<gs.duration)
				{
					return stopProcessing(GshahError.MONTAGE_INVALID_PATH);
				}
				start=int(tr.cue.startpos.toString());
				end=int(tr.cue.endpos.toString());
				sourceStart=int(tr.cue.startpos.@time);
				settings.totalFrames=Math.max(settings.totalFrames,(sourceStart-start+end)*settings.tbr/1000);
				tr.cue.endpos.@frames=Math.round((end-start)*settings.tbr/1000);
				tr.cue.startpos.@frame=Math.round((int(tr.cue.startpos.@time)*settings.tbr)/1000);
				cutAudio(tr);
			}
			helper.log('totalFrames='+settings.totalFrames);
			
			isReadyToSeek=true;
			if(withAudio)
			{
				startAudioMontage();
			}
			else
			{
				startMontage();
			}
		}
		/**
		 * @private
		 * Use this function when you have to stop the montage because of error
		 * 
		 */
		public function stopProcessing(errorCode:uint=-1):void
		{
			if(errorCode!=-1)
			{
				var error:GshahError=new GshahError(errorCode);
				helper.log(error.message);
				dispatchEvent(new GshahErrorEvent(error));
			}
			processing=false;
		}
		
		
		
		
		/**
		 * Cuts video using settings in tr XML 
		 * @param tr is XML with settings about track
		 * 
		 */
		private function cutVideo(tr:XML):void
		{
			var tcpPort:int=helper.getNextPortNumber();
			var videoWidth:int=helper.toEven(tr.@width.toString());
			var videoHeight:int=helper.toEven(tr.@height.toString());
			if(isPreviewMode)
			{
				videoWidth=helper.toEven(Math.round(videoWidth*previewScale));
				videoHeight=helper.toEven(Math.round(videoHeight*previewScale));
			}
			var startPos:int=Math.max(int(tr.cue.startpos.toString()),(seekTime-int(tr.cue.startpos.@time.toString())));
			var endPos:int=int(tr.cue.endpos.toString())-startPos;
			var cutParams:Array=[
				FfmpegVideoUtils.COMMAND_CUT_START, FfmpegVideoUtils.convertTime(startPos),
				FfmpegVideoUtils.COMMAND_INPUT,tr.source.toString(),
				FfmpegVideoUtils.COMMAND_RESOLUTION, [videoWidth,videoHeight].join('x'),
				FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_SOUND, 
				FfmpegVideoUtils.COMMAND_FRAMERATE, settings.tbr,
				FfmpegVideoUtils.COMMAND_FORMAT, FfmpegVideoUtils.FORMAT_RAWVIDEO,
				
				//FfmpegVideoUtils.COMMAND_VIDEO_FRAMES,int(tr.cue.endpos.@frames.toString())-(seekTime/1000*settings.tbr),
				FfmpegVideoUtils.COMMAND_CUT_END,FfmpegVideoUtils.convertTime(endPos),
				'"tcp://127.0.0.1:'+tcpPort.toString()+'?listen=1&listen_timeout='+FfmpegVideoUtils.TCP_TIMEOUT.toString()+'"'
			];
			tr.source.@tcpPort=tcpPort;
			
			helper.writeUTFFileAndLunch(File.applicationStorageDirectory.resolvePath("ffmpegLib/cut_"+tcpPort.toString()+".cmd"),'ffmpeg '+cutParams.join(' '));
			
						
		}
		
		/**
		 * Cuts audio using settings in tr XML 
		 * @param tr is XML with settings about track
		 * 
		 */
		private function cutAudio(tr:XML):void
		{
			var tcpPort:int=helper.getNextPortNumber();
			var startPos:int=Math.max(int(tr.cue.startpos.toString()),(seekTime-int(tr.cue.startpos.@time.toString())));
			var endPos:int=int(tr.cue.endpos.toString())-startPos;
			var cutParams:Array=[
				FfmpegVideoUtils.COMMAND_CUT_START, FfmpegVideoUtils.convertTime(startPos),
				FfmpegVideoUtils.COMMAND_INPUT,tr.source.toString(),
				FfmpegVideoUtils.COMMAND_AUDIO_CHANELS, settings.audioChanels,
				FfmpegVideoUtils.COMMAND_AUDIO_RATE, settings.audioRate,
				FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_VIDEO, 
				FfmpegVideoUtils.COMMAND_AUDIO_CODEC, FfmpegVideoUtils.CODEC_RAWAUDIO,
				FfmpegVideoUtils.COMMAND_FORMAT, FfmpegVideoUtils.FORMAT_RAWAUDIO,
				
				FfmpegVideoUtils.COMMAND_CUT_END,FfmpegVideoUtils.convertTime(endPos),
				'"tcp://127.0.0.1:'+tcpPort.toString()+'?listen=1&listen_timeout='+FfmpegVideoUtils.TCP_TIMEOUT.toString()+'"'
			];
			tr.source.@tcpPort=tcpPort;
			
			
			helper.writeUTFFileAndLunch(File.applicationStorageDirectory.resolvePath("ffmpegLib/cut_"+tcpPort.toString()+".cmd"),'ffmpeg '+cutParams.join(' '));

		}
		

		/**
		 * @private 
		 * Handler for a process output
		 */
		private function onProcessOutput(s:String):void
		{
			helper.log(s);
		}		
		private var audioOutTcpPort:int;
		/**
		 * @private 
		 * Starts the montage process
		 */
		private function startAudioMontage():void
		{
			audioOutTcpPort=helper.getNextPortNumber();
			var montageParams:Array=[
				soundTracks.length, settings.audioRate/settings.tbr*settings.audioChanels*2, audioOutTcpPort, (seekTime*settings.tbr/1000)
			];
			var i:int=0;
			for each (var soundTrack:XML in soundTracks.toArray()) 
			{
				if(soundTrack.source.hasOwnProperty('@tcpPort'))
				{
					montageParams.push(int(soundTrack.cue.startpos.@frame.toString()),soundTrack.source.@tcpPort,int(soundTrack.@fadeinFrames.toString()),int(soundTrack.@fadeoutFrames.toString()),int(int(soundTrack.@sourceEnd.toString()*settings.tbr/1000)));
					i++;
				}
			}
			if(i!=soundTracks.length)
			{
				montageParams[0]=i;
			}
			var joinCmdLocation:File=File.applicationStorageDirectory.resolvePath("ffmpegLib/soundMontage.cmd");

			helper.writeUTFFile(joinCmdLocation,'soundMontage.exe '+montageParams.join(' '));

			NativeProcessUtils.runNativeProcess(joinCmdLocation,[], NativeProcessUtils.errorHandlerFunction(onProcessOutput), NativeProcessUtils.outputHandlerFunction(onProcessOutput),null);
			startMontage();
		}
		
		private var withAudio:Boolean;
		private var previewTcpPort:int;
		/**
		 * @private 
		 * Starts the montage process
		 */
		private function startMontage():void
		{
			if(isPreviewMode)
			{
				previewTcpPort=helper.getNextPortNumber();
			}
			
			var videoWidth:int=settings.resX;
			var videoHeight:int=settings.resY;
			if(isPreviewMode)
			{
				videoWidth=helper.toEven(Math.round(videoWidth*previewScale));
				videoHeight=helper.toEven(Math.round(videoHeight*previewScale));
			}
			var montageParams:Array=[
				videoTracks.length+animationTracks.length,
				videoWidth, videoHeight, (seekTime*settings.tbr/1000), settings.bgColor
			];
			var i:int=0;
			var j:int=0;
			var k:int=0;
			var pushVideo:Boolean;
			while(i<videoTracks.length||j<animationTracks.length)
			{
				if(i<videoTracks.length)
				{
					var videoTrack:XML=videoTracks.getItemAt(i) as XML;

				}
				if(j<animationTracks.length)
				{
					var animationTrack:XML=animationTracks.getItemAt(j) as XML;
				}
				if(i<videoTracks.length&&j<animationTracks.length)
				{
					pushVideo=(-int(animationTrack.@layer.toString()))>=int(videoTrack.@layer.toString());
				}
				else
				{
					pushVideo=i<videoTracks.length;					
				}
				
				if(pushVideo)
				{
					if(videoTrack.source.hasOwnProperty('@tcpPort'))
					{
						
						videoWidth=int(videoTrack.@width.toString());
						videoHeight=int(videoTrack.@height.toString());
						var videoX:int=int(videoTrack.@x.toString());
						var videoY:int=int(videoTrack.@y.toString());
						if(isPreviewMode)
						{
							videoWidth=helper.toEven(Math.round(videoWidth*previewScale));
							videoHeight=helper.toEven(Math.round(videoHeight*previewScale));
							videoX=Math.round(videoX*previewScale);
							videoY=Math.round(videoY*previewScale);
						}
						montageParams.push('1',videoTrack.cue.startpos.@frame,int(int(videoTrack.@sourceEnd.toString()*settings.tbr/1000)),videoTrack.source.@tcpPort,
										   videoWidth,videoHeight,videoX,videoY,videoTrack.@greenscreenbackground.toString()=="true"?parseInt(videoTrack.@greenscreencolour1.toString().substr(1),16):-1,int(videoTrack.@fadeinFrames.toString()),int(videoTrack.@fadeoutFrames.toString()));
						k++;
					}
					i++;
				}
				else
				{
					if(int(animationTrack.@sourceEnd.toString())>seekTime)
					{
						
						videoX=int(animationTrack.@x.toString());
						videoY=int(animationTrack.@y.toString());
						if(isPreviewMode)
						{
							videoX=Math.round(videoX*previewScale);
							videoY=Math.round(videoY*previewScale);
						}
						if(animationTrack.hasOwnProperty('animation'))
						{
							montageParams.push('-1',int(animationTrack.cue.startpos.@time*settings.tbr/1000),int(int(animationTrack.@sourceEnd.toString()*settings.tbr/1000)),animationTrack.source.toString(),
											   Math.round(animationTrack.@contentWidth*Math.round(animationTrack.animation.@scale*previewScale*10)/10),Math.round(animationTrack.@contentHeight*Math.round(animationTrack.animation.@scale*previewScale*10)/10),
											   videoX,videoY,-1,int(animationTrack.@fadeinFrames.toString()),int(animationTrack.@fadeoutFrames.toString()));
						}
						else if(animationTrack.hasOwnProperty('image'))
						{
							montageParams.push('-2',int(animationTrack.cue.startpos.@time*settings.tbr/1000),int(int(animationTrack.@sourceEnd.toString()*settings.tbr/1000)),animationTrack.source.toString(),
											   Math.round(animationTrack.@contentWidth*animationTrack.image.@scale*previewScale),Math.round(animationTrack.@contentHeight*animationTrack.image.@scale*previewScale),
											   videoX,videoY,-1,int(animationTrack.@fadeinFrames.toString()),int(animationTrack.@fadeoutFrames.toString()));
						}
						k++;
					}
					j++;
				}
			}
			if(k!=montageParams[0])
			{
				montageParams[0]=k;
			}
			videoWidth=settings.resX;
			videoHeight=settings.resY;
			if(isPreviewMode)
			{
				videoWidth=helper.toEven(Math.round(videoWidth*previewScale));
				videoHeight=helper.toEven(Math.round(videoHeight*previewScale));
			}
			var joinParams:Array=[
				FfmpegVideoUtils.COMMAND_RESOLUTION, [videoWidth,videoHeight].join('x'),
				FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_SOUND, 
				FfmpegVideoUtils.COMMAND_FRAMERATE, settings.tbr,
				FfmpegVideoUtils.COMMAND_FORMAT, FfmpegVideoUtils.FORMAT_RAWVIDEO,
				FfmpegVideoUtils.COMMAND_INPUT, '-'
			];
			if(withAudio)
			{
				joinParams.push(FfmpegVideoUtils.COMMAND_AUDIO_CHANELS, settings.audioChanels,
					FfmpegVideoUtils.COMMAND_AUDIO_RATE, settings.audioRate,
					FfmpegVideoUtils.COMMAND_OUTPUT_WITHOUT_VIDEO, 
					FfmpegVideoUtils.COMMAND_AUDIO_CODEC, FfmpegVideoUtils.CODEC_RAWAUDIO,
					FfmpegVideoUtils.COMMAND_FORMAT, FfmpegVideoUtils.FORMAT_RAWAUDIO,
					FfmpegVideoUtils.COMMAND_INPUT, "tcp://127.0.0.1:"+audioOutTcpPort+"?timeout=100000",
					'-map 0:v:0 -map 1:a:0 -shortest')
			}
			joinParams.push(FfmpegVideoUtils.COMMAND_VIDEO_BITRATE,FfmpegVideoUtils.DEFAULT_VIDEO_BITRATE, 
							FfmpegVideoUtils.COMMAND_FRAMERATE, settings.tbr,
							'-g 10');
			if(isPreviewMode)
			{
				joinParams.push(FfmpegVideoUtils.COMMAND_FORMAT,'flv','"tcp://127.0.0.1:'+previewTcpPort.toString()+'?listen=1&listen_timeout='+FfmpegVideoUtils.TCP_TIMEOUT.toString()+'"');
			}
			else
			{
				joinParams.push(settings.outPath, FfmpegVideoUtils.COMMAND_REWRITE);
			}
			
			var joinCmdLocation:File=File.applicationStorageDirectory.resolvePath("ffmpegLib/videoMontage.cmd");
			helper.writeUTFFile(joinCmdLocation,'montage.exe '+montageParams.join(' ')+' | ffmpeg '+joinParams.join(' '));

			NativeProcessUtils.runNativeProcess(joinCmdLocation,[], NativeProcessUtils.errorHandlerFunction(onRewriteWithConvertError), NativeProcessUtils.outputHandlerFunction(onProcessOutput),onProccesDoneReadHandler);
			if(isPreviewMode)
			{
				isFirstProgress=true;
				netStream.play(null);
				socketIOErrorHandler();
				
			}
		}
		private var socket:Socket;
		
		protected function socketIOErrorHandler(event:IOErrorEvent=null):void
		{
			if(event!=null)
			{
				socket.removeEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketProgress);
				socket=null;
			}
			socket=new Socket('127.0.0.1',previewTcpPort);
			socket.addEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketProgress);
		}

		private var curFrame:Number=0;
		/**
		 * @private 
		 * Error data handler for the startMontage method
		 */
		public function onRewriteWithConvertError(s:String):void
		{
			helper.log(s);
			
			var errDataArr:Array=s.split('\\n');
			
			var errDataLast:String=errDataArr[errDataArr.length-1];
			var frameMatches:Array=errDataLast.match(/frame=[^0-9]+([0-9]+)/);
			if(frameMatches!=null&&frameMatches.length==2)
			{
				curFrame=frameMatches[1];
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,curFrame+(seekTime*settings.tbr/1000),settings.totalFrames));
			}
		}

		
		/**
		 * @private 
		 * Exit handler for the startMontage method
		 */
		public function onProccesDoneReadHandler(event:NativeProcessExitEvent):void
		{
			_timeStamp = getTimer() - _timeStamp;

			helper.log("milliseconds: " + _timeStamp);
			helper.saveLog(settings.outPath);
			
			if(!isPreviewMode)
			{
				processing = false;
				dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,"done processing video, see result at " + settings.outPath +", took "+_timeStamp+"ms"));

			}
		}
		
		[Bindable]
		private var checkFiles:Array=[{o:false, f:FfmpegVideoUtils.FFMPEG_LOCATION,r:FfmpegVideoUtils.FFMPEG_RESOURCE},
			{o:true, f:FfmpegVideoUtils.SOUNDMONTAGE_EXE_LOCATION, r:FfmpegVideoUtils.SOUNDMONTAGE_RESOURCE},
				{o:true, f:FfmpegVideoUtils.MONTAGE_EXE_LOCATION, r:FfmpegVideoUtils.MONTAGE_RESOURCE}];
				
		private var isFirstProgress:Boolean;
		private var isReadyToSeek:Boolean;
		protected function onSocketProgress(event:ProgressEvent):void
		{
			if(isFirstProgress)
			{
				helper.log("Start playing", getTimer() - _timeStamp);
				isFirstProgress=false;
			}
			
			var socket:Socket=event.target as Socket; 
			var ba:ByteArray=new ByteArray;
			socket.readBytes(ba);
			netStream.appendBytes(ba);
		}
		protected function metaDataHandler(infoObject:Object):void {
			}
		private function createNetStream():void
		{
			var customClient:Object = new Object();
			customClient.onMetaData = metaDataHandler;
			var netConnection:NetConnection = new NetConnection();
			netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.client = customClient;
			previewVideo.attachNetStream(netStream);
		}
		public var seekTime:int=0;
		public function seekToPercent(seekPercent:Number):void
		{
			seekTo(seekPercent*settings.totalFrames/settings.tbr*1000);
		}
		public function seekTo(seekTime:int):void
		{
			if(isReadyToSeek)
			{
				/*var delta:Number=(seekTime-this.seekTime)/1000;
				
				if(delta>0&&curFrame>delta*settings.tbr)
				{
					netStream.seek(delta);
					netStream.play(null);
					return;
				}*/
				//netStream.pause();
				this.seekTime=seekTime;
				
				NativeProcessUtils.stopAll();
				
				socket.removeEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketProgress);
				if(socket.connected)
				{
					socket.close();
				}
				
				socket=null;
				
				curFrame=0;
				
				_timeStamp = getTimer();
				
				processing = true;
							
				createNetStream();
							
				for  each(var tr:XML in videoTracks.toArray()) 
				{
					var start:int=int(tr.cue.startpos.toString());
					var end:int=int(tr.cue.endpos.toString());
					var sourceStart:int=int(tr.cue.startpos.@time);
					delete tr.source.@tcpPort;
					if((sourceStart-start+end)>seekTime)
					{
						cutVideo(tr);
					}
					
				}
				withAudio=false;
				for each(var soundTr:XML in soundTracks.toArray()) 
				{
					start=int(soundTr.cue.startpos.toString());
					end=int(soundTr.cue.endpos.toString());
					sourceStart=int(soundTr.cue.startpos.@time);
					delete soundTr.source.@tcpPort;
					if((sourceStart-start+end)>seekTime)
					{
						cutAudio(soundTr);
						if(!withAudio)
						{
							withAudio=true;
						}
						
					}
					
				}
				helper.log('start seek montage');
				if(withAudio)
				{
					startAudioMontage();
				}
				else
				{
					startMontage();
				}
			}
		}
	}
}