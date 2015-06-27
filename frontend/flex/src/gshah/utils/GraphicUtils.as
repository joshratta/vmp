package gshah.utils
{
	import flash.display.Graphics;

	public class GraphicUtils
	{
		public static function drawArc(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number, steps:int):void
		{
			startAngle/=360;
			arcAngle/=360
			var twoPI:Number = 2 * Math.PI;
			var angleStep:Number = arcAngle/steps;
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * radius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * radius;
			graphics.moveTo(xx, yy);
			for(var i:int=1; i<=steps; i++){
				var angle:Number = startAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				graphics.lineTo(xx, yy);
			}
		}
		
		public static function colorRound(cl:Number):int
		{
			return Math.min(255,Math.max(0,Math.round(cl)));
		}
		
		public static function yuvToRgb(yuv:Object):uint
		{
			var clU:int=yuv.u;
			var clV:int=yuv.v;
			var clY:int=yuv.y;
			
			var clB:int= colorRound(1.164*(clY - 16)+ 2.018*(clU - 128));
			var clG:int= colorRound(1.164*(clY - 16) - 0.813*(clV - 128) - 0.391*(clU - 128));
			var clR:int= colorRound(1.164*(clY - 16) + 1.596*(clV - 128));
			
			var rgbColor:uint=(clR*256+clG)*256+clB;
			
			return (clR*256+clG)*256+clB;
		}
		public static function rgbToYuv(rgb:uint):Object
		{
			if(rgb==-1)
			{
				return {y:-1, u:-1, v:-1};
			}
			var clB:int=rgb & 255;
			var clG:int=(rgb >> 8) & 255;
			var clR:int=(rgb >> 16) & 255;
			
			
			var clY:int=0.257*clR+0.504*clG+0.098*clB+16;
			var clU:int=-0.148*clR-0.291*clG+0.439*clB+128;
			var clV:int=0.439*clR-0.368*clG-0.071*clB+128;
			
			return {y:clY, u:clU, v:clV};
		}
	}
}