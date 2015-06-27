package application.components 
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;
	
	import gshah.utils.FfmpegVideoUtils;
	
	/******
	 * 
	 * @author Dane Card 
	 * http://as3.ingogoland.com
	 * 
	 * 
	 * implementation 
	 * var ruler:Ruler = new Ruler(200, 20);
	 ******/
	public class  Ruler extends UIComponent
	{
		public var lineColor:uint = 0x000000;
		private var _pixelsPerUnit:Number = 20;
		
		public function Ruler():void 
		{					
			build();
		}
		private var lineSize:Number=10;
		
		private function build():void
		{
			removeChildren();
			lineSize=5+_pixelsPerUnit*0.2;
			var totalUnits:Number = width/pixelsPerUnit;
			for (var i:Number = 0; i <= totalUnits; i+=0.5) 
			{
				if (i% (100/pixelsPerUnit)== 0) 
				{
					drawMediumLine( i * pixelsPerUnit);					
				}
				else if (i% (20/pixelsPerUnit)== 0) 
				{
					drawSmallLine(i * pixelsPerUnit);
				} 
			}
			
			var incrementation:Number = 100/pixelsPerUnit;
			for (var j:Number = 0; j <= totalUnits; j+=incrementation) 
			{
				creatText(j * pixelsPerUnit , convertTime(j*1000));				
			}	
		} 
		
		public static function convertTime(ms:Number,accuracy:int=1):String
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
			var arr:Array=[];
			if(hours>0)
			{
				arr.push(hours+'h');
			}
			if(minutes>0)
			{
				arr.push(minutes+'m');
			}
			if(seconds>0||arr.length==0)
			{
				arr.push(seconds+'s');
			}
			return arr.join(' ');
		}
		
		[Bindable]
		public function get pixelsPerUnit():Number
		{
			return _pixelsPerUnit;
		}

		public function set pixelsPerUnit(value:Number):void
		{
			if(_pixelsPerUnit!=value)
			{
				_pixelsPerUnit = value;
				build();
			}
			
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			build();
		}
		
		private function drawLine(x:Number,lineHeight:Number):Sprite 
		{
			var line:Sprite = new Sprite();
			line.graphics.beginFill(lineColor , 1);
			line.graphics.drawRect(x , 0, 2 , lineHeight);
			
			addChild(line);
			return line;			
		}
		private function drawSmallLine(x:Number):Sprite 
		{			
			return drawLine(x,lineSize);			
		}
		
		private function drawMediumLine(x:Number ):Sprite 
		{
			return drawLine(x,lineSize*2);		
		}
		private function creatText(x:Number , textValue:String):void 
		{
			var rulerText:TextField = new TextField();
			rulerText.selectable=false;
			rulerText.embedFonts=false;
			var rulerTextFormat:TextFormat=new TextFormat;
			rulerTextFormat.font='Arial';
			rulerText.text = textValue;
			rulerText.autoSize = TextFieldAutoSize.CENTER;
			rulerText.textColor = 0xffffff;			
			rulerText.x = Math.max(0,x - (rulerText.width/2));
			rulerText.y = -17;
			rulerText.setTextFormat(rulerTextFormat);
			addChild(rulerText);
		}
	}	
}