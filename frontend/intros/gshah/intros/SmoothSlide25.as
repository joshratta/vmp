package gshah.intros {
	
	import flash.display.MovieClip;
	import gshah.IGshahAnimationController;
	
	
	public class SmoothSlide25 extends MovieClip {
		
		public var controller:IGshahAnimationController;
		public function SmoothSlide25(c:IGshahAnimationController=null) {
			controller=c as SmoothSlide25AnimationController;
		}
	}
	
}