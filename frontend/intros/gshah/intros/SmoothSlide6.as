package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide6 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide6(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide6AnimationController;
		}
	}
	
}
