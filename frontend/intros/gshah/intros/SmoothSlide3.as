package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide3 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide3(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide3AnimationController;
		}
	}
	
}
