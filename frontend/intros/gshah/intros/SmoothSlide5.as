package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide5 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide5(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide5AnimationController;
		}
	}
	
}
