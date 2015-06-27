package gshah.intros.texts {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.EventDispatcher;
	
	public class GshahTextFont extends EventDispatcher{
		
		[Bindable]
		public var text:String;
		
		[Bindable]
		public var fontName:String;
		
		[Bindable]
		public var fontSize:Number;
		
		[Bindable]
		public var fontColor:uint;

		public function GshahTextFont(_text:String,_fontName:String,_fontSize:Number,_fontColor:uint) 
		{
			text=_text;
			fontName=_fontName;
			fontSize=_fontSize;
			fontColor=_fontColor;
		}
	}
	
}
