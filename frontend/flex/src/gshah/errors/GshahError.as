package gshah.errors
{
	public class GshahError extends Error
	{
		public static const MONTAGE_XML_INVALID:uint=0x00;
		public static const MONTAGE_VIDEOS_OVERLAP:uint=0x01;
		public static const MONTAGE_ANIMATIONS_OVERLAP:uint=0x02;
		public static const MONTAGE_INVALID_PATH:uint=0x03;
		public static const MONTAGE_INVALID_TIMING:uint=0x04;
		public static const MONTAGE_SCALE_INVALID:uint=0x05;
		public static const MONTAGE_SIZE_INVALID:uint=0x06;

		public static const MESSAGES_TEXT:Array=['Invalip xml','Videos overlap', 'Animations overlap', 'Invalid path', 'Invalid timing', 'Invalid animation size','Invalid video size']	
		
		public function GshahError(code:*=0)
		{
			super(MESSAGES_TEXT[code], code);
		}
	}
}