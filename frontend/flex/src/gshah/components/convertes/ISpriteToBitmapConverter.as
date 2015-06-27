package gshah.components.convertes
{
	import flash.geom.Rectangle;

	public interface ISpriteToBitmapConverter
	{
		function set callBack(value:Function):void;
		function startConversion(rect:Rectangle,start:int, end:int=-1, delta:int=1):void;
		function get templateRect():Rectangle;
		function get currentFrame():int;

	}
}