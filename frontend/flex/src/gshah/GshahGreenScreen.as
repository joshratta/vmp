package gshah
{
	import mx.collections.ArrayCollection;
	
	import application.managers.TimelineManager;
	
	import gshah.utils.GshahUtils;
	
	public class GshahGreenScreen extends GshahAbstractService
	{		
		
		public static const DEFAULT_COLOR:uint=0x00ff00;
		public static const DEFAULT_TOLA:uint=DEFAULT_TOLB*0.98;
		public static const DEFAULT_TOLB:uint=96*2.24;

		[Bindable]
		public var selectedColor:uint=DEFAULT_COLOR; 
		
		[Bindable]
		public var tol1:Number=DEFAULT_TOLA; 
		
		[Bindable]
		public var tol2:Number=DEFAULT_TOLB; 
		
		[Bindable]
		public var colorProvider:ArrayCollection; 

		private var _tolerance:Number=DEFAULT_TOLB/2.24; 

		[Bindable]
		public function get tolerance():Number
		{
			return _tolerance;
		}

		public function set tolerance(value:Number):void
		{
			_tolerance = value;
			tol2=_tolerance*2.24;
			tol1=tol2*(100-_softness)/100;
		}
		
		private var _softness:Number=100*(1-DEFAULT_TOLA/DEFAULT_TOLB); 

		public function get softness():Number
		{
			return _softness;
		}
		
		[Bindable]
		public function set softness(value:Number):void
		{
			_softness = value;
			tol2=_tolerance*2.24;
			tol1=tol2*(100-_softness)/100;
		}

		
		public function GshahGreenScreen()
		{
			settings=new GshahSettings;
			helper=new GshahUtils;
			colorProvider=new ArrayCollection();
		}
		
		public function reset():void
		{
			selectedColor=DEFAULT_COLOR;
			tol1=DEFAULT_TOLA;
			tol2=DEFAULT_TOLB;
			colorProvider=new ArrayCollection();
		}
		
		private static var _instance:GshahGreenScreen;
		
		[Bindable]
		public static function get instance():GshahGreenScreen
		{
			if(_instance==null)
			{
				_instance=new GshahGreenScreen;
			}
			return _instance;
		}
		
		public static function set instance(value:GshahGreenScreen):void
		{
			_instance = value;
		}
	
		public var calcColors:Boolean;
		
		public var previewing:Boolean;
		
		public function getGreenScreen(calcColors:Boolean=true):void
		{
			this.calcColors=calcColors;
			if(calcColors)
			{
				colorProvider=new ArrayCollection;
			}
			
			previewing=true;
			
			GshahVideoController.instance.addAsset(TimelineManager.instance.currentItem,true);
			
			
		}
	}
}