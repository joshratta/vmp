package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide2 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide2(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide2AnimationController;
		}
	}
	
}
