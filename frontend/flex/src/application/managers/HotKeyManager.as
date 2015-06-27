package application.managers
{
	import application.managers.components.UndoRedoManagerItem;
	import application.managers.components.UndoRedoManagerItemType;
	
	import com.riaspace.nau.NativeApplicationUpdater;
	
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	
	import gshah.GshahVideoController;
	import gshah.entities.GshahAsset;
	import gshah.entities.GshahAssetType;
	
	import mx.core.FlexGlobals;
	
	import sys.SystemSettings;
	
	public class HotKeyManager
	{
		private static var _instance:HotKeyManager;
		[Bindable]
		public static function get instance():HotKeyManager
		{
			if(_instance==null)
			{
				_instance=new HotKeyManager;
			}
			return _instance;
		}
		
		public static function set instance(value:HotKeyManager):void
		{
			_instance = value;
		}
		
		public function HotKeyManager()
		{
		}
		
		public function initialize():void
		{
			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_DOWN,topLevelApplication_keyDownHandler);
		}
		
		public var shiftKey:Boolean;
		protected function topLevelApplication_shftKeyUpHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.SHIFT:
				{
					shiftKey=false;
					FlexGlobals.topLevelApplication.removeEventListener(KeyboardEvent.KEY_UP,topLevelApplication_shftKeyUpHandler);
					break;
				}
			}
		}
		protected function topLevelApplication_keyDownHandler(event:KeyboardEvent):void
		{
			
			switch(event.keyCode)
			{
				case Keyboard.SHIFT:
				{
					shiftKey=true;
					FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_UP,topLevelApplication_shftKeyUpHandler);
					break;
				}
				case Keyboard.SPACE:
				{
					GshahVideoController.instance.toogle();
					break;
				}
				case Keyboard.ESCAPE:
				{
					if(TimelineManager.instance.cutting)
					{
						TimelineManager.instance.cutting=false;
						TimelineManager.instance.cutChildX=TimelineManager.instance.cutMainX;
						GshahVideoController.instance.setHalt(-1);

					}
					break;
				}
				case Keyboard.Z:
				{
					if(event.ctrlKey&&UndoRedoManager.instance.itemAt(UndoRedoManager.instance.currentIndex)!=null)
					{
						UndoRedoManager.instance.undo();
					}
					break;
				}
				case Keyboard.Y:
				{
					if(event.ctrlKey&&UndoRedoManager.instance.itemAt(UndoRedoManager.instance.currentIndex+1)!=null)
					{
						UndoRedoManager.instance.redo();
					}
					break;
				}
				case Keyboard.V:
				{
					if(event.ctrlKey&&event.shiftKey&&event.altKey)
					{
						SystemSettings.updatePath=SystemSettings.updatePath==SystemSettings.RELEASE_PATH?SystemSettings.DEBUG_PATH:SystemSettings.RELEASE_PATH;
						SharedObject.getLocal('gshah').data["updatePath"]=SystemSettings.updatePath;
						
						FlexGlobals.topLevelApplication.updater.currentState=NativeApplicationUpdater.UNINITIALIZED;
						FlexGlobals.topLevelApplication.updater.initialize();
					}
					break;
				}
				case Keyboard.DELETE:
				{
					
					if(TimelineManager.instance.currentItem!=null)
					{
						var undos:Array=[];
						var redos:Array=[];
						var _a:GshahAsset=TimelineManager.instance.currentItem;
						undos.push(UndoRedoManager.addAssetFunction(_a,TimelineManager.instance.currentIndex));
						redos.push(UndoRedoManager.removeAssetFunction(_a));
						if(_a.type==GshahAssetType.ANIMATION&&GshahAnimationLibrary.instance.isOutro(_a.source.animationId))
						{
							for each (var __a:GshahAsset in TimelineManager.instance.dataProvider.source) 
							{
								if(__a.parrentUuid==_a.uuid)
								{
									undos.push(UndoRedoManager.addAssetFunction(__a,TimelineManager.instance.currentIndex));
								}
							}
						}
						TimelineManager.instance.removeAsset(_a);
						UndoRedoManager.instance.addItem(new UndoRedoManagerItem(UndoRedoManagerItemType.REMOVE,undos,redos));

					}
					break;
				}
			}
		}
	}
}