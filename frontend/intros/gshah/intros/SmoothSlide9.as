package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide9 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide9(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide9AnimationController;
		}
	}
	
}
