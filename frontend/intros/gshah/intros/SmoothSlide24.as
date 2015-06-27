package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide24 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide24(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide24AnimationController;
		}
	}
	
}
