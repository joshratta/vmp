package application.components.colorpicker{
    
import flash.display.DisplayObject;

import mx.controls.colorPickerClasses.WebSafePalette;
import mx.graphics.SolidColor;

import spark.components.ComboBox;
import spark.events.DropDownEvent;
import spark.events.IndexChangeEvent;

/**
 *  Subclass DropDownList and make it work like a ColorPicker
 */
public class SparkColorPicker extends ComboBox
{

    private var wsp:WebSafePalette;
    
	
    public function SparkColorPicker()
    {
        super();
        wsp = new WebSafePalette();
        super.dataProvider = wsp.getList();
        labelFunction = blank;
        labelToItemFunction = colorFunction;
        openOnInput = false;
		this.setStyle('skinClass',ColorPickerListSkin);
		
    }
    

	
	[Bindable(event="change")]
	public function get selectedColor():int
	{
		if(current!=null)
		{
			current.color=uint(selectedItem);
			_selectedColor=uint(selectedItem);
			
		}
		return current.color;
	}

	private var _selectedColor:int;
	
	public function set selectedColor(value:int):void
	{
		selectedItem=uint(value);
		_selectedColor=uint(value);
		if(current!=null)
		{
			current.color=uint(value);

		}
		dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE));

	}

	private function colorFunction(value:String):*
    {
        return uint(value);
    }
    
   
    
    private function blank(item:Object):String
    {
        return "";
    }
    
    [SkinPart(required="false")]
    public var current:SolidColor;
        
    // don't allow anyone to set our custom DP
/*    override public function set dataProvider(value:IList):void
    {
        
    }*/
    
    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == current)
            current.color = _selectedColor;
    }
    
    override public function setFocus():void
    {
        stage.focus = this;
    }
    
    override protected function isOurFocus(target:DisplayObject):Boolean
    {
        return target == this;
    }
    
    override protected function dropDownController_closeHandler(event:DropDownEvent):void
    {
        event.preventDefault();
        super.dropDownController_closeHandler(event);
    }
}

}
