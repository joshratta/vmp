package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class QuickSlideReveal extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function QuickSlideReveal(c:IGshahAnimationController=null) {
			controller=c as QuickSlideRevealAnimationController;
		}
	}
	
}
