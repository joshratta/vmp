package gshah
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.Font;
	import flash.utils.setTimeout;
	
	import spark.components.Group;
	import spark.components.RichText;
	import spark.layouts.HorizontalAlign;
	
	import application.managers.TimelineManager;
	import application.managers.UndoRedoManager;
	import application.managers.components.UndoRedoManagerItem;
	import application.managers.components.UndoRedoManagerItemType;
	
	import fonts.GshahFont;
	
	import gshah.components.convertes.RichTextToBitmapConverter;
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahAssetType;
	import gshah.entities.GshahSource;
	import gshah.events.GshahEvent;
	import gshah.utils.GshahAssetUtils;
	import gshah.utils.GshahUtils;
	
	public class GshahTextUI extends GshahUI
	{
		public function GshahTextUI()
		{
			super();
			input=new RichText;
			var gr:Group=new Group;
			gr.addElement(input);
			addChild(gr);
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			updateAsset();
		}		
		
		
		public static function getFontStyle(_inputFont:Font):String
		{
			return _inputFont.fontStyle.toLowerCase().indexOf('italic')==-1?'normal':'italic';
		}
		
		public static function getFontWeight(_inputFont:Font):String
		{
			return _inputFont.fontStyle.toLowerCase().indexOf('bold')==-1?'normal':'bold';
		}
		
		public static function getFontFamily(_inputFont:Font):String
		{
			return _inputFont.fontName;
		}
		
		public static function getFontAlignment(input:int):String
		{
			switch(input)
			{
				case 0:
				{
					return HorizontalAlign.LEFT;
					break;
				}
				case 1:
				{
					return HorizontalAlign.CENTER;
					break;
				}
				case 2:
				{
					return HorizontalAlign.RIGHT;
					break;
				}
				default:
				{
					return null;
					break;
				}
			}
		}
		
		public static function getFontAlignmentIndex(_currentItem:GshahAsset):int
		{
			if(_currentItem==null||_currentItem.type!=GshahAssetType.TEXT)
			{
				return 0;
			}
			else
			{
				return GshahTextUI(_currentItem.source.ui).alignmentIndex;
			}
		}
		
		public static function getFontColor(_currentItem:GshahAsset):int
		{
			if(_currentItem==null||_currentItem.type!=GshahAssetType.TEXT)
			{
				return 0x000000;
			}
			else
			{
				return GshahTextUI(_currentItem.source.ui).fontColor;
			}
		}
		public static function getFontText(_currentItem:GshahAsset):String
		{
			if(_currentItem==null||_currentItem.type!=GshahAssetType.TEXT)
			{
				return 'Your Text';
			}
			else
			{
				return GshahTextUI(_currentItem.source.ui).text;
			}
		}
		public static function getMainFont(_currentItem:GshahAsset):GshahFont
		{
			if(_currentItem==null||_currentItem.type!=GshahAssetType.TEXT)
			{
				return GshahFont.getFontProvider().getItemAt(0) as GshahFont;
			}
			else
			{
				for each (var gf:GshahFont in GshahFont.getFontProvider()) 
				{
					if(gf.fonts.getItemIndex(GshahTextUI(_currentItem.source.ui).inputFont)!=-1)
					{
						return gf;
					}
				}
				return GshahFont.getFontProvider().getItemAt(0) as GshahFont;
			}
			
		}
		
		public static function getInputFont(_currentItem:GshahAsset,_currentFont:GshahFont):Font
		{
			if(_currentItem==null||_currentItem.type!=GshahAssetType.TEXT)
			{
				return _currentFont.fonts.getItemAt(0) as Font;
			}
			else
			{
				return GshahTextUI(_currentItem.source.ui).inputFont;
				
			}
		}
		
		override protected function setSize(w:Number, h:Number):void
		{
			input.width=w;
			input.height=h;
			var sc:Number=Math.min(w/asset.source.metadata.resX,h/asset.source.metadata.resY);
			input.setStyle('fontSize',DEFAULT_FONT_SIZE*sc);
		}
		
		public function setAssetSize():void
		{
			setSize(asset.width*GshahVideoController.instance.previewVideo.width/TimelineManager.instance.width,asset.height*GshahVideoController.instance.previewVideo.width/TimelineManager.instance.width);
		}
		
		public static const DEFAULT_FONT_SIZE:Number=72;
		
		public var input:RichText;
		
		public var fontColor:uint;
		
		public var alignmentIndex:int;
		
		public var inputFont:Font;
		
		public var text:String;
		
		
		public function updateText(_inputFont:Font,_fontColor:uint,_alignmentIndex:int,_text:String,putOnTimeline:Boolean=true):void
		{
			
			input.width=NaN;
			input.height=NaN;
			inputFont=_inputFont;
			fontColor=_fontColor;
			alignmentIndex=_alignmentIndex;
			text=_text;
			input.setStyle('fontSize',DEFAULT_FONT_SIZE);
			input.setStyle('color',_fontColor);
			input.setStyle('fontFamily',getFontFamily(_inputFont));
			input.setStyle('fontStyle',getFontStyle(_inputFont));
			input.setStyle('fontWeight',getFontWeight(_inputFont));
			input.setStyle('textAlign',GshahTextUI.getFontAlignment(_alignmentIndex));
			input.text=_text;
			setTimeout(updateAsset,100,putOnTimeline);
		}
		
		[Bindable]
		public var asset:GshahAsset;
		
		private function updateAsset(putOnTimeline:Boolean=true):void
		{
			if(parent!=null&&input.text!=null&&input.text!='')
			{
				var isNew:Boolean=asset==null;
				if(isNew)
				{
					
					var gs:GshahSettings=new GshahSettings;
					gs.resX=input.measuredWidth;
					gs.resY=input.measuredHeight;
					gs.totalFrames=1;
					gs.duration=gs.totalFrames/gs.tbr;
					var s:GshahSource=new GshahSource(null,gs,GshahAssetType.TEXT);
					s.ui=this;
					
					var helper:GshahUtils=new GshahUtils;
					_portNumber=helper.getNextPortNumber();
					connectSocket();
					converter=new RichTextToBitmapConverter(input,converter_gshahCompleteHandler);
					asset=new GshahAsset(s,s.type);
					GshahAssetUtils.correctAssetSize(asset);
					if(putOnTimeline)
					{
						asset.layer=TimelineManager.instance.layersCount;
						TimelineManager.instance.layersCount++;
						TimelineManager.instance.dataProvider.addItem(asset);
						
											
					}
					else
					{
						dispatchEvent(new GshahEvent(GshahEvent.GSHAH_COMPLETE,asset));
					}
				}
				
				
				asset.source.metadata.resX=input.width;
				asset.source.metadata.resY=input.height;
				
				
				var bitmapData:BitmapData=new BitmapData(asset.source.metadata.resX*GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT/asset.source.metadata.resY,GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT,true,0);
				var matrix:Matrix = new Matrix();
				matrix.scale(GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT/asset.source.metadata.resY, GshahAssetUtils.TIMELINE_PREVIEW_DEFAULT_HEIGHT/asset.source.metadata.resY);
				bitmapData.draw(input,matrix);
				asset.source.preview=bitmapData;
				setAssetSize();
				
				GshahVideoController.instance.addAsset(asset);

				if(isNew)
				{
					UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.ADD,
						[UndoRedoManager.removeAssetFunction(asset)],[UndoRedoManager.addAssetFunction(asset,TimelineManager.instance.dataProvider.getItemIndex(asset))]));

					
				}
				
				
			}
		}
	}
}