package sys
{
	import flash.filesystem.File;
	
	import mx.utils.UIDUtil;

	public class SystemSettings
	{
		public static var isMac:Boolean;
		
		[Bindable]
		public static var updateAvailable:Boolean;
		[Bindable]
		public static var messageCount:int=0;
		
		public static var tempFolder:File=File.createTempDirectory();
		public static var tempPath:String=tempFolder.nativePath;

		public static var binFolder:File=File.applicationDirectory.resolvePath('ffmpegLib');
		public static var binPath:String=binFolder.nativePath;
		
		public static const FFMPEG_BIN:String='ffmpeg.exe';
		public static const SCREEN_SHOOTER_BIN:String='screenShooter.exe';
		public static const VMP_CORE_BIN:String='vmp_core.exe';

		[Bindable]
		public static var clientVersion:String;
		[Bindable]
		public static var updatePath:String=RELEASE_PATH;
		
		public static const RELEASE_PATH:String='videomotionpro2';
		public static const DEBUG_PATH:String='videomotionpro_debug';
		public static const UPDATE_URL:String='62.210.127.51';
		
		public static const LICENSING_URL:String='https://videomotionpromembers.com/wp-admin/admin-ajax.php?action=video_motion_request';

		public static const LICENSING_TYPE_STARTER:String='starter';
		public static const LICENSING_TYPE_PREMIUM:String='premium';
		public static const LICENSING_TYPE_AGENCY:String='agency';
		public static const LICENSING_TYPE_OTO1:String='OTO1';
		public static const LICENSING_TYPE_OTO1DOWNSELL:String='OTO1DownSell';
		public static const LICENSING_TYPES:Array=[LICENSING_TYPE_STARTER,LICENSING_TYPE_PREMIUM,LICENSING_TYPE_AGENCY,LICENSING_TYPE_OTO1,LICENSING_TYPE_OTO1DOWNSELL];
		
		[Bindable]
		public static var licensingType:String=LICENSING_TYPE_STARTER;
		
		public static function getBinFile(name:String=SystemSettings.FFMPEG_BIN):File
		{
			var parts:Array=[];
			if(SystemSettings.isMac)
			{
				parts.push('mac');
			}
			parts.push(name);
			return binFolder.resolvePath(parts.join(File.separator));
		}
		public static function getBinPath(name:String=SystemSettings.FFMPEG_BIN):String
		{
			var parts:Array=[binPath];
			if(SystemSettings.isMac)
			{
				parts.push('mac');
			}
			parts.push(name);
			return '"'+parts.join(File.separator)+'"';
		}
		
		public static function newTempFolder():File
		{
			var tf:File=tempFolder.resolvePath(UIDUtil.createUID());
			tf.createDirectory();
			return tf;
		}
		
		public static function newTempFile(extention:String='cmd'):File
		{
			return tempFolder.resolvePath(UIDUtil.createUID()+'.'+extention)
		}
	}
}