package fonts
{
	import flash.text.Font;
	import flash.text.FontType;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.globalization.StringTools;
	
	import gshah.intros.texts.GshahTextFont;
	import gshah.intros.texts.LogoStingText;
	
	public class GshahFont
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var name:String;
		
		[Bindable]
		public var fonts:ArrayCollection;
		
		public function GshahFont(_name:String,_fonts:ArrayCollection)
		{
			var labelMathes:Array=_name.match(/[A-Z][^A-Z]+/g);
			name=_name;
			label=labelMathes.join(' ');
			var styleSort:Sort=new Sort();
			styleSort.compareFunction=styleSortCompareFunction;
			_fonts.sort=styleSort;
			_fonts.refresh();
			fonts=_fonts;
			
		}
		
		private static function styleSortCompareFunction(a:Object,b:Object,fields:Array=null):int
		{
			return ObjectUtil.stringCompare(getStyleLabel(a as Font),getStyleLabel(b as Font));
		}
		
		private static var replaces:Array=[' ','italic','semibold','extrabold','light','bold','condensed','oblique','medium'];
		
		private static var fontProvider:ArrayCollection;
		
		public static function getFontProvider():ArrayCollection
		{
			if(fontProvider==null)
			{
				fontProvider=getProvider();
			}
			return fontProvider;
		}
		private static var fontAnimationProvider:ArrayCollection;
		
		public static function getFontAnimationProvider():ArrayCollection
		{
			if(fontAnimationProvider==null)
			{
				fontAnimationProvider=getAnimationFontProvider();
			}
			return fontAnimationProvider;
		}
		public static function getProvider():ArrayCollection
		{
			
			var _fonts:Array = Font.enumerateFonts();
			var _fontProvider:ArrayCollection=new ArrayCollection;
			for (var i:int = 0; i < _fonts.length; i++) 
			{
				
				var _font:Font=_fonts[i];
				
				if(_font.fontType==FontType.EMBEDDED_CFF)
				{ 						
					var fName:String=_font.fontName;
					for each (var repl:String in replaces) 
					{
						fName=fName.replace(new RegExp(repl,'gi'),'');
					}
					var added:Boolean=false;
					for each (var gf:GshahFont in _fontProvider) 
					{
						if(gf.name==fName)
						{
							gf.fonts.addItem(_font);
							added=true;
							break;
						}
					}
					
					if(!added)
					{
						
						_fontProvider.addItem(new GshahFont(fName,new ArrayCollection([_font])));
					}
				} 
				
			}
			var fontLabelSort:Sort=new Sort();
			fontLabelSort.fields=[new SortField('label')];
			_fontProvider.sort=fontLabelSort;
			_fontProvider.refresh();
			
			return _fontProvider;
		}
		public static function getAnimationFontProvider():ArrayCollection
		{
			
			var _fontProvider:ArrayCollection=new ArrayCollection;
			for (var fName:String in LogoStingText.fontObject) 
			{
				_fontProvider.addItem(fName);
			}
			var fontLabelSort:Sort=new Sort();
			_fontProvider.sort=fontLabelSort;
			_fontProvider.refresh();			
			return _fontProvider;
		}
		public static function getStyleLabel(f:Font):String
		{
			var styles:Array=[];
			if(f!=null)
			{
				var fName:String=f.fontName.replace(new RegExp(' ','gi'),'').toLowerCase()+' '+f.fontStyle.toLowerCase();
				
				if(fName.indexOf('light')!=-1)
				{
					styles.push('Light');
				}
				else if(fName.indexOf('medium')!=-1)
				{
					styles.push('Medium');
				}
				if(fName.indexOf('semibold')!=-1)
				{
					styles.push('Semibold');
				}
				else if(fName.indexOf('extrabold')!=-1)
				{
					styles.push('ExtraBold');
				}
				else if(fName.indexOf('bold')!=-1)
				{
					styles.push('Bold');
				}
				
				if(fName.indexOf('italic')!=-1)
				{
					styles.push('Italic');
				}
				else if(fName.indexOf('oblique')!=-1)
				{
					styles.push('Oblique');
				}
				
				if(fName.indexOf('condensed')!=-1)
				{
					styles.push('Condensed');
				}
				
				if(styles.length==0)
				{
					styles.push('Regular');
				}
			}
			return styles.join(' ');
		}
		
		
	}
}