package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide45 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide45(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide45AnimationController;
		}
	}
	
}
