package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide11 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide11(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide11AnimationController;
		}
	}
	
}
