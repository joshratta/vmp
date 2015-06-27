package gshah.intros.texts {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class LogoStingText extends MovieClip {
		
		
		public static var fontObject:Object={
			"Myriad Pro Regular":{name:"Myriad Pro", styles:[]},
			"Myriad Pro Bold":{name:"Myriad Pro Bold", styles:["<B>"]},
			"Myriad Pro Condensed":{name:"Myriad Pro Condensed", styles:[]},
			"Myriad Pro Bold Condensed":{name:"Myriad Pro Bold Condensed", styles:["<B>"]},
			"Myriad Pro Condensed":{name:"Myriad Pro Bold Condensed", styles:["<B>"]},
			"Myriad Pro Bold Condensed":{name:"Myriad Pro Condensed", styles:[]},
			"Nexa Light Regular":{name:"Nexa Light", styles:[]},
			"Nexa Bold Regular":{name:"Nexa Bold", styles:["<B>"]},
			"Myriad Pro Italic":{name:"Myriad Pro Italic", styles:["<I>"]},
			"Myriad Pro Bold":{name:"Myriad Pro", styles:[]},
			"Myriad Pro Condensed Italic":{name:"Myriad Pro Condensed Italic", styles:["<I>"]},
			"Myriad Pro Bold Condensed Italic":{name:"Myriad Pro Bold Condensed Italic", styles:["<B>", "<I>"]},
			"Helvetica Regular":{name:"Helvetica", styles:[]},
			"Lato Hairline":{name:"Lato Hairline", styles:[]},
			"Open Sans Regular":{name:"Open Sans", styles:[]},
			"Myriad Pro Condensed Italic":{name:"Myriad Pro Condensed Italic", styles:["<I>", "<I>", "<I>"]},
			"Lato Semibold":{name:"Lato Semibold", styles:[]},
			"Open Sans Semibold":{name:"Open Sans Semibold", styles:[]},
			"Helvetica-Light Regular":{name:"Helvetica Light", styles:[]},
			"Oswald Light Light":{name:"Oswald Light", styles:[]},
			"Embassy BT Regular":{name:"Embassy BT", styles:[]},
			"Myriad Pro Condensed Italic":{name:"Myriad Pro Bold Condensed", styles:["<B>"]},
			"Birch Std Regular":{name:"Birch Std", styles:[]},
			"Lato Thin":{name:"Lato Thin", styles:[]},
			"Lato Medium":{name:"Lato Medium", styles:[]},
			"Lato Regular":{name:"Lato Regular", styles:[]},
			"TypoUpright BT Regular":{name:"TypoUpright BT", styles:[]},
			"Tahoma Bold":{name:"Tahoma Bold", styles:["<B>"]},
			"Tahoma Regular":{name:"Tahoma", styles:[]},
			"Myriad Pro Bold Italic":{name:"Myriad Pro Bold Italic", styles:["<B>", "<I>"]},
			"Nexa Light Regular":{name:"Nexa Bold", styles:["<B>"]},
			"Verdana Bold Italic":{name:"Verdana Bold Italic", styles:["<B>", "<I>"]},
			"Verdana Regular":{name:"Verdana", styles:[]},
			"Verdana Bold":{name:"Verdana Bold", styles:["<B>"]},
			"Lato Bold":{name:"Lato Bold", styles:["<B>"]},
			"Tahoma Bold":{name:"Tahoma", styles:[]},
			"Arial Regular":{name:"Arial", styles:[]},
			"Gotham Book Regular":{name:"Gotham Book", styles:[]},
			"Minion Pro Medium Italic":{name:"Minion Pro Medium Italic", styles:["<I>"]},
			"Futura Bk BT":{name:"Futura Bk BT Book", styles:[]},
			"Helsinki Regular":{name:"Helsinki", styles:[]},
			"Helvetica Light Regular":{name:"Helvetica Light", styles:[]},
			"Open Sans Bold":{name:"Open Sans Bold", styles:["<B>"]},
			"Myriad Pro Condensed":{name:"Myriad Pro", styles:[]},
			"OfficinaSerifBoldCTTarm Regular":{name:"OfficinaSerifBoldCTTarm     Bold", styles:["<B>", "<I>"]},
			"Helsinki Bold":{name:"Helsinki Bold", styles:["<B>"],
			"Times New Roman Regular":{name:"Times New Roman", styles:[]}}
		}
		private static var mathes:Array=[];
		
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
				
				/*var sMatches:Array=(this['label'] as TextField).htmlText.match(/<[A-Z]+>/g);
				var str:String='"'+gtf.fontName+'":{name:"'+this['label'].htmlText.match(/FACE="([^"]+)"/)[1]+'", styles:['+(sMatches.length==0?'':('"'+sMatches.join('", "')+'"'))+']},';
				
				if(mathes.indexOf(str)==-1)
				{
					mathes.push(str);
					trace(str);
				}*/
				
				tf.font=_fontName;
				tf.size=gtf.fontSize;
				tf.color=gtf.fontColor;
				
				this['label'].htmlText=_text;
				
				(this['label'] as TextField).setTextFormat(tf);
				
			}
			
		}
	}
	
}
