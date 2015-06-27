package gshah
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import application.managers.TimelineManager;
	
	import gshah.entities.GshahAssetType;
	import gshah.events.GshahEvent;
	import gshah.utils.GshahApi;
	import gshah.utils.GshahAssetUtils;
	
	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	public class GshahThumbnailer extends EventDispatcher
	{
		public function GshahThumbnailer()
		{
		}
		
		private var size:int;
		
		private var bufferByteArray:ByteArray;
		
		private var width:int;
		
		private var height:int;
		
		private var interval:Number;
		
		private var parts:Array;
		
		private var path:String;
		
		private var timelineSocket:Socket;
		
		private var type:String;
		
		private var addParams:String;
		
		
		public function start(assetType:String,nativePath:String,assetParts:Array,intervalTime:Number,elementWidth:int,elementHeight:int,additionalParams:String=null):void
		{
			bufferByteArray=new ByteArray;

			path=nativePath;
			
			type=assetType;
			
			width=elementWidth;
			height=elementHeight;
			size=width*(height+1)*4;
			
			parts=assetParts;
			
			interval=intervalTime;
			
			addParams=additionalParams;
			
			timelineSocket=new Socket('127.0.0.1',GshahVideoController.instance.timelineTcpPort);
			timelineSocket.addEventListener(Event.CONNECT,timelineSocket_connectHandler);
			
		}
		
		protected function timelineSocket_connectHandler(event:Event):void
		{
			var timelineSocket:Socket=event.target as Socket;
			timelineSocket.addEventListener(IOErrorEvent.IO_ERROR,timelineSocket_ioErrorHandler);
			timelineSocket.addEventListener(ProgressEvent.SOCKET_DATA, timelineSocket_socketDataHandler);
			
			
			
			var s:String='';
			switch(type)
			{
				
				case GshahAssetType.VIDEO:
				{
					s+=GshahApi.CMD_VIDEO;
					break;
				}
				case GshahAssetType.IMAGE:
				{
					s+=GshahApi.CMD_IMAGE;
					break;
				}
				case GshahAssetType.ANIMATION:
				{
					s+=GshahApi.CMD_ANIMATION;
					break;
				}
				case GshahAssetType.AUDIO:
				{
					s+=GshahApi.CMD_SOUND;
					break;
				}
			}
			
			
			s+=[path,width,height,interval/1000,parts.length].join(';');
			for each (var p:Object in parts) 
			{
				s+=';'+p.s/1000+';'+p.e/1000;
			}
			if(addParams!=null)
			{
				s+=';'+addParams;
			}
			s+='|';
			trace('Thumbnailer ('+TimelineManager.instance.milisecondsPerPixel+'): '+s);
			
			if(timelineSocket!=null&&timelineSocket.connected)
			{
				
				timelineSocket.writeUTFBytes(s);
				timelineSocket.flush();
			}
			else
			{
				trace('Thumbnailer ('+TimelineManager.instance.milisecondsPerPixel+'): FAILED SOCKET CLOSED');
				
			}
		}
		
		protected function timelineSocket_ioErrorHandler(event:IOErrorEvent):void
		{
			trace(event);
		}
		
		protected function timelineSocket_socketDataHandler(event:ProgressEvent):void
		{
			var timelineSocket:Socket=event.target as Socket;
			if(timelineSocket!=null&&timelineSocket.connected)
			{
				var ba:ByteArray=new ByteArray;

				timelineSocket.readBytes(ba);
				trace('Thumbnailer: received '+ba.length);
				bufferByteArray.writeBytes(ba);
				
				
				while(bufferByteArray.length>=size)
				{
					bufferByteArray.position=0;
					
					var thumbBytes:ByteArray = new ByteArray();

					bufferByteArray.readBytes(thumbBytes,0,size);
					
					if(type==GshahAssetType.AUDIO||(height==GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT&&type==GshahAssetType.VIDEO))
					{
						
						dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,thumbBytes));
						
					}
					else
					{
						var bitmapBytes:ByteArray= new ByteArray();
						thumbBytes.position=width*4;
						thumbBytes.readBytes(bitmapBytes);

						var bd:BitmapData=new BitmapData(width,height);
						bd.setPixels(new Rectangle(0,0,bd.width,bd.height),bitmapBytes);
						dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,bd));
					}
					var _ba:ByteArray=new ByteArray;
					bufferByteArray.position=0;
					_ba.writeBytes(bufferByteArray,size);
					bufferByteArray=_ba;
					
					
				}
			}
		}
		
		public function close():void
		{
			if(timelineSocket!=null&&timelineSocket.connected)
			{
				timelineSocket.writeUTFBytes(GshahApi.CMD_QUIT);
				timelineSocket.close();
			}
			
		}
	}
}