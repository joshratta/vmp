package gshah
{
	import flash.display.Bitmap;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import gshah.intros.texts.GshahTextFont;

	public interface IGshahAnimationController
	{
		function get numTexts():int
		function get numLogos():int
		/**
		 * Gets overlay's texts
		 * @param num
		 */
		function getText(num:int):GshahTextFont;
		/**
		 * Gets overlay's logo
		 * @param num
		 */
		function getLogo(num:int):Bitmap
		/**
		 * Actually overlay animation
		 * 
		 */
		/**
		 * Sets overlay's texts
		 * @param value
		 * @param num
		 */
		function setText(value:GshahTextFont, num:int):void
		/**
		 * Sets overlay's logo
		 * @param value
		 * @param num
		 */
		function setLogo(value:Bitmap, num:int):void
		/**
		 * Actually overlay animation
		 * 
		 */
		function get content():MovieClip;
		function set content(value:MovieClip):void;
		/**
		 * The actual width of the overlay animation
		 * 
		 */
		function get contentWidth():Number;
		/**
		 * The actual height of the overlay animation
		 * 
		 */
		function get contentHeight():Number;
		/**
		 * The actual left padding to the overlay animation
		 * 
		 */
		function get contentPaddingLeft():Number;
		/**
		 * The actual top padding to the overlay animation
		 * 
		 */
		function get contentPaddingTop():Number;
	}
}