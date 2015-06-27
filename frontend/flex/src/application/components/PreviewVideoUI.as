package application.components
{
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;
	
	import application.managers.TimelineManager;
	
	public class PreviewVideoUI extends UIComponent
	{
		private var video:Video=new Video;
		private var maskGroup:BorderContainer;
		public function PreviewVideoUI()
		{
			video=new Video;
			video.smoothing=true;
			setVideoSize();
			addChild(video);
			maskGroup=new BorderContainer;
			addChild(maskGroup);
			video.mask=maskGroup;


		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			maskGroup.height=value;
			setVideoSize();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			maskGroup.width=value;
			setVideoSize();
		}
		
		public function attachNetStream(ns:NetStream):void
		{
			video.attachNetStream(ns);
		}
		public function setVideoSize():void
		{
			video.width=TimelineManager.instance.width*video.width/int(video.width/2)/2;
			video.height=TimelineManager.instance.height*video.height/int(video.height/2)/2;
		}
		
		
	}
}