package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide15 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide15(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide15AnimationController;
		}
	}
	
}
