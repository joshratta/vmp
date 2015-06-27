package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide16 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide16(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide16AnimationController;
		}
	}
	
}
