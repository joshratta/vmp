package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide7 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide7(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide7AnimationController;
		}
	}
	
}
