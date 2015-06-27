package gshah
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.geom.Rectangle;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.core.UIComponent;
	
	import gshah.components.convertes.ISpriteToBitmapConverter;
	
	
	[Event(name="gshahComplete", type="gshah.events.GshahEvent")]
	public class GshahUI extends UIComponent
	{
		protected var converter:ISpriteToBitmapConverter;
		
		public var socket:Socket;
		private var serverSocket:ServerSocket;
		
		protected function connectSocket():void
		{
			serverSocket=new ServerSocket();
			serverSocket.addEventListener(Event.CONNECT, serverSocket_connectHandler);
			try
			{
				
				serverSocket.bind(_portNumber,'127.0.0.1');
				trace('listen port '+_portNumber);
				serverSocket.listen();
			} 
			catch(error:Error) 
			{
				setTimeout(connectSocket,100);
			}
			
		}
		private var sBufer:String='';
		
		protected function socket_socketDataHandler(event:ProgressEvent):void
		{
			if(socket!=null&&socket.connected&&socket==event.target)
			{
				var ba:ByteArray=new ByteArray;
				socket.readBytes(ba);
				ba.position=0;
				sBufer+=ba.toString();
				var sep:String='\r\n';
				var sArr:Array=sBufer.substr(0,sBufer.lastIndexOf(sep)).split(sep);
				for each (var _s:String in sArr) 
				{
					if(_s.length>0)
					{
						var _sArr:Array=_s.split(';');
						if(_sArr.length==4)
						{
							
							setSize(_sArr[0],_sArr[1]);
							converter.startConversion(new Rectangle(0,0,_sArr[0],_sArr[1]),_sArr[2],_sArr[3]);
							
						}
						trace('Animation streaming '+new Date().toString()+' port:'+_portNumber+' request: '+_s);
						
					}
				}
				sBufer=sBufer.substr(sBufer.lastIndexOf(sep));
			}
		}
		
		
		protected function setSize(w:Number,h:Number):void
		{
			width=w;
			height=h;
		}
		
		protected function serverSocket_connectHandler(event:ServerSocketConnectEvent):void
		{
			trace('connected port '+_portNumber);
			
			sBufer='';
			socket=event.socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socket_socketDataHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
			socket.addEventListener(Event.CLOSE, socket_closeHandler);
			
		}
		
		protected function socket_closeHandler(event:Event):void
		{
			trace('Animation streaming '+new Date().toString()+' port:'+_portNumber+' closed');
			
		}
		
		protected function socket_ioErrorHandler(event:IOErrorEvent):void
		{
			trace('Animation streaming '+new Date().toString()+' port:'+_portNumber+' ioerror');
		}
		
		public function close():void
		{
			if(serverSocket!=null)
			{
				serverSocket.removeEventListener(Event.CONNECT, serverSocket_connectHandler);
				serverSocket.close();
			}
			if(converter!=null)
			{
				converter=null;
			}
			if(socket!=null)
			{
				socket.removeEventListener(Event.CLOSE, socket_closeHandler);
				socket.removeEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
				socket.removeEventListener(ProgressEvent.SOCKET_DATA, socket_socketDataHandler);
				sBufer='';
				if(socket.connected)
				{
					socket.close();
				}
			}
		}
		protected var _portNumber:int;
		
		public function get portNumber():int
		{
			return _portNumber;
		}
		
		protected function converter_gshahCompleteHandler(data:ByteArray):void
		{
			if(converter!=null)
			{
				if(socket!=null&&socket.connected)
				{
					socket.writeInt(converter.templateRect.width);
					socket.writeInt(converter.templateRect.height);
					socket.writeInt(converter.currentFrame-2);
					
					socket.writeBytes(data);
					trace('Animation streaming '+new Date().toString()+' port:'+_portNumber+' write '+data.length+' bytes'+' w='+converter.templateRect.width+' h='+converter.templateRect.height+' frame='+(converter.currentFrame-2));
					socket.flush();
					
				}
			}
		}
		
	}
}