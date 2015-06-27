package gshah.intros.texts {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
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
