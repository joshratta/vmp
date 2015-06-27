package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide42 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide42(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide42AnimationController;
		}
	}
	
}
