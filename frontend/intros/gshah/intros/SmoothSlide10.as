package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide10 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide10(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide10AnimationController;
		}
	}
	
}
