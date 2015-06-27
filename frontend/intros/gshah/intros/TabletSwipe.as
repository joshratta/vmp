package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class TabletSwipe extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function TabletSwipe(c:IGshahAnimationController=null) {
			controller=c as TabletSwipeAnimationController;
		}
	}
	
}
