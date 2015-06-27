package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class TabletSlideshow extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function TabletSlideshow(c:IGshahAnimationController=null) {
			controller=c as TabletSlideshowAnimationController;
		}
	}
	
}
