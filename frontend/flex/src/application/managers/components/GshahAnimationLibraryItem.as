package application.managers.components
{
	import gshah.IGshahAnimationController;

	[Bindable]
	public class GshahAnimationLibraryItem
	{
		public var label:String;
		public var data:Class;
		private var _controller:IGshahAnimationController;

		private var _logos:Array;

		public function get logos():Array
		{
			if(_logos==null)
			{
				_logos=new Array(controller.numLogos);
			}
			return _logos;
		}

		public function set logos(value:Array):void
		{
			_logos = value;
		}
		
		private var _videos:Array;
		
		public function get videos():Array
		{
			if(_videos==null)
			{
				_videos=new Array(controller.numLogos);
			}
			return _videos;
		}
		
		public function set videos(value:Array):void
		{
			_videos = value;
		}

		
		public function get controller():IGshahAnimationController
		{
			if(_controller==null)
			{
				_controller=new data;
			}
			return _controller;
		}

		public function set controller(value:IGshahAnimationController):void
		{
			_controller = value;
		}
		public function getDuration():Number
		{
			var c:IGshahAnimationController=new data;
			var d:Number=c.content.totalFrames/24;
			c=null;
			return d;
		}
		public var scale:Number;
		
		public var bgColor:uint;

		public function GshahAnimationLibraryItem(label:String,data:Class,bgColor:uint=0xffffff)
		{
			this.label=label;
			this.data=data;
			this.bgColor=bgColor;
		}
	}
}