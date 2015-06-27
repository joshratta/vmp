package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide4 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide4(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide4AnimationController;
		}
	}
	
}
