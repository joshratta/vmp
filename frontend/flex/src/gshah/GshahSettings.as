package gshah
{
	import gshah.utils.FfmpegVideoUtils;

	[Bindable]
	public class GshahSettings
	{
		/**
		 *  Native path for output video file
		 */
		public var outPath:String=''; 
		/**
		 *  Horizontal resolution for output video
		 *  @default 640
		 */
		public var resX:Number=640; 
		/**
		 *  Vertical resolution for output video
		 *  @default <code>gshah.utils.VideoUtils.MIN_RESOLUTION_Y</code>
		 */
		public var resY:Number=480;
		/**
		 *  Guessed from the input video stream value for the video frame rate
		 *  @default 30
		 */
		public var tbr:Number=30; 
		/**
		 *  Audio chanels amount
		 *  @default 2
		 */
		public var audioChanels:int=2; 
		/**
		 *  Audio rate
		 *  @default 44100
		 */
		 
		public var audioRate:int=44100; 
		/**
		 *  Audio bitrate
		 *  @default 256k
		 */
		public var audioBitrate:String='256k'; 
		/**
		 *  @private
		 *  Storage for the totalFrames property 
		 */
		 private var _totalFrames:int=-1;
		 
		 public static const DEFAULT_LOWER_THIRDS_DELAY:Number=2000;

		 public var lowerThirdsDelay:int=DEFAULT_LOWER_THIRDS_DELAY; 
		
		 public var bgColor:int=-1; 

		/**
		 *  @private
		 *  Storage for the duration property 
		 */
		private var _duration:Number=-1;
		/**
		 *  Video bitrate
		 *  @default 5M
		 */
		public var videoBitrate:String=FfmpegVideoUtils.DEFAULT_VIDEO_BITRATE;
		
		/**
		 *  Video duration in seconds
		 *  @default -1
		 */
		public function get duration():Number
		{
			return _duration;
		}

		public function set duration(value:Number):void
		{
			if(_duration!=value)
			{
				_duration = value;
				totalFrames=value*tbr;
			}
			
		}
		
		/**
		 *  The number of frames of the input video
		 *  @default -1
		 */
		public function get totalFrames():int
		{
			return _totalFrames;
		}

		public function set totalFrames(value:int):void
		{
			if(_totalFrames!=value)
			{
				_totalFrames = value;
			}
		}
		
		public var withAudio:Boolean=false;

	
	}
}