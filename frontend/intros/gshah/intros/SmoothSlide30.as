package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide30 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide30(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide30AnimationController;
		}
	}
	
}
