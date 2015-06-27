package gshah.utils
{
	import gshah.GshahSettings;
	
	/**
	 *  The FfmpegVideoUtils class is an all-static class 
	 *  with methods for working with video through ffmpeg util.
	 *  You do not create instances of FfmpegVideoUtils 
	 *  instead you simply call static methods.
	 */
	public class FfmpegVideoUtils
	{
		/**
		 * The command for ffmpeg to rewrite output file
		 */
		public static const COMMAND_REWRITE:String = "-y";
		/**
		 * The command for ffmpeg to specify format
		 */
		public static const COMMAND_FORMAT:String = "-f";
		/**
		 * The command for ffmpeg to locate input file
		 */
		public static const COMMAND_INPUT:String = "-i";
		/**
		 * The command for ffmpeg to write output stream without sound
		 */
		public static const COMMAND_OUTPUT_WITHOUT_SOUND:String = "-an";
		/**
		 * The command for ffmpeg to write output stream without video
		 */
		public static const COMMAND_OUTPUT_WITHOUT_VIDEO:String = "-vn";
		/**
		 * The command for ffmpeg to specify stream resolution
		 */
		public static const COMMAND_RESOLUTION:String = "-s";
		/**
		 * The command for ffmpeg to locate start of video cutting
		 */
		public static const COMMAND_CUT_START:String = "-ss";
		/**
		 * The command for ffmpeg to locate end of video cutting
		 */
		public static const COMMAND_CUT_END:String = "-t";
		/**
		 * The command for ffmpeg  to specify stream framerate
		 */
		public static const COMMAND_FRAMERATE:String = "-r";
		/**
		 * The command for ffmpeg  to specify video frames amount
		 */
		public static const COMMAND_VIDEO_FRAMES:String = "-vframes";
		/**
		 * The command for ffmpeg  to specify video frames bitrate
		 */
		public static const COMMAND_VIDEO_BITRATE:String = "-vb";
		/* The command for ffmpeg  to specify audio frames bitrate
		 */
		public static const COMMAND_AUDIO_BITRATE:String = "-ab";
		/**
		 * The command for ffmpeg to specify audio chanels amount
		 */
		public static const COMMAND_AUDIO_CHANELS:String = "-ac";
		/**
		 * The command for ffmpeg to specify audio rate
		 */
		public static const COMMAND_AUDIO_RATE:String = "-ar";
		/**
		 * The command for ffmpeg to specify audio codec
		 */
		public static const COMMAND_AUDIO_CODEC:String = "-acodec";
		/**
		 * The command for cmd to get file short path
		 */
		public static const SFN_CMD_CONTENT:String = "cmd /C for %%I in ($$1) do @echo %%~fsI";
		/**
		 * The raw video format for ffmpeg
		 */
		public static const FORMAT_RAWVIDEO:String = "rawvideo";
		/**
		 * The raw audio format for ffmpeg
		 */
		public static const FORMAT_RAWAUDIO:String = "s16le";
		/**
		 * The raw audio codec for ffmpeg
		 */
		public static const CODEC_RAWAUDIO:String = "pcm_s16le";
		/**
		 * The raw format for ffmpeg
		 */
		public static const DEFAULT_VIDEO_BITRATE:String = "5M";
		/**
		 * timeout for tcp (listen_timeout)
		 */
		public static var TCP_TIMEOUT:Number=100000;
		
		
		
		
		/**
		 * Uses regular expressions to parse info from ffmpeg to <code>gshah.GshahSettings</code>
		 * @param buffer is ffmpeg ouput for one video file
		 * @return <code>gshah.GshahSettings</code>
		 * 
		 */
		public static function parseVideoParams(buffer:String):GshahSettings
		{
			var gshahSettings:GshahSettings=new GshahSettings;
			var duration:Number=-1;
			var framesCount:Number=-1;
			var tbr:Number=30;
			var durMatches:Array=buffer.match(/Duration: ([0-9]+):([0-9]+):([0-9]+).([0-9]+)/);
			if(durMatches!=null&&durMatches.length==5)
			{
				duration=(parseFloat(durMatches[1])*60+parseFloat(durMatches[2]))*60+parseFloat(durMatches[3])+parseFloat(durMatches[4])/100;
				trace('duration=',duration,'seconds');
			}
			var tbrMatches:Array=buffer.match(/([0-9.]+) tbr/);
			if(tbrMatches!=null&&tbrMatches.length==2)
			{
				tbr=parseFloat(tbrMatches[1]);
				trace('tbr=',tbr);
			}
			if(duration!=-1)
			{
				framesCount=duration*tbr;
			}
			var resMatches:Array=buffer.match(/Stream.+, ([0-9]+)x([0-9]+)/);
			if(resMatches!=null&&resMatches.length==3)
			{
				gshahSettings.resX=resMatches[1];
				gshahSettings.resY=resMatches[2];
			}
			trace('resolution=',gshahSettings.resX,'x',gshahSettings.resY);
			
			var audioMatches:Array=buffer.match(/Stream.+Audio/);
			if(audioMatches!=null&&audioMatches.length>0)
			{
				gshahSettings.withAudio=true;
			}
			gshahSettings.totalFrames=framesCount;
			gshahSettings.tbr=tbr;
			gshahSettings.duration=duration;
			return gshahSettings;
			
		}
		
		/**
		 * Returns string HH:MM:SS from milliseconds
		 * @param ms is time in milliseconds
		 * @return string HH:MM:SS
		 * 
		 */
		public static function convertTime(ms:Number,accuracy:int=-1):String
		{
			if(accuracy!=-1)
			{
				ms=Math.round(ms/Math.pow(10,3-accuracy))*Math.pow(10,3-accuracy);
			}
			var hours:int=int(ms/3600000);
			ms-=hours*3600000;
			var minutes:int=int(ms/60000);
			ms-=minutes*60000;
			var seconds:Number=ms/1000;
			return [timePartToString(hours),timePartToString(minutes),timePartToString(seconds)].join(':');
		}
		
		/**
		 * Adds '0' from the start to arguments if it's lower then 10 and returns as string
		 * @param t is Number
		 * @return String
		 * 
		 */
		public static function timePartToString(t:Number):String
		{
			var s:String=t.toString();
			if(t<10)
			{
				s="0"+s;
			}
			return s;
		}
	}
}