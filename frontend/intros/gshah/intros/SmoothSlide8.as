package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide8 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide8(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide8AnimationController;
		}
	}
	
}
