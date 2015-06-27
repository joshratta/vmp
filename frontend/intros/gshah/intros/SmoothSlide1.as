package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide1 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide1(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide1AnimationController;
		}
	}
	
}
