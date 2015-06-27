package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide21 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide21(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide21AnimationController;
		}
	}
	
}
