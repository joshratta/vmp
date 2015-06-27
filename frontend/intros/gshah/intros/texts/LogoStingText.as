package gshah.intros.texts {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class LogoStingText extends MovieClip {
		
				
		public static var fontObject:Object={
			"Myriad Pro Regular":{name:"Myriad Pro", styles:[]},
			"Myriad Pro Condensed Italic":{name:"Myriad Pro Cond", styles:["<I>"]},
			"Myriad Pro Condensed":{name:"Myriad Pro Cond", styles:[]},
			"Birch Std Regular":{name:"Birch Std", styles:[]},
			"Oswald Light Light":{name:"Oswald Light", styles:[]},
			"Embassy BT Regular":{name:"Embassy BT", styles:[]},
			"Lato Thin":{name:"Lato Thin", styles:[]},
			"Myriad Pro Bold":{name:"Myriad Pro", styles:["<B>"]},
			"Myriad Pro Bold Condensed":{name:"Myriad Pro Cond", styles:["<B>"]},
			"Nexa Bold Regular":{name:"Nexa Bold", styles:["<B>"]},
			"Lato Medium":{name:"Lato Medium", styles:[]},
			"Lato Regular":{name:"Lato", styles:[]},
			"Lato Semibold":{name:"Lato Semibold", styles:[]},
			"TypoUpright BT Regular":{name:"TypoUpright BT", styles:[]},
			"Myriad Pro Condensed Italic":{name:"Myriad Pro Cond", styles:["<B>"]},
			"Nexa Light Regular":{name:"Nexa Light", styles:[]},
			"Myriad Pro Bold Condensed Italic":{name:"Myriad Pro Cond", styles:["<B>", "<I>"]},
			"Tahoma Bold":{name:"Tahoma", styles:["<B>"]},
			"Tahoma Regular":{name:"Tahoma", styles:[]},
			"Lato Bold":{name:"Lato", styles:["<B>"]},
			"Myriad Pro Bold":{name:"Myriad Pro", styles:[]},
			"Myriad Pro Bold Italic":{name:"Myriad Pro", styles:["<B>", "<I>"]},
			"Verdana Bold Italic":{name:"Verdana", styles:["<B>", "<I>"]},
			"Nexa Light Regular":{name:"Nexa Bold", styles:["<B>"]},
			"Verdana Regular":{name:"Verdana", styles:[]},
			"Verdana Bold":{name:"Verdana", styles:["<B>"]},
			"Tahoma Bold":{name:"Tahoma", styles:[]},
			"Gotham Book Regular":{name:"Gotham Book", styles:[]},
			"Myriad Pro Italic":{name:"Myriad Pro", styles:["<I>"]},
			"Arial Regular":{name:"Arial", styles:[]},
			"Futura Bk BT":{name:"Futura Bk BT", styles:[]},
			"Minion Pro Medium Italic":{name:"Minion Pro Med", styles:["<I>"]}
		}
		
		public function LogoStingText(num:int=0) {
			var p:DisplayObjectContainer=parent;
			if(this['label']!=null)
			{
				(this['label'] as TextField).autoSize=TextFieldAutoSize.CENTER;
			}
			while(p!=null&&!(p as Object).hasOwnProperty('controller'))
			{
				p=p.parent;
			}
			if(p!=null&&(p as Object).controller!=null)
			{
				var gtf:GshahTextFont=(p as Object).controller.getText(num);
				var tf:TextFormat=(this['label'] as TextField).defaultTextFormat;
			
				

				
			var _fontName:String=gtf.fontName;
			var _text:String=gtf.text;

			if(fontObject.hasOwnProperty(gtf.fontName))
			{
				_fontName=fontObject[gtf.fontName].name;
				for each (var s:String in fontObject[gtf.fontName].styles) 
				{
					if(_text.indexOf(s)==-1)
					{
						_text=s+_text+s.replace('<','</');
					}
				}
				
			}
			
			
				tf.font=_fontName;
				tf.size=gtf.fontSize;
				tf.color=gtf.fontColor;
				
				this['label'].text=_text;
				
				(this['label'] as TextField).setTextFormat(tf);

			}
			
		}
	}
	
}
