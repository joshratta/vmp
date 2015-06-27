package gshah.entities
{
	import flash.net.FileFilter;
	
	public class GshahAssetType
	{
		public static const NONE:String="none";
		public static const VIDEO:String="video";
		public static const AUDIO:String="audio";
		public static const IMAGE:String="image";
		public static const ANIMATION:String="animation";
		public static const TEXT:String="text";

		public static const VIDEO_EXTENTIONS:Array=["flv", "mov", "avi", "gif","mpeg", "wmv", "mpg", "mp4", "mkv", "ogv", "qt", "m4p", "rm", "rmvb", "mpe", "3gp"];
		public static const AUDIO_EXTENTIONS:Array=["wav", "mp3", "wma", "oga", "aac", "ra"];
		public static const IMAGE_EXTENTIONS:Array=["png", "jpg", "jpeg",  "bmp"];
		public static const RAW_EXTENTION:String="raw";
		
		public static function getByExtention(extention:String):String
		{
			extention=extention.toLowerCase();
			if(VIDEO_EXTENTIONS.indexOf(extention)>-1)
			{
				return VIDEO;
			}
			else if(AUDIO_EXTENTIONS.indexOf(extention)>-1)
			{
				return AUDIO;
			}
			else if(IMAGE_EXTENTIONS.indexOf(extention)>-1)
			{
				return IMAGE;
			}
			else
			{
				return NONE;
			}
		}
		
		public static function getFileFilters():Array
		{
			return [new FileFilter("Media", '*.'+VIDEO_EXTENTIONS.concat(AUDIO_EXTENTIONS).concat(IMAGE_EXTENTIONS).join('; *.')),
				new FileFilter("Videos", '*.'+VIDEO_EXTENTIONS.join('; *.')),
				new FileFilter("Audios", '*.'+AUDIO_EXTENTIONS.join('; *.')),
				new FileFilter("Images", '*.'+IMAGE_EXTENTIONS.join('; *.')),
				new FileFilter("All files", "*.*")]
		}
		
		public static function getImageFileFilters():Array
		{
			return [new FileFilter("Images", '*.'+IMAGE_EXTENTIONS.join('; *.')),
				new FileFilter("All files", "*.*")]
		}
		public static function getVideoFileFilters():Array
		{
			return [new FileFilter("Videos", '*.'+VIDEO_EXTENTIONS.join('; *.')),
				new FileFilter("All files", "*.*")]
		}
	}
}